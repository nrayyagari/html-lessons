# bin/ — standardized workflow scripts

Each script does one thing. Use them in order when adding a new topic.

## `new-topic.sh` — bootstrap a topic folder

Creates `topics/<day><ord>-<month>-<slug>/` from `template/`, copies the
visual assets from the most recent existing topic, and renders the
topic index, cheatsheet, and learning record with placeholders
substituted.

```bash
bin/new-topic.sh "Python asyncio"                       # uses today's date
bin/new-topic.sh "Python asyncio" 2026-07-04            # explicit date
bin/new-topic.sh "Python asyncio" 2026-07-04 "Async I/O, gather, queues, libraries"
bin/new-topic.sh --from-go "Python asyncio"              # use Go topic assets instead
```

After it runs:

1. Write lesson HTML files inside the new folder:
   `01-basics.html`, `02-patterns.html`, ...
2. Add a `<div class="card">` to the grid in the root `index.html`
3. Run `bin/publish.sh "Add Python asyncio topic"`

## `serve.sh` — local preview + cloudflare tunnel

```bash
bin/serve.sh                  # port 8765, with tunnel
bin/serve.sh --port 9000      # different port
bin/serve.sh --no-tunnel      # http only
```

Starts a `python3 -m http.server` on `127.0.0.1:$PORT` (so it's
loopback-only, not exposed on the LAN) and a Cloudflare Quick Tunnel
in front. Prints both URLs.

Use this during authoring to preview a lesson before committing.

## `publish.sh` — commit, push, verify

```bash
bin/publish.sh "Add Python asyncio topic"
```

Stages everything, commits with the given message, pushes to
`origin/main`, then polls GitHub Pages until every HTML + asset under
`topics/` returns 200 (or until ~3 minutes pass).

The commit author defaults to `html-lessons bot <bot@users.noreply.github.com>`.
Override with `GIT_AUTHOR_NAME` and `GIT_AUTHOR_EMAIL` env vars.

## Lesson card template

When you add a topic to the root `index.html`, use this card shape:

```html
<div class="card">
  <div class="date">4 July 2026</div>
  <h3><a href="topics/4th-july-python-asyncio/">Python Asyncio</a></h3>
  <p>One-line description of the topic.</p>
  <ul>
    <li><a href="topics/4th-july-python-asyncio/01-basics.html">L1 — The basics</a></li>
    <li><a href="topics/4th-july-python-asyncio/02-patterns.html">L2 — Patterns</a></li>
  </ul>
  <a class="more" href="topics/4th-july-python-asyncio/">View topic overview →</a>
</div>
```

New topics go at the top of the grid so the "newest first" ordering
stays consistent.

## The full pipeline

```bash
# 1. bootstrap
bin/new-topic.sh "Python asyncio"

# 2. author lessons (write 01-…html, 02-…html, ...)
#    preview as you go:
bin/serve.sh                              # then open the printed URL

# 3. wire into the root index
#    (edit the root index.html to add a card; see template above)

# 4. commit + push + verify
bin/publish.sh "Add Python asyncio topic"
```
