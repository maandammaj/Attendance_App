# Logging

* **Never use `print`.** The analyzer enforces `avoid_print`.
* **Use `dart:developer`'s `log`** for structured logging that shows up in DevTools:

  ```dart
  import 'dart:developer' as developer;

  developer.log(
    'Failed to submit order',
    name: 'order.summary',
    level: 1000, // SEVERE
    error: error,
    stackTrace: stackTrace,
  );
  ```

* **`name` convention:** `<feature>.<subarea>` — e.g. `order.summary`, `auth.login`, `db.migration`. This makes DevTools filtering practical.
* **Levels:** use `500` (INFO), `900` (WARNING), `1000` (SEVERE). Do not log successful hot-path operations at SEVERE.
* **Never log secrets:** no tokens, passwords, full auth headers, or full PII. Redact before logging.
* **File logger:** `lib/core/utils/file_logger.dart` exists for persistent logs — use it for events that must survive an app restart (order sync failures, DB migration errors). Do **not** route every log through the file logger.
* **Sentry:** production error reporting flows through Sentry — throw or rethrow real errors instead of swallowing them, so Sentry captures the trace.
