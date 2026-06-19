#!/usr/bin/env bash
# Start a local HTTP server for the html-lessons workspace and expose it
# via a Cloudflare Quick Tunnel. Lets you preview lessons before pushing.
#
# Usage:
#   bin/serve.sh                   # default port 8765
#   bin/serve.sh --port 9000
#   bin/serve.sh --no-tunnel       # http server only
#
# Prints:
#   - local URL
#   - public trycloudflare URL
#   - PIDs and log file paths for both

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PORT=8765
WITH_TUNNEL=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --port) PORT="$2"; shift 2 ;;
    --no-tunnel) WITH_TUNNEL=false; shift ;;
    --help|-h) sed -n '2,14p' "$0"; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 1 ;;
  esac
done

# kill anything on the port already
pkill -f "http.server $PORT" 2>/dev/null || true
sleep 0.2

# start the http server
LOG="/tmp/html-lessons-http.log"
setsid nohup python3 -m http.server "$PORT" --bind 127.0.0.1 \
  --directory "$ROOT" >"$LOG" 2>&1 </dev/null &
disown
sleep 0.5

if ! ss -ltn 2>/dev/null | grep -q ":$PORT "; then
  echo "error: http server didn't start on port $PORT" >&2
  echo "  log: $LOG" >&2
  exit 1
fi

echo "local:  http://127.0.0.1:$PORT/"
echo "  log:  $LOG"
echo

if $WITH_TUNNEL; then
  TUNNEL_LOG=$(ls -1t /tmp/trycloudflare-*.log 2>/dev/null | head -1 || true)
  bash /home/laborant/.agents/skills/create-tunnel/scripts/create_tunnel.sh \
    cloudflare-try \
    --url "http://127.0.0.1:$PORT" \
    --background true \
    --verify false
fi
