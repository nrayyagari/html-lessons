# Notes

- User wants the lessons to be **visually strong** — animated memory diagrams,
  color-coded stack/heap, pointer arrows. Default to SVG + CSS over images.
- Each lesson is one self-contained HTML file under `lessons/`.
- Each topic owns its own `assets/main.css` — copy the current one when
  starting a new topic. Topics are visually isolated on purpose so a
  Python or Rust topic can have its own theme without touching siblings.
- All code samples must compile against Go 1.22+. No `gofmt` violations
  (tabs for indent, `gofmt`-style spacing).
- The user is mid-way through a Go practice track (see `~/repos/go-practice`).
  Don't re-explain things they already know (variables, control flow).
