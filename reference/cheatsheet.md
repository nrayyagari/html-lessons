# Reference: Go Structs & Pointers — Cheat Sheet

> Compressed essence of the series. Print this; review before writing Go.

## Struct definition & zero value

```go
type Point struct {
    X, Y int           // named fields
    Name string
}
var p Point           // zero value: {X:0, Y:0, Name:""}
p := Point{1, 2, "a"} // positional — fragile, avoid
p := Point{X: 1, Y: 2} // named — always prefer
```

## Pointer operators

| Op        | Meaning                                           |
| --------- | ------------------------------------------------- |
| `&T`      | "address of" — gives you `*T` to a `T`            |
| `*p`      | "dereference" — gives you the `T` behind a `*T`   |
| `new(T)`  | allocates a zero-valued `T`, returns `*T`         |
| `&T{...}` | allocates and initializes, returns `*T`           |

## Go's auto-dereference

`(*p).Field` is the same as `p.Field`. Same for methods.
`p` may be a `*T` or a `T`; both work for field access and method calls.

## Nil pointer trap

```go
var p *Point        // p == nil
p.Field             // panic: nil pointer dereference
```

Always check before dereferencing if the pointer can be nil.

## Methods: value vs pointer receiver

```go
func (p Point)  Move(dx, dy int) { p.X += dx }   // copy; caller NOT mutated
func (p *Point) Move(dx, dy int) { p.X += dx }   // mutates the real thing
```

Use **pointer receiver** when the method needs to mutate, the struct is
large, or the receiver contains a sync primitive (mutex).

## Method sets

- `T`  has all methods with receiver `T`.
- `*T` has all methods on `T` **and** all methods on `*T`.
- That's why `*T` satisfies an interface that wants a `*T` receiver,
  and a `T` may not.

## Embedding

```go
type Job struct {
    Point          // anonymous field — methods of Point are promoted
    Title string
}
j := Job{Point: Point{1, 2}, Title: "fix"}
j.Move(3, 4)     // promoted from *Point.Move
j.X              // promoted field access
```

## Mutation cheat

| Call site                       | Mutates caller? | Why                              |
| ------------------------------- | --------------- | -------------------------------- |
| `f(p)` where `f(T)`             | no              | receives a copy                  |
| `f(p)` where `f(*T)`            | yes             | passes the same backing memory   |
| `p.M()` where `M` has `T` recv  | no              | auto-addressable; still a copy   |
| `p.M()` where `M` has `*T` recv | yes             | Go takes `&p` automatically      |
