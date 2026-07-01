import csv
import os
import re
import sys
from html.parser import HTMLParser
from pathlib import Path
from typing import Optional

DATE_RE = re.compile(r"(\d{4})年\s*(\d{1,2})月\s*(\d{1,2})日")
TIME_RE = re.compile(r"^\d{1,2}:\d{2}$")


def normalize_text(s: str) -> str:
    return re.sub(r"\s+", " ", s.replace("\xa0", " ")).strip()


class WorkHtmlParser(HTMLParser):
    """
    BeautifulSoup を使わずに、HTML から以下を抽出する簡易パーサー。

    - HTML 全体のテキスト
    - すべての p タグのテキスト
    - id="sagyoNaiyoList" 配下の table > tbody > tr > td
    """

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)

        self.all_text_parts: list[str] = []
        self.p_texts: list[str] = []

        self.work_rows: list[list[str]] = []

        self._current_text_parts: list[str] = []

        self._in_p = False
        self._p_parts: list[str] = []

        self._in_sagyo_wrap = False
        self._sagyo_depth = 0

        self._in_table = False
        self._table_depth = 0

        self._in_tbody = False
        self._tbody_depth = 0

        self._in_tr = False
        self._tr_depth = 0
        self._current_row: list[str] = []

        self._in_td = False
        self._td_depth = 0
        self._td_parts: list[str] = []

    @staticmethod
    def _attrs_to_dict(attrs: list[tuple[str, Optional[str]]]) -> dict[str, str]:
        return {k: v or "" for k, v in attrs}

    def handle_starttag(self, tag: str, attrs: list[tuple[str, Optional[str]]]) -> None:
        attr = self._attrs_to_dict(attrs)

        if self._in_sagyo_wrap:
            self._sagyo_depth += 1

        if self._in_table:
            self._table_depth += 1

        if self._in_tbody:
            self._tbody_depth += 1

        if self._in_tr:
            self._tr_depth += 1

        if self._in_td:
            self._td_depth += 1

        if attr.get("id") == "sagyoNaiyoList" and not self._in_sagyo_wrap:
            self._in_sagyo_wrap = True
            self._sagyo_depth = 1

        if tag == "p":
            self._in_p = True
            self._p_parts = []

        if self._in_sagyo_wrap and tag == "table" and not self._in_table:
            self._in_table = True
            self._table_depth = 1

        if self._in_table and tag == "tbody" and not self._in_tbody:
            self._in_tbody = True
            self._tbody_depth = 1

        if self._in_tbody and tag == "tr" and not self._in_tr:
            self._in_tr = True
            self._tr_depth = 1
            self._current_row = []

        if self._in_tr and tag == "td" and not self._in_td:
            self._in_td = True
            self._td_depth = 1
            self._td_parts = []

    def handle_endtag(self, tag: str) -> None:
        if tag == "p" and self._in_p:
            self.p_texts.append(normalize_text(" ".join(self._p_parts)))
            self._in_p = False
            self._p_parts = []

        if tag == "td" and self._in_td:
            text = normalize_text(" ".join(self._td_parts))
            self._current_row.append(text)
            self._in_td = False
            self._td_depth = 0
            self._td_parts = []

        if tag == "tr" and self._in_tr:
            self.work_rows.append(self._current_row)
            self._in_tr = False
            self._tr_depth = 0
            self._current_row = []

        if tag == "tbody" and self._in_tbody:
            self._in_tbody = False
            self._tbody_depth = 0

        if tag == "table" and self._in_table:
            self._in_table = False
            self._table_depth = 0

        if self._in_sagyo_wrap:
            self._sagyo_depth -= 1
            if self._sagyo_depth <= 0:
                self._in_sagyo_wrap = False
                self._sagyo_depth = 0

    def handle_data(self, data: str) -> None:
        self.all_text_parts.append(data)

        if self._in_p:
            self._p_parts.append(data)

        if self._in_td:
            self._td_parts.append(data)

    def get_all_text(self) -> str:
        return normalize_text(" ".join(self.all_text_parts))


