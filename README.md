# html-lessons

A growing collection of visually-strong, self-contained HTML lessons on
programming topics. One folder per topic, one file per lesson, hosted on
GitHub Pages.

## Structure

```
.
├── index.html                            # all-topics directory
├── assets/                               # stylesheet & widgets for the root index only
│   ├── main.css
│   └── quiz.js
├── topics/
│   └── 2026-06-go-structs-and-pointers/  # one folder per topic — fully self-contained
│       ├── index.html                    #   topic landing
│       ├── assets/                       #   topic's own stylesheet & widgets
│       │   ├── main.css
│       │   └── quiz.js
│       ├── 01-what-is-a-struct.html
│       ├── 02-pointers-to-structs.html
│       ├── 03-methods-and-receivers.html
│       ├── 04-embedding-and-composition.html
│       ├── cheatsheet.md
│       └── learning-record.md
├── MISSION.md                            # why this collection exists
├── NOTES.md                              # design preferences
└── RESOURCES.md                          # sources of truth
```

## Isolation rule

Every topic folder is **self-contained**. Its HTML, CSS, JS, cheatsheet,
and learning record all live under that folder. This means:

- A topic can be deleted, moved, or shared as a single unit.
- A topic can diverge its visual treatment without affecting siblings
  (e.g. a Python topic with syntax-highlighted code, a Rust topic with
  borrow-checker diagrams).
- No risk of asset-name collisions between topics.
- The only thing NOT inside a topic is the root directory page
  (`index.html` at the repo root), which keeps its own `assets/`.

## Naming convention

- **Topic folder:** `YYYY-MM-<topic-name>` (kebab-case). The date is
  the month the topic was started.
- **Lesson file:** `NN-<short-name>.html` — two-digit number for
  ordering, dash-case name. The first lesson is `01-`.
- **Topic landing:** `index.html` inside the topic folder.
- **Topic assets:** `assets/` subfolder inside the topic folder.
- **Cheat sheet:** `cheatsheet.md` inside the topic folder.
- **Learning record:** `learning-record.md` inside the topic folder.

## View online

Hosted on GitHub Pages at:

```
https://<username>.github.io/html-lessons/
```

The username comes from the repo owner. Specific lesson URLs follow the
folder structure:

```
https://nrayyagari.github.io/html-lessons/topics/2026-06-go-structs-and-pointers/01-what-is-a-struct.html
```

GitHub Pages deploys from `main` automatically; no build step.

## Add a new topic

1. `mkdir topics/YYYY-MM-topic-name`
2. Drop a topic landing `index.html` (copy the pattern from an existing
   topic).
3. Write lessons `01-…html`, `02-…html`, ... linking to
   `./assets/main.css` (each topic owns its own assets).
4. Add a card to the grid in the root `index.html`.
5. Push to `main`. Pages redeploys in ~30s.

## Design rules

- One tightly-scoped idea per lesson.
- Tufte-inspired typography, dark background.
- Color tokens for memory: amber = stack, violet = heap, red = pointer,
  emerald = value, sky = accent.
- Quizzes with fixed-length answer choices, no formatting clues.
- Every lesson cites a primary source under `RESOURCES.md`.
- Reuse your topic's `./assets/main.css` — never inline styles in a lesson.
  When a topic wants a different look, change that topic's CSS without
  affecting any other topic.
