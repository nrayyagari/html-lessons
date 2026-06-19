# Learning Record: 0001

**Date:** 2026-06-19
**Topic:** Go structs and pointers
**Source conversation:** the first teach session in this repo

## Decision

Built a four-lesson series on structs and pointers, with memory-layout
diagrams as the primary visual aid. The memory diagrams use fixed color
tokens (amber=stack, violet=heap, red=pointer, emerald=value) so the
user can recognize them across lessons without re-learning the palette.

## Non-obvious takeaways to remember

- Go's auto-dereference on `p.Field` and `p.Method()` is the main thing
  that makes pointers feel frictionless. Worth showing explicitly with
  the `(*p).Field` / `p.Field` side-by-side.
- The addressability rule is the source of most "why does this compile
  but my friend's version panic" friction. Worth a callout, not just
  an aside.
- For embedding, the *value-embedded-value* case is the only one whose
  method set excludes the inner pointer-receiver methods when the
  outer is a value. That's the easy one to forget.

## What to revise next time

- A quiz item that asks about the value-embedded-value method set
  above confused several readers. Tighten the wording in 0004.
- The cheatsheet should grow a "common mistakes" section once we have
  a second series to compare against.
