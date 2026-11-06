import json
import shutil
import subprocess
import sys
from pathlib import Path

# PowerShell 7があれば優先し、なければWindows PowerShellを使う
powershell = shutil.which("pwsh") or shutil.which("powershell")

if powershell is None:
    raise RuntimeError("PowerShellが見つかりません")

command = (
    "$ErrorActionPreference = 'Stop'; "
    "[Console]::OutputEncoding = "
    "[System.Text.UTF8Encoding]::new($false); "
    "scoop export"
)

try:
    result = subprocess.run(
        [
            powershell,
            "-NoLogo",
            "-NoProfile",
            "-Command",
            command,
        ],
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        check=True,
    )
except subprocess.CalledProcessError as error:
    print("scoop export に失敗しました。", file=sys.stderr)
    print(error.stderr, file=sys.stderr)
    raise

packages = json.loads(result.stdout)

for bucket in packages.get("buckets", []):
    bucket.pop("Updated", None)
    bucket.pop("Manifests", None)

packages["buckets"].sort(key=lambda item: item.get("Name", ""))

for app in packages.get("apps", []):
    app.pop("Version", None)
    app.pop("Updated", None)
    app.pop("Info", None)

packages["apps"].sort(key=lambda item: item.get("Name", ""))

packages["apps"] = [
    {
        "Name": app.get("Name", ""),
        "Source": app.get("Source", ""),
    }
    for app in packages.get("apps", [])
]

packages = {
    "buckets": packages.get("buckets", []),
    "apps": packages.get("apps", []),
}

output_path = Path(__file__).with_name("packages.json")

with output_path.open("w", encoding="utf-8", newline="\n") as file:
    json.dump(
        packages,
        file,
        ensure_ascii=False,
        indent=2,
    )
    file.write("\n")

print(f"Exported: {output_path}")
