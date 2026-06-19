#!/usr/bin/env bash
# Commit all changes, push to origin/main, and wait for GitHub Pages to
# deploy. Prints the status of every HTML endpoint under topics/.
#
# Usage:
#   bin/publish.sh "Add Python asyncio topic"
#   bin/publish.sh                       # auto-generated message
#
# Exits non-zero if Pages fails to deploy within ~2 minutes.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ -n "${1:-}" ]]; then
  MSG="$1"
else
  CHANGED=$(git status --short | wc -l | tr -d ' ')
  MSG="Update html-lessons ($CHANGED files)"
fi

# fail fast if there's no remote
git fetch origin main --quiet 2>/dev/null || {
  echo "error: cannot reach origin/main" >&2
  exit 1
}

git add -A

# nothing to commit? skip the push
if git diff --cached --quiet; then
  echo "nothing to commit"
  exit 0
fi

git -c user.name="${GIT_AUTHOR_NAME:-html-lessons bot}" \
    -c user.email="${GIT_AUTHOR_EMAIL:-bot@users.noreply.github.com}" \
    commit -m "$MSG"

git push origin main

# --- wait for Pages to deploy ----------------------------------------------
python3 - <<'PY'
import socket, ssl, subprocess, time, sys

# discover the GH Pages host from `gh api`
try:
    out = subprocess.check_output(
        ["gh", "api", "repos/nrayyagari/html-lessons/pages"],
        text=True,
    )
    import json
    info = json.loads(out)
    html_url = info["html_url"].rstrip("/")
except Exception as e:
    print(f"  (could not query gh api: {e}; using fallback host)")
    html_url = "https://nrayyagari.github.io/html-lessons"

print(f"  waiting for Pages to serve {html_url}/ …")

# build the list of topics to verify
import os
topics_root = os.path.join(os.path.dirname(__file__) if "__file__" in dir() else ".", "..", "topics")
paths = ["/html-lessons/"]
for d in sorted(os.listdir(topics_root)):
    full = os.path.join(topics_root, d)
    if not os.path.isdir(full): continue
    paths.append(f"/html-lessons/topics/{d}/")
    for f in sorted(os.listdir(full)):
        if f.endswith(".html"):
            paths.append(f"/html-lessons/topics/{d}/{f}")
    # also probe the assets
    for f in ("main.css", "quiz.js"):
        if os.path.exists(os.path.join(full, "assets", f)):
            paths.append(f"/html-lessons/topics/{d}/assets/{f}")

host = "nrayyagari.github.io"
ip = socket.gethostbyname(host)
ctx = ssl.create_default_context()

def fetch(path):
    s = socket.create_connection((ip, 443), timeout=10)
    ss = ctx.wrap_socket(s, server_hostname=host)
    ss.sendall(f"GET {path} HTTP/1.1\r\nHost: {host}\r\nConnection: close\r\n\r\n".encode())
    data = b""
    while True:
        chunk = ss.recv(8192)
        if not chunk: break
        data += chunk
    ss.close()
    return data.partition(b"\r\n\r\n")[0].split(b"\r\n", 1)[0].decode()

ok = False
for i in range(40):                                  # ~3 minutes max
    statuses = [fetch(p) for p in paths]
    bad = [(p, s) for p, s in zip(paths, statuses) if "200" not in s]
    print(f"  try {i+1:>2}: {len(paths)-len(bad)}/{len(paths)} OK")
    if not bad:
        print("all endpoints 200 ✓")
        ok = True
        break
    time.sleep(5)

if not ok:
    print("still failing after 3 minutes — check Pages deploy log:")
    print(f"  {html_url.replace('https://', 'https://github.com/nrayyagari/html-lessons/deployments')}")
    sys.exit(1)
PY
