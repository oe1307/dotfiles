import csv
import html
import os
import re
import sys
from dataclasses import dataclass
from datetime import date, datetime, timedelta
from html.parser import HTMLParser
from pathlib import Path
from typing import Iterable, List, Optional


@dataclass
class KintaiEvent:
    timestamp_label: str
    dt: datetime
    sender: str
    work_type: str
    action: str
    person_name: Optional[str]
    mention: Optional[str]
    message_text: str

    @property
    def status(self) -> str:
        return "start" if self.action == "開始" else "end"


WORK_PATTERNS = [
    ("自宅", "開始", re.compile(r"在宅勤務を開始します")),
    ("自宅", "終了", re.compile(r"在宅勤務を終了します")),
    ("勤務事業所", "開始", re.compile(r"武蔵野勤務を開始します")),
    ("勤務事業所", "終了", re.compile(r"武蔵野勤務を終了します")),
    ("出張", "開始", re.compile(r"出張勤務を開始します")),
    ("出張", "終了", re.compile(r"出張勤務を終了します")),
    ("出張", "開始", re.compile(r"リモート・シェアオフィス勤務を開始します")),
    ("出張", "終了", re.compile(r"リモート・シェアオフィス勤務を終了します")),
    ("出張", "開始", re.compile(r"横須賀勤務を開始します")),
    ("出張", "終了", re.compile(r"横須賀勤務を終了します")),
    ("出張", "開始", re.compile(r"品川勤務を開始します")),
    ("出張", "終了", re.compile(r"品川勤務を終了します")),
    ("休憩", "開始", re.compile(r"なか抜けします")),
    ("休憩", "終了", re.compile(r"なか抜けからもどりました")),
]

PERSON_RE = re.compile(r"[（(]\s*([^@()（）]+?)\s*(?=<span|@|[)）])")
MENTION_RE = re.compile(r"@[^()（）]+?(?=\s*[)）])")
DATE_RE = re.compile(r"(?:(\d{1,2})月(\d{1,2})日|今日|昨日)\s+(\d{1,2}):(\d{2})")


def parse_timestamp(label: str, base_year: int, today: date) -> datetime:
    label = re.sub(r"\s+", " ", label).strip()
    m = DATE_RE.search(label)
    if not m:
        raise ValueError(f"日時を解釈できません: {label}")

    if label.startswith("今日"):
        y, mo, d = today.year, today.month, today.day
    elif label.startswith("昨日"):
        yesterday = today - timedelta(days=1)
        y, mo, d = yesterday.year, yesterday.month, yesterday.day
    else:
        mo = int(m.group(1))
        d = int(m.group(2))
        y = base_year

    hh = int(m.group(3))
    mm = int(m.group(4))
    return datetime(y, mo, d, hh, mm)


def normalize_text(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip()


def extract_message_info(
    message_text: str,
) -> tuple[Optional[str], Optional[str], Optional[str], Optional[str]]:
    work_type = action = None

    for wt, act, pat in WORK_PATTERNS:
        if pat.search(message_text):
            work_type = wt
            action = act
            break

    person_name = None
    mention = None

    m_person = PERSON_RE.search(message_text)
    if m_person:
        person_name = normalize_text(m_person.group(1))

    m_mention = MENTION_RE.findall(message_text)
    if m_mention:
        mention = normalize_text(m_mention[-1])

    return work_type, action, person_name, mention


class SlackHtmlParser(HTMLParser):
    TARGET_TIMESTAMP = "timestamp_label"
    TARGET_MESSAGE = "message-text"
    TARGET_SENDER = "message_sender_name"

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)

        self.items: list[dict[str, str]] = []

        self._in_listitem = False
        self._listitem_depth = 0
        self._current_item: dict[str, str] | None = None

        self._capture_target: str | None = None
        self._capture_depth = 0
        self._capture_parts: list[str] = []

    @staticmethod
    def _attrs_to_dict(attrs: list[tuple[str, Optional[str]]]) -> dict[str, str]:
        return {k: v or "" for k, v in attrs}

    def handle_starttag(self, tag: str, attrs: list[tuple[str, Optional[str]]]) -> None:
        attr = self._attrs_to_dict(attrs)

        if self._in_listitem:
            self._listitem_depth += 1

        if tag == "div" and attr.get("role") == "listitem" and not self._in_listitem:
            self._in_listitem = True
            self._listitem_depth = 1
            self._current_item = {
                "timestamp_label": "",
                "message_text": "",
                "sender": "",
            }

        if not self._in_listitem:
            return

        data_qa = attr.get("data-qa")

        if data_qa == self.TARGET_TIMESTAMP:
            self._start_capture("timestamp_label")
        elif data_qa == self.TARGET_MESSAGE:
            self._start_capture("message_text")
        elif data_qa == self.TARGET_SENDER:
            self._start_capture("sender")
        elif self._capture_target is not None:
            self._capture_depth += 1

    def handle_endtag(self, tag: str) -> None:
        if not self._in_listitem:
            return

        if self._capture_target is not None:
            self._capture_depth -= 1

            if self._capture_depth <= 0:
                self._end_capture()

        self._listitem_depth -= 1

        if self._listitem_depth <= 0:
            if self._current_item is not None:
                self.items.append(self._current_item)

            self._in_listitem = False
            self._listitem_depth = 0
            self._current_item = None
            self._capture_target = None
            self._capture_depth = 0
            self._capture_parts = []

    def handle_data(self, data: str) -> None:
        if self._capture_target is not None:
            self._capture_parts.append(data)

    def handle_entityref(self, name: str) -> None:
        if self._capture_target is not None:
            self._capture_parts.append(html.unescape(f"&{name};"))

    def handle_charref(self, name: str) -> None:
        if self._capture_target is not None:
            self._capture_parts.append(html.unescape(f"&#{name};"))

    def _start_capture(self, target: str) -> None:
        self._capture_target = target
        self._capture_depth = 1
        self._capture_parts = []

    def _end_capture(self) -> None:
        if self._current_item is not None and self._capture_target is not None:
            text = normalize_text(" ".join(self._capture_parts))

            current = self._current_item.get(self._capture_target, "")
            if current:
                self._current_item[self._capture_target] = normalize_text(
                    f"{current} {text}"
                )
            else:
                self._current_item[self._capture_target] = text

        self._capture_target = None
        self._capture_depth = 0
        self._capture_parts = []


