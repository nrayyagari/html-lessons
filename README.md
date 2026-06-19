# html-lessons

A growing collection of self-contained HTML lessons on programming topics.
Each lesson is one file under `lessons/`, designed to be read in the browser
or hosted via any static server.

## Structure

```
.
├── index.html                 # series landing page
├── lessons/                   # one HTML file per lesson
│   ├── 0001-structs-basics.html
│   ├── 0002-struct-pointers.html
│   ├── 0003-methods-receivers.html
│   └── 0004-embedding.html
├── reference/                 # cheat sheets & quick-reference docs
│   └── cheatsheet.md
├── assets/                    # shared stylesheet and widgets
│   ├── main.css
│   └── quiz.js
├── learning-records/          # ADRs for what was learned
├── MISSION.md                 # why this series exists
├── NOTES.md                   # design preferences
└── RESOURCES.md               # sources of truth
```

## View online

Enable GitHub Pages on the repo: Settings → Pages → `main` branch, `/` root.
Each lesson file (e.g. `lessons/0001-structs-basics.html`) becomes a
shareable URL.

## Add a new lesson

1. Pick the next number: `0005-<dash-case-name>.html`.
2. Reuse `assets/main.css` — do not inline styles.
3. Link to the cheatsheet under `reference/`.
4. End with a one-paragraph "ask the teacher" prompt.

## Design rules

- One tightly-scoped idea per lesson.
- Tufte-inspired typography, dark background.
- Color tokens for memory: amber = stack, violet = heap, red = pointer,
  emerald = value, sky = accent.
- Quizzes with fixed-length answer choices, no formatting clues.
- Every lesson cites a primary source under `RESOURCES.md`.
