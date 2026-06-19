# Cheat sheet — Go syntax and pointers

> Compressed essence. Print this; review before writing Go.

## The 25 keywords (in 6 groups)

```
Declarations:    package  import  const  var  type  func
Composite types: struct  interface  map  chan
Control flow:    if  else  for  range  switch  case  default
                 break  continue  fallthrough  goto  return
Concurrency:     go  select  defer
Misc:            nil
```

That's the whole list. Compare: Java ~50, C++ ~90. Go is small
on purpose.

## The four statement forms

```
1. Assignment:    x = y       x, y = y, x       x++
2. if:            if cond { } else { }
                  if v := init(); cond { }    # init scoped to the if
3. for:           for i := 0; i < n; i++ { }  # classic
                  for cond { }                 # while-style
                  for { }                      # infinite
                  for k, v := range iter { }   # range over slice/map/string/chan
4. switch:        switch x { case 1: ... }                  # value
                  switch { case x < 0: ... }                # tagless
                  switch v := i.(type) { case int: ... }    # type switch
```

No `while` (use `for cond`). No `do/while`. No `++x` (post-only).

## The two pointer operators

| Op | Effect |
| --- | --- |
| `&x` | take the address of `x`; produces `*T` |
| `*p` | follow the address in `p`; produces `T` |

That's it. No `+`, `-`, `[]`, or `->` on pointers. No
pointer-to-pointer in idiomatic code.

## What you can do with a Go pointer

- Read the pointed-to value (`*p`, or `p.Field` with auto-deref)
- Write through it (`*p = x`, or `p.Field = x`)
- Pass it as a parameter, return it, store it in a struct
- Compare to `nil`

## What you cannot do

- Pointer arithmetic (`p + 1`, `p++`, `p[i]`) — compile error
- Pointer-to-pointer in idiomatic code
- Cast integer to/from pointer without `unsafe`

## The "absences" — features Go deliberately doesn't have

- No classes — methods on receivers
- No inheritance — composition only (embedding)
- No exceptions — `if err != nil`
- No operator overloading
- No implicit numeric conversions
- No `while` — use `for cond`
- No ternary `?:` — use `if/else`
- No function overloading
- No default parameter values
- No `public`/`private` — capitalized names are exported

## The "weird but you'll get used to it" list

- `:=` declares; `=` assigns. Mixing them is a bug.
- Errors are values. `if err != nil` is everywhere.
- Slices share the backing array — `b := a[:2]; b[0] = 99` mutates `a`.
- Maps: read on nil is fine, write on nil panics.
- `defer f.Close()` runs `f.Close()` when the function returns.
- A nil pointer wrapped in an interface is NOT a nil interface.
- Goroutines have no built-in way to die — give them a context.

## The two things everyone gets wrong once

1. **Range loop variable capture (pre-1.22)**: shadow with
   `v := v` inside the loop, or upgrade to Go 1.22+.
2. **Typed nil in interface**: a `*T(nil)` wrapped in `I` is not
   `nil` of type `I`. Check nil at the boundary.

## Pointers vs references cheat

| In C/C++ | In Go |
| --- | --- |
| Pointer arithmetic | Compile error |
| Dangling pointer if you free | Garbage collector handles it |
| `&x` and `*p` | `&x` and `*p` (same) |
| `p->field` (or `(*p).field`) | `p.Field` (auto-dereference) |
| `malloc` / `free` | `new(T)` / GC; just let it go out of scope |
| `NULL` | `nil` |