def extract_date(parser: WorkHtmlParser, path: Path) -> str:
    text = parser.get_all_text()

    m = DATE_RE.search(text)
    if m:
        y, mo, d = m.groups()
        return f"{int(y):04d}-{int(mo):02d}-{int(d):02d}"

    m2 = re.search(r"(\d{4})-(\d{2})-(\d{2})\.html$", path.name)
    if m2:
        return f"{m2.group(1)}-{m2.group(2)}-{m2.group(3)}"

    return ""


def extract_clock_times(parser: WorkHtmlParser) -> tuple[str, str]:
    clock_in = ""
    clock_out = ""

    all_p = parser.p_texts

    for i, label in enumerate(all_p):
        label = normalize_text(label)

        if label == "出勤":
            for j in range(i + 1, min(i + 6, len(all_p))):
                value = normalize_text(all_p[j])
                if TIME_RE.match(value):
                    clock_in = value
                    break

        elif label == "退勤":
            for j in range(i + 1, min(i + 6, len(all_p))):
                value = normalize_text(all_p[j])
                if TIME_RE.match(value):
                    clock_out = value
                    break

    return clock_in, clock_out


def extract_work_rows(parser: WorkHtmlParser) -> list[dict[str, str]]:
    results: list[dict[str, str]] = []

    for cells in parser.work_rows:
        if len(cells) < 9:
            continue

        work_label = normalize_text(cells[1])
        start_time = normalize_text(cells[2])
        end_time = normalize_text(cells[3])
        work_place = normalize_text(cells[7])
        work_duration = normalize_text(cells[8])

        if not work_label:
            continue

        if "休憩" in work_label:
            continue

        if "勤務" not in work_label:
            continue

        if not TIME_RE.match(start_time) or not TIME_RE.match(end_time):
            continue

        results.append(
            {
                "work_label": work_label,
                "start_time": start_time,
                "end_time": end_time,
                "work_place": work_place,
                "work_duration": work_duration,
            }
        )

    return results


def parse_html_file(path: Path) -> list[dict[str, str]]:
    html = path.read_text(encoding="utf-8", errors="ignore")

    parser = WorkHtmlParser()
    parser.feed(html)
    parser.close()

    date = extract_date(parser, path)
    clock_in, clock_out = extract_clock_times(parser)
    work_rows = extract_work_rows(parser)

    records: list[dict[str, str]] = []

    for row in work_rows:
        records.append(
            {
                "date": date,
                "clock_in": clock_in,
                "clock_out": clock_out,
                "work_label": row["work_label"],
                "start_time": row["start_time"],
                "end_time": row["end_time"],
                "work_place": row["work_place"],
                "work_duration": row["work_duration"],
                "source_file": path.name,
            }
        )

    return records


def main() -> int:
    program_file = sys.argv[0]
    project_directory = os.path.dirname(os.path.abspath(program_file))

    html_dir = Path(os.path.expanduser(f"{project_directory}/follow"))
    output_csv = Path(os.path.expanduser(f"{project_directory}/chatGPT/follow.csv"))

    if not html_dir.exists() or not html_dir.is_dir():
        print(f"ERROR: directory not found: {html_dir}")
        return 1

    html_files = sorted(html_dir.glob("*.html"))
    if not html_files:
        print(f"ERROR: no .html files found in: {html_dir}")
        return 1

    all_records: list[dict[str, str]] = []

    for html_file in html_files:
        try:
            records = parse_html_file(html_file)
            print(f"{html_file.name}: {len(records)} rows")
            all_records.extend(records)
        except Exception as e:
            print(f"WARNING: failed to parse {html_file.name}: {e}")

    all_records.sort(
        key=lambda rec: (
            rec["date"],
            rec["start_time"],
            rec["end_time"],
            rec["source_file"],
        )
    )

    fieldnames = [
        "date",
        "clock_in",
        "clock_out",
        "work_label",
        "start_time",
        "end_time",
        "work_place",
        "work_duration",
        "source_file",
    ]

    output_csv.parent.mkdir(parents=True, exist_ok=True)

    with output_csv.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(all_records)

    print(f"Done: {output_csv}")
    print(f"rows: {len(all_records)}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
