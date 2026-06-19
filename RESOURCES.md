# Resources

## Go language spec (canonical)
- https://go.dev/ref/spec#Struct_types — the definition of a struct.
- https://go.dev/ref/spec#Pointer_types — the definition of a pointer.
- https://go.dev/ref/spec#Method_declarations — receiver rules.
- https://go.dev/ref/spec#Struct_types §promotion — embedding rules.

## Go blog (high trust, Go team authors)
- https://go.dev/doc/codewalk/functions/ — function values + closures.
- https://go.dev/doc/effective_go — the "Methods" and "Embedding" sections.
- https://go.dev/blog/laws-of-reflection — when reflection comes up later.

## Tour of Go (interactive, good for retrieval practice)
- https://go.dev/tour/moretypes/1 through /moretypes/5 — struct basics.
- https://go.dev/tour/methods/1 through /methods/9 — receivers and pointers.

## Books (deep)
- *The Go Programming Language* — Alan Donovan & Brian Kernighan, ch. 4 (Composite Types) and ch. 6 (Methods).

## Python asyncio (high trust)
- https://docs.python.org/3/library/asyncio.html — the asyncio overview.
- https://docs.python.org/3/library/asyncio-task.html — Tasks & coroutines (high-level API).
- https://docs.python.org/3/library/asyncio-stream.html — streams for low-level I/O.
- https://peps.python.org/pep-0492/ — the PEP that introduced `async`/`await` syntax.
- *Fluent Python*, 2nd ed. — Luciano Ramalho, ch. 21 (Async) is the best book treatment.

## Kubernetes cert-manager (high trust)
- https://cert-manager.io/docs/ — canonical reference.
- https://cert-manager.io/docs/concepts/ — Issuer / Certificate / Order / Challenge.
- https://cert-manager.io/docs/usage/ingress/ — the Ingress shim that makes the common case annotation-only.
- https://cert-manager.io/docs/configuration/acme/ — solver config (HTTP-01, DNS-01).
