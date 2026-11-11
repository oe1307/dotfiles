#!/usr/bin/env bash
set -euo pipefail

# Resolve symlinks too, so this launcher can be put in ~/bin.
script_path="$(readlink -f -- "${BASH_SOURCE[0]}")"
script_dir="$(dirname -- "$script_path")"
ps_file="$script_dir/packages.ps1"

if [[ ! -f "$ps_file" ]]; then
    printf 'Cannot find %s\n' "$ps_file" >&2
    exit 1
fi

if command -v pwsh.exe >/dev/null 2>&1; then
    powershell_cmd=pwsh.exe
elif command -v powershell.exe >/dev/null 2>&1; then
    powershell_cmd=powershell.exe
else
    printf 'Windows PowerShell was not found. Check WSL interop.\n' >&2
    exit 1
fi

exec "$powershell_cmd" -NoLogo -NoProfile -ExecutionPolicy Bypass \
    -File "$(wslpath -w "$ps_file")"
