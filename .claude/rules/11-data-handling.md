# Data Handling & Serialization

## Local storage
* **Encrypted SQLite:** the project uses `sqflite_sqlcipher` through `lib/core/utils/database_provider.dart`. All DB access goes through this provider — do not open your own database instance.
* **No SQLite on web:** `sqflite_sqlcipher` has no web implementation, so any read from `DatabaseProvider.db` needs an API fallback guarded by `AppSingleton.isWebVersion()` — see `19-web-support.md`.
* **Schema changes:** when adding/altering a table or column, update the migration path inside `database_provider.dart` (bump `DB_VERSION` and add an `onUpgrade` branch). Never edit an existing migration retroactively.
* **Transactions:** wrap multi-statement writes in `db.transaction((txn) async { … })` to keep the DB consistent.
* **Queries:** parameterize with `?` placeholders — never string-interpolate user input into raw SQL.

## Networking
* **HTTP client:** the project uses the `http` package (not `dio`). Requests live in feature `data/` (repositories/data sources), never in widgets.
* **Auth & headers:** reuse the shared client / helpers in `lib/core/utils/services/` — do not build ad-hoc header maps in each caller.

## JSON serialization
* **Generator:** `json_serializable` + `json_annotation`. Models live in `lib/core/items/` with the generated `*.g.dart` beside them.
* **snake_case mapping:** every model must annotate its class with `@JsonSerializable(fieldRename: FieldRename.snake)` so Dart camelCase fields map to the backend's snake_case keys.
* **Regenerate after model changes:**
  ```bash
  fvm dart run build_runner build --delete-conflicting-outputs
  ```
* **Nullability at boundaries:** treat every field from JSON as potentially missing — either mark it nullable in the model or provide a `@JsonKey(defaultValue: …)`.

## Repositories & data sources
* Repositories translate DTOs (HTTP / DB rows) into domain models. Widgets consume domain models, never raw JSON maps or DB rows.
* Cache-then-refresh: prefer emitting cached data from local DB first, then refreshing from HTTP and re-emitting.
