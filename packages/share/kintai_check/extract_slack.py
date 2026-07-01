import csv
import os
import re
import sys
from dataclasses import dataclass
from datetime import date, datetime, timedelta
from pathlib import Path
from typing import Iterable, List, Optional

from bs4 import BeautifulSoup


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


def parse_html(html: str, base_year: int, today: date) -> List[KintaiEvent]:
    soup = BeautifulSoup(html, "html.parser")
    events: List[KintaiEvent] = []

    for item in soup.select('div[role="listitem"]'):
        ts_el = item.select_one('[data-qa="timestamp_label"]')
        msg_el = item.select_one('[data-qa="message-text"]')
        sender_el = item.select_one('[data-qa="message_sender_name"]')
        if not ts_el or not msg_el:
            continue

        timestamp_label = normalize_text(ts_el.get_text(" ", strip=True))
        message_text = normalize_text(msg_el.get_text(" ", strip=True))
        sender = (
            normalize_text(sender_el.get_text(" ", strip=True)) if sender_el else ""
        )

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
    program_file = sys.argv[0]
    project_directory = os.path.dirname(program_file)
    input_html = sys.argv[1]
    path, _ = os.path.splitext(input_html)
    filename = os.path.basename(path)
    output_csv = os.path.expanduser(f"{project_directory}/chatGPT/{filename}.csv")

    html = Path(input_html).read_text(encoding="utf-8")
    events = parse_html(html, base_year=date.today().year, today=date.today())
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
