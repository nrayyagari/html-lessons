#!/usr/bin/env bash
# Create a new topic folder from template/, naming it with the standard
# <day><ord>-<month>-<topic> convention. Copies assets from an existing
# topic (the most-recent one by default) so the new topic is visually
# identical to its siblings.
#
# Usage:
#   bin/new-topic.sh "Python asyncio"
#   bin/new-topic.sh "Python asyncio" 2026-07-04
#   bin/new-topic.sh "Python asyncio" 2026-07-04 "Async I/O, gather, queues, libraries"
#   bin/new-topic.sh --from-go "Python asyncio"   # use Go topic as the assets source
#
# What it does:
#   1. Computes the folder name (e.g. 4th-july-python-asyncio)
#   2. Creates topics/<folder>/ with the standard layout
#   3. Copies assets/ from the chosen source topic (so the new topic is
#      visually identical; you can edit ./assets/main.css later to diverge)
#   4. Renders template/topic-index.html, cheatsheet.md, learning-record.md
#      with the topic name and date substituted
#
# What it does NOT do:
#   - It does NOT write any lessons — you (or the agent) do that.
#   - It does NOT update the root index.html — add a card once you have
#     at least one lesson.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE="$ROOT/template"
TOPICS="$ROOT/topics"

# --- argument parsing -------------------------------------------------------
DATE=""
DESCRIPTION=""
ASSETS_SOURCE="latest"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --from-go)         ASSETS_SOURCE="19th-june-go-structs-and-pointers"; shift ;;
    --from-latest)     ASSETS_SOURCE="latest"; shift ;;
    --help|-h)
      sed -n '2,24p' "$0"; exit 0 ;;
    -*)  echo "unknown flag: $1" >&2; exit 1 ;;
    *)
      if [[ -z "${TOPIC_NAME:-}" ]]; then TOPIC_NAME="$1"
      elif [[ -z "$DATE" ]]; then DATE="$1"
      elif [[ -z "$DESCRIPTION" ]]; then DESCRIPTION="$1"
      fi
      shift
      ;;
  esac
done

if [[ -z "${TOPIC_NAME:-}" ]]; then
  echo "usage: bin/new-topic.sh <topic-name> [YYYY-MM-DD] [description]" >&2
  exit 1
fi

# --- helpers ----------------------------------------------------------------
ordinal() {
  local n=$1
  if (( n % 100 >= 11 && n % 100 <= 13 )); then echo "${n}th"; return; fi
  case $(( n % 10 )) in
    1) echo "${n}st" ;;
    2) echo "${n}nd" ;;
    3) echo "${n}rd" ;;
    *) echo "${n}th" ;;
  esac
}

month_name() {
  case "$1" in
    01) echo january ;; 02) echo february ;; 03) echo march ;;
    04) echo april   ;; 05) echo may      ;; 06) echo june ;;
    07) echo july    ;; 08) echo august   ;; 09) echo september ;;
    10) echo october ;; 11) echo november ;; 12) echo december ;;
  esac
}

month_name_cap() {
  echo "$(month_name "$1" | sed -E 's/^(.)/\U\1/')"
}

slugify() {
  echo "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'
}

# --- compute folder name ----------------------------------------------------
if [[ -z "$DATE" ]]; then DATE="$(date +%Y-%m-%d)"; fi
YEAR="${DATE%%-*}"; rest="${DATE#*-}"; MONTH="${rest%%-*}"; DAY="${rest##*-}"
DAY=$((10#$DAY))                          # strip leading zero
FOLDER="$(ordinal "$DAY")-$(month_name "$MONTH")-$(slugify "$TOPIC_NAME")"
DEST="$TOPICS/$FOLDER"

if [[ -d "$DEST" ]]; then
  echo "error: $DEST already exists" >&2
  exit 1
fi

# --- pick assets source -----------------------------------------------------
case "$ASSETS_SOURCE" in
  latest)
    SOURCE="$(ls -1d "$TOPICS"/*/ 2>/dev/null | sort | tail -1 || true)"
    if [[ -z "$SOURCE" ]]; then
      echo "error: no existing topic to copy assets from" >&2
      echo "  create one first, or pass --from-go" >&2
      exit 1
    fi
    ;;
  *) SOURCE="$TOPICS/$ASSETS_SOURCE" ;;
esac

if [[ ! -d "$SOURCE/assets" ]]; then
  echo "error: $SOURCE has no assets/ to copy" >&2
  exit 1
fi

# --- render the topic -------------------------------------------------------
DATE_DISPLAY="$DAY $(month_name_cap "$MONTH") $YEAR"   # e.g. "4 July 2026"
TOPIC_TITLE="$TOPIC_NAME"
DESCRIPTION="${DESCRIPTION:-One-line description of what this topic covers.}"

mkdir -p "$DEST/assets"
cp "$SOURCE/assets/main.css" "$DEST/assets/main.css"
cp "$SOURCE/assets/quiz.js"  "$DEST/assets/quiz.js"

# render templates
render() {
  local src=$1
  local out=$2
  # python str.replace is faster + safer than sed for this many substitutions
  python3 - "$src" "$out" <<PY
import sys
src, out = sys.argv[1], sys.argv[2]
slug = """$(slugify "$TOPIC_NAME")"""
with open(src, 'r') as f: t = f.read()
t = (t
     .replace("{{TOPIC_TITLE}}",   """$TOPIC_TITLE""")
     .replace("{{TOPIC_NAME}}",    """$TOPIC_NAME""")
     .replace("{{TOPIC_SLUG}}",    slug)
     .replace("{{DATE_DISPLAY}}",  """$DATE_DISPLAY""")
     .replace("{{DATE_ISO}}",      """$DATE""")
     .replace("{{DESCRIPTION}}",   """$DESCRIPTION"""))
with open(out, 'w') as f: f.write(t)
PY
}

render "$TEMPLATE/topic-index.html"   "$DEST/index.html"
render "$TEMPLATE/cheatsheet.md"      "$DEST/cheatsheet.md"
render "$TEMPLATE/learning-record.md" "$DEST/learning-record.md"

# --- summary ----------------------------------------------------------------
cat <<EOF

created topic: $DEST
  - assets/  copied from $SOURCE
  - index.html, cheatsheet.md, learning-record.md  rendered from template/

next steps:
  1. write lesson files: 01-..., 02-..., ... in $DEST/
  2. add a card to the grid in index.html (at the repo root)
  3. commit + push:        bin/publish.sh "Add $TOPIC_TITLE topic"
  4. (optional) preview locally:  bin/serve.sh

Pages URL pattern (after first push):
  https://<user>.github.io/html-lessons/topics/$FOLDER/
EOF
