# Notes

- User wants the lessons to be **visually strong** — animated memory diagrams,
  color-coded stack/heap, pointer arrows. Default to SVG + CSS over images.
- Each lesson is one self-contained HTML file under `lessons/`.
- The shared `assets/main.css` is the source of truth for typography and
  layout — do not inline duplicate styles in a lesson.
- All code samples must compile against Go 1.22+. No `gofmt` violations
  (tabs for indent, `gofmt`-style spacing).
- The user is mid-way through a Go practice track (see `~/repos/go-practice`).
  Don't re-explain things they already know (variables, control flow).
