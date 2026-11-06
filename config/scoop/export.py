import json
import os
import shutil
import subprocess
import sys
from pathlib import Path


def is_wsl():
    if os.environ.get("WSL_DISTRO_NAME"):
        return True

    try:
        release = Path("/proc/sys/kernel/osrelease").read_text()
        return "microsoft" in release.lower()
    except OSError:
        return False


def find_powershell():
    if is_wsl():
        for name in ("pwsh.exe", "powershell.exe"):
            if path := shutil.which(name):
                return path

        for path in (
            "/mnt/c/Program Files/PowerShell/7/pwsh.exe",
            "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe",
        ):
            if Path(path).is_file():
                return path

    else:
        # Windows / Linux
        for name in ("pwsh", "powershell", "pwsh.exe", "powershell.exe"):
            if path := shutil.which(name):
                return path

    raise RuntimeError("PowerShellが見つかりません")


powershell = find_powershell()

command = (
    "$ErrorActionPreference = 'Stop'; "
    "[Console]::OutputEncoding = "
    "[System.Text.UTF8Encoding]::new($false); "
    "scoop export"
)

if is_wsl():
    command = "Set-Location $env:USERPROFILE; " + command

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

packages = json.loads(result.stdout.lstrip("\ufeff"))

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
