file="$(brew --repository)/Library/Homebrew/bundle/extensions/winget.rb"

cp "$file" "${file}.bak"

python3 - "$file" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text()

old = '''          if !export.is_a?(Hash) || !export["Sources"].is_a?(Array)
            raise "Invalid WinGet export: expected Sources array"
          end'''

new = '''          raise "Invalid WinGet export: expected object" unless export.is_a?(Hash)
          return [] unless export.key?("Sources")
          raise "Invalid WinGet export: expected Sources array" unless export["Sources"].is_a?(Array)'''

if old not in text:
    sys.exit("Homebrew implementation differs; no changes made")

path.write_text(text.replace(old, new, 1))
print("Patched Homebrew WinGet export parser")
PY
