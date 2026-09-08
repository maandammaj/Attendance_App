# Dart Best Practices

* **Effective Dart:** Follow the official Effective Dart guidelines (https://dart.dev/effective-dart).
* **Class Organization:** Define related classes within the same library file. Export smaller, private libraries from a single top-level library for large modules.
* **API Documentation:** Add documentation comments to all public APIs.
* **Comments:** Write clear comments for non-obvious code. Avoid trailing comments or over-commenting.
* **Async/Await:** Use `Future`s, `async`, `await`, and `Stream`s with robust error handling.
* **Null Safety:** Write soundly null-safe code; avoid `!` unless guaranteed non-null.
* **Pattern Matching & Records:** Use pattern matching where it simplifies logic, and use records to return multiple values without unnecessary classes.
* **Switch Statements:** Prefer exhaustive `switch` statements or expressions without `break`.
* **Exception Handling:** Use explicit `try-catch` blocks and custom exceptions where relevant.
* **Arrow Functions:** Use arrow syntax for simple single-line functions.