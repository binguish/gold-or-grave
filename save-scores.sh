#!/bin/bash
# Publish the scoreboard so everyone sees it.
# 1. On the page, click "Export data" (copies the JSON to your clipboard).
# 2. Run this script:  ./save-scores.sh
#    (or pass a file instead of using the clipboard: ./save-scores.sh scores.json)
set -euo pipefail
cd "$(dirname "$0")"

if [ $# -ge 1 ]; then RAW=$(cat "$1"); else RAW=$(pbpaste); fi

printf '%s' "$RAW" | python3 -c '
import json, sys, datetime
try:
    d = json.load(sys.stdin)
except Exception:
    sys.exit("Clipboard is not JSON - click Export data on the page first.")
if not isinstance(d.get("days"), dict):
    sys.exit("JSON has no days - click Export data on the page first.")
d["version"] = d.get("version", 2)
d["updated"] = datetime.datetime.now().astimezone().isoformat(timespec="seconds")
with open("data.json", "w") as f:
    json.dump(d, f, indent=2, sort_keys=True)
    f.write("\n")
n = len(d["days"])
print("data.json written:", n, "day(s)")
'

git add data.json
if git diff --cached --quiet; then
  echo "No score changes to publish."
  exit 0
fi
git commit -m "Update scores"
git push
echo "Published - live in ~1 min at https://binguish.github.io/gold-or-grave/"
