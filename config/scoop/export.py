import json
import subprocess

subprocess.run("scoop export > packages.json", shell=True, check=True)

packages = json.load(open("packages.json"))

for bucket in packages.get("buckets", []):
    bucket.pop("Updated", None)
    bucket.pop("Manifests", None)
packages["buckets"].sort(key=lambda x: x["Name"])

for app in packages.get("apps", []):
    app.pop("Version", None)
    app.pop("Updated", None)
    app.pop("Info", None)
packages["apps"].sort(key=lambda x: x.get("Name", ""))
packages["apps"] = [
    {"Name": app.get("Name", ""), "Source": app.get("Source", "")}
    for app in packages.get("apps", [])
]

packages = {
    "buckets": packages.get("buckets", []),
    "apps": packages.get("apps", []),
}

json.dump(packages, open("packages.json", "w"), indent=2)
