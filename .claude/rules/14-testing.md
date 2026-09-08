# Testing

* **Runner:** `fvm flutter test`.
* **Frameworks available in this project:** `flutter_test` (bundled with the Flutter SDK). `package:test`, `package:checks`, `package:integration_test`, `mockito`, and `mocktail` are **not** currently declared — do not import them without adding the dependency and getting approval.
* **Layer guidance:**
  * **Unit tests** (pure Dart logic, mappers, helpers): plain `test(...)` from `flutter_test`.
  * **Widget tests** (single widget, small screens): `testWidgets(...)` from `flutter_test`.
  * **Integration tests:** not part of the current pipeline. If proposing one, add `integration_test` explicitly and confirm with the user.
* **Pattern:** Arrange–Act–Assert. Keep each test focused on one behavior.
* **Mocking:** prefer hand-written fakes (a small class implementing the interface with test-controlled state). Only reach for `mockito`/`mocktail` when a hand-written fake becomes unwieldy — and add the dependency explicitly.
* **Shared fakes:** a feature's hand-written fakes live in one
  `test/features/<feature>/<feature>_test_doubles.dart`, not copied into each test file. That file
  carries the long import block so the tests do not — see `20-naming-and-file-organization.md`
  § Imports & exports.
* **Database & network in tests:** never hit the real backend or the encrypted SQLite DB. Inject a fake repository/service through the widget's constructor.
* **RTL:** for any widget that renders differently in RTL, add a test wrapping the widget in `Directionality(textDirection: TextDirection.rtl, child: …)`.
* **File location:** mirror `lib/` under `test/` — e.g. `test/features/order/order_summary_page/order_summary_page_test.dart`.
