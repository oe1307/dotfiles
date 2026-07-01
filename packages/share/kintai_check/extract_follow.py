import csv
import os
import re
import sys
from pathlib import Path

from bs4 import BeautifulSoup

DATE_RE = re.compile(r"(\d{4})年\s*(\d{1,2})月\s*(\d{1,2})日")
TIME_RE = re.compile(r"^\d{1,2}:\d{2}$")


def normalize_text(s: str) -> str:
    return re.sub(r"\s+", " ", s.replace("\xa0", " ")).strip()


def extract_date(soup: BeautifulSoup, path: Path) -> str:
    text = soup.get_text(" ", strip=True)
    m = DATE_RE.search(text)
    if m:
        y, mo, d = m.groups()
        return f"{int(y):04d}-{int(mo):02d}-{int(d):02d}"
    m2 = re.search(r"(\d{4})-(\d{2})-(\d{2})\.html$", path.name)
    if m2:
        return f"{m2.group(1)}-{m2.group(2)}-{m2.group(3)}"
    return ""


def extract_clock_times(soup: BeautifulSoup) -> tuple[str, str]:
    clock_in = ""
    clock_out = ""
    all_p = soup.find_all("p")
    for i, p in enumerate(all_p):
        label = normalize_text(p.get_text(" ", strip=True))

        if label == "出勤":
            for j in range(i + 1, min(i + 6, len(all_p))):
                value = normalize_text(all_p[j].get_text(" ", strip=True))
                if TIME_RE.match(value):
                    clock_in = value
                    break
        elif label == "退勤":
            for j in range(i + 1, min(i + 6, len(all_p))):
                value = normalize_text(all_p[j].get_text(" ", strip=True))
                if TIME_RE.match(value):
                    clock_out = value
                    break

    return clock_in, clock_out


def extract_work_rows(soup: BeautifulSoup) -> list[dict[str, str]]:
    results: list[dict[str, str]] = []

    table_wrap = soup.find(id="sagyoNaiyoList")
    if not table_wrap:
        return results

    table = table_wrap.find("table")
    if not table:
        return results

    tbody = table.find("tbody")
    if not tbody:
        return results

    for tr in tbody.find_all("tr"):
        cells = tr.find_all("td", recursive=False)

        if len(cells) < 9:
            continue

        work_label = normalize_text(cells[1].get_text(" ", strip=True))
        start_time = normalize_text(cells[2].get_text(" ", strip=True))
        end_time = normalize_text(cells[3].get_text(" ", strip=True))
        work_place = normalize_text(cells[7].get_text(" ", strip=True))
        work_duration = normalize_text(cells[8].get_text(" ", strip=True))

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
    soup = BeautifulSoup(html, "html.parser")

    date = extract_date(soup, path)
    clock_in, clock_out = extract_clock_times(soup)
    work_rows = extract_work_rows(soup)

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
    project_directory = os.path.dirname(program_file)
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

    with output_csv.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(all_records)

    print(f"Done: {output_csv}")
    print(f"rows: {len(all_records)}")
    return 0


if __name__ == "__main__":
    main()