def parse_html(html_text: str, base_year: int, today: date) -> List[KintaiEvent]:
    parser = SlackHtmlParser()
    parser.feed(html_text)
    parser.close()

    events: List[KintaiEvent] = []

    for item in parser.items:
        timestamp_label = normalize_text(item.get("timestamp_label", ""))
        message_text = normalize_text(item.get("message_text", ""))
        sender = normalize_text(item.get("sender", ""))

        if not timestamp_label or not message_text:
            continue

        work_type, action, person_name, mention = extract_message_info(message_text)
        if not work_type or not action:
            continue

        dt = parse_timestamp(timestamp_label, base_year=base_year, today=today)

        events.append(
            KintaiEvent(
                timestamp_label=timestamp_label,
                dt=dt,
                sender=sender,
                work_type=work_type,
                action=action,
                person_name=person_name,
                mention=mention,
                message_text=message_text,
            )
        )

    events.sort(key=lambda e: e.dt)
    return events


def write_events_csv(path: Path, events: Iterable[KintaiEvent]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)

    with path.open("w", newline="", encoding="utf-8-sig") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                "datetime",
                "date",
                "time",
                "timestamp_label",
                "sender",
                "work_type",
                "action",
                "status",
                "person_name",
                "mention",
                "message_text",
            ],
        )
        writer.writeheader()

        for e in events:
            writer.writerow(
                {
                    "datetime": e.dt.isoformat(sep=" ", timespec="minutes"),
                    "date": e.dt.date().isoformat(),
                    "time": e.dt.strftime("%H:%M"),
                    "timestamp_label": e.timestamp_label,
                    "sender": e.sender,
                    "work_type": e.work_type,
                    "action": e.action,
                    "status": e.status,
                    "person_name": e.person_name or "",
                    "mention": e.mention or "",
                    "message_text": e.message_text,
                }
            )


def main() -> None:
    if len(sys.argv) < 2:
        print("使い方: python script.py input.html")
        sys.exit(1)

    program_file = sys.argv[0]
    project_directory = os.path.dirname(os.path.abspath(program_file))

    input_html = sys.argv[1]
    path, _ = os.path.splitext(input_html)
    filename = os.path.basename(path)

    output_csv = os.path.expanduser(f"{project_directory}/chatGPT/{filename}.csv")

    html_text = Path(input_html).read_text(encoding="utf-8")

    today = date.today()
    events = parse_html(html_text, base_year=today.year, today=today)

    write_events_csv(Path(output_csv), events)

    print(f"events:   {len(events)} 件 -> {output_csv}")

    if events:
        print(
            f"期間: {events[0].dt.isoformat(sep=' ', timespec='minutes')}"
            f"～{events[-1].dt.isoformat(sep=' ', timespec='minutes')}"
        )
    else:
        print("対象イベントは見つかりませんでした")


if __name__ == "__main__":
    main()
