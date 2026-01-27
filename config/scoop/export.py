import json

import os

os.system("scoop export > packages.json")

packages = json.load(open("packages.json"))

for bucket in packages.get("buckets", []):
    bucket.pop("Updated", None)
    bucket.pop("Manifests", None)
packages["buckets"].sort(key=lambda x: x["Name"])

for app in packages.get("apps", []):
    app.pop("Version", None)
    app.pop("Updated", None)
    app.pop("Info", None)
packages["apps"].sort(key=lambda x: x["Name"])

packages = {
    "buckets": packages.get("buckets", []),
    "apps": packages.get("apps", []),
}

json.dump(packages, open("packages.json", "w"), indent=2)
