# Mission

Learn Go well enough to write idiomatic backend services — starting from the
ground up. Structs are the heart of how Go models data, and pointers are how
that data flows between functions, methods, and goroutines without being
copied into oblivion. This series builds a working mental model of both.

## Why I Want This

I'm doing a Go practice track (see `~/repos/go-practice`) and keep hitting
code that uses `*Foo`, `&foo`, and method receivers without being able to
predict what mutates and what doesn't. I want to read a struct definition
and immediately see the memory layout in my head.

## Definition of "Done"

- I can predict, from a function signature alone, whether the caller's struct
  will be mutated.
- I can explain `p.Field` working even when `p` is a pointer.
- I can choose between value and pointer receiver and defend the choice.
- I recognize embedding and can trace promoted methods.
