# html-lessons

A growing collection of visually-strong, self-contained HTML lessons on
programming topics. One folder per topic, one file per lesson, hosted
on GitHub Pages.

## Structure

```
.
├── index.html                            # all-topics directory
├── assets/                               # stylesheet & widgets for the root index only
│   ├── main.css
│   └── quiz.js
├── template/                             # starter files for a new topic
│   ├── topic-index.html
│   ├── cheatsheet.md
│   └── learning-record.md
├── bin/                                  # standardized workflow scripts
│   ├── new-topic.sh                      #   bootstrap a new topic
│   ├── serve.sh                          #   local http + cloudflare tunnel
│   ├── publish.sh                        #   commit, push, verify Pages
│   └── README.md                         #   script usage
├── topics/
│   └── <day><ord>-<month>-<topic>/       # one folder per topic — fully self-contained
│       ├── index.html
│       ├── assets/
│       │   ├── main.css
│       │   └── quiz.js
│       ├── 01-…
│       ├── 02-…
│       ├── …
│       ├── cheatsheet.md
│       └── learning-record.md
├── MISSION.md
├── NOTES.md
├── RESOURCES.md
└── README.md
```

## Standardized workflow

The `bin/` scripts are the canonical way to add a new topic. See
[`bin/README.md`](bin/README.md) for full usage. The short version:

```bash
# 1. bootstrap a topic folder
bin/new-topic.sh "Python asyncio"

# 2. preview locally (optional)
bin/serve.sh

# 3. add a card to the root index.html (see bin/README.md for the shape)

# 4. commit, push, verify Pages
bin/publish.sh "Add Python asyncio topic"
```

The teach skill workflow drives the actual lesson content; these
scripts handle the boilerplate, infra, and deployment so the agent can
focus on writing.

## Naming convention

- **Topic folder:** `<day><ord>-<month>-<topic-name>` (kebab-case).
  Example: `19th-june-go-structs-and-pointers`, `4th-july-gopointers`.
  The date is when the topic was started.
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

Specific lesson URLs follow the folder structure:

```
https://nrayyagari.github.io/html-lessons/topics/19th-june-go-structs-and-pointers/01-what-is-a-struct.html
```

## Design rules

- One tightly-scoped idea per lesson.
- Light theme, Tufte-inspired typography.
- Color tokens for memory: amber = stack, violet = heap, red = pointer,
  emerald = value, sky = accent.
- Quizzes with fixed-length answer choices, no formatting clues.
- Every lesson cites a primary source under `RESOURCES.md`.
- Reuse the topic's `./assets/main.css` — never inline styles in a lesson.
