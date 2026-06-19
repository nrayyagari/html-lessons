# Reference: Python Async — Cheat Sheet

> Compressed essence of the series. Print this; review before writing async code.

## The core mental model

```
1 thread · 1 loop · N coroutines · 0 locks
```

Only one coroutine runs Python at a time. They only switch at
`await` points. So most concurrency bugs you know from threading
just don't apply.

## Three ways to start a coroutine

| API                                  | When body starts          | Caller waits? | Returns                |
| ------------------------------------ | ------------------------- | ------------- | ---------------------- |
| `asyncio.run(coro())`                | immediately               | yes           | result of `coro`       |
| `await coro`                         | when awaited              | yes           | result of `coro`       |
| `t = asyncio.create_task(coro)`      | on the next loop tick     | **no**        | a `Task`               |

## The two-line concurrent example

```python
import asyncio

async def slow(label, secs):
    await asyncio.sleep(secs)
    return f"{label} done"

async def main():
    a, b = await asyncio.gather(slow("A", 1), slow("B", 1))
    print(a, b)   # "A done" "B done"  — total elapsed: ~1s, not 2s

asyncio.run(main())
```

## Common patterns

```python
# Gather with error isolation — one failure does not cancel the rest
results = await asyncio.gather(*tasks, return_exceptions=True)

# Timeout — cancels the coroutine, raises TimeoutError
try:
    result = await asyncio.wait_for(slow_op(), timeout=2.0)
except TimeoutError:
    log("too slow")

# Offload blocking code to a thread pool — keep the loop responsive
data = await asyncio.to_thread(sync_db_query, "SELECT …")
```

## Cancellation rules

- A cancelled coroutine receives `CancelledError` at the next `await`.
- After handling it, **re-raise** unless you have a specific reason
  not to (and even then, prefer `try / finally`).
- `asyncio.gather` cancels the remaining tasks on first failure
  *unless* `return_exceptions=True` is passed.

## When to use asyncio

| Workload                           | Use                                  |
| ---------------------------------- | ------------------------------------ |
| HTTP / DB / queue / websocket I/O  | `asyncio` (and an async lib)         |
| File I/O via sync APIs             | `asyncio.to_thread`                  |
| CPU-bound (math, parsing, crypto)  | `multiprocessing` or native code     |
| Mixed                              | `asyncio` for the I/O, `to_thread` for the blocking parts |

## Common mistakes

- `main()` without `asyncio.run` — the coroutine is never awaited.
- `time.sleep()` instead of `await asyncio.sleep()` — freezes the loop.
- Catching `CancelledError` and not re-raising — the task leaks.
- Calling a blocking DB driver directly inside a coroutine — use
  `to_thread` or an async driver.
- Forgetting `return_exceptions=True` on `gather` and being surprised
  that one bad URL kills the whole batch.
