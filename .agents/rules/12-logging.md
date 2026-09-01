# Logging

* **Structured Logging:** Use `dart:developer`'s `log` function for DevTools integration instead of `print`:

```dart
import 'dart:developer' as developer;

developer.log(
  'Error details',
  name: 'app.network',
  level: 1000,
  error: error,
  stackTrace: stackTrace,
);