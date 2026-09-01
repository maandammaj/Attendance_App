# Dart Best Practices

* **Effective Dart:** follow https://dart.dev/effective-dart.
* **Null safety:** avoid `!`. Use pattern matching, `?.`, `??`, or explicit null checks that narrow the type.
* **Records & patterns:** use records for lightweight multi-value returns; use pattern matching in `switch` and `if-case` to simplify branching.
* **Switch expressions:** prefer exhaustive `switch` expressions for enums and sealed hierarchies — the analyzer will flag missing cases.
* **Async:** always `await` futures. Handle failure at the boundary (repository/service), not inside every caller.
* **Custom exceptions:** define a typed exception (e.g. `NetworkException`, `DbException`) when a caller needs to distinguish failure modes.
* **Arrow functions:** use `=>` only for genuinely single-expression functions.
* **Doc comments:** `///` on public APIs, focused on *why* and non-obvious behavior — never restate the identifier.
* **Comments:** default to no inline comments. Add one only when the *why* is non-obvious (see `CLAUDE.md`).
