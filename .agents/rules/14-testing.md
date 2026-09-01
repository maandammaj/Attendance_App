# Testing

* **Running Tests:** Execute tests with `flutter test`.
* **Test Types:**
  * **Unit Tests:** `package:test` (Domain & Data logic).
  * **Widget Tests:** `package:flutter_test` (UI components).
  * **Integration Tests:** `package:integration_test` (End-to-end user flows).
* **Assertions:** Prefer `package:checks` over default matchers.
* **Pattern:** Follow Arrange-Act-Assert (Given-When-Then).
* **Mocks:** Prefer fakes or stubs. Use `mockito` or `mocktail` when explicit mocking is required.