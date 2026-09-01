# Data Handling & Serialization

* **Data Abstraction:** Abstract data sources using Repositories or Services for testability.
* **JSON Serialization:** Use `json_serializable` and `json_annotation`.
* **Field Renaming:** Always specify `fieldRename: FieldRename.snake` on `@JsonSerializable` annotations to automatically map camelCase properties to snake_case JSON keys.