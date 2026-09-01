# Code Quality

* **Separation of concerns:** UI (widgets) must not carry business logic or direct DB/HTTP calls. Push those into services in `lib/core/utils/services/` or repositories inside the feature.
* **Naming:** descriptive, no abbreviations. `PascalCase` for types, `camelCase` for members, `snake_case` for file names. A name is read far more often than it is written — see § Names must be readable below.
* **Concise but clear:** prefer straightforward code over clever one-liners.
* **Line length:** the analyzer explicitly ignores `lines_longer_than_80_chars` — do not reflow existing long lines just to obey 80 columns. Keep additions readable (aim ~100 cols).
* **Function size:** keep functions focused. If a function grows past ~40 lines or handles more than one concern, split it.
* **Error handling:**
  * Wrap real boundaries (HTTP, DB, platform channels, JSON decoding) in `try/catch`.
  * Do not add try/catch around calls that cannot fail (pure functions, local map lookups).
  * Log with `developer.log` / the project logger — never `print` (`avoid_print` is enforced).
* **Const & final:** the linter enforces `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `prefer_const_declarations`, `prefer_final_fields`. Follow them.
* **Async safety:** the linter enforces `unawaited_futures`, `cancel_subscriptions`, `close_sinks`, `await_only_futures`. Cancel every `StreamSubscription` and `Timer` in `dispose()` (see `CLAUDE.md` § Memory leak prevention).
* **Testability:** inject dependencies through constructors. Do not `new` a service inline inside a widget.

## Names must be readable

A reader should know what an identifier is for without opening its definition or reading its type.
Casing is the easy half; these are the rest. File names and folders are `20-naming-and-file-organization.md`'s job — this is about the code inside them.

* **Whole words. No abbreviations, no type prefixes.** `searchLocationController`, not
  `txtSearchLocationController` (`location_picker_page.dart`, 32 occurrences — the only surviving
  Hungarian prefix in `lib/`, do not add a second). Never `val`, `obj`, `tmp`, `res`, `arr`. Single
  letters are allowed only in a one-expression closure (`(e) => e.id`) and in `catch (e, stackTrace)`.
* **Name a widget after what it shows, not the flow that reaches it.**
  `RepeatOrderWithChoosingOrderTypeBottomSheetWidget` is 49 characters describing a whole workflow;
  `RepeatOrderTypeSheet` says the same thing. Past ~30 characters a class name is usually a
  sentence that belongs in a doc comment.
* **Drop the `Widget` suffix** — a `StatelessWidget` is already a widget, and 45 classes still
  carry it (rule `20`). Same for `_ui`, `_class`, `_helper` on a widget.
* **A `State` class is named `_<Widget>State`.** 30 classes break this and read like widgets
  instead — `_OfferDialog`, `_TenantDialog`, `_HelpDialog`, `_ShoppingCartBadge`, `_ProgressBar`,
  `AppMainPageStateful`, and worst of all `_MarketChipWidget extends State<MarketChipWidget>`,
  which differs from its own widget by one underscore. Keep it private unless a
  `GlobalKey<…State>` in another file needs it — that is why `MapPickerState`,
  `ImagePickerWidgetState`, `CategoryStripState` and `CouponBarWidgetState` are public, and it is
  the only reason that is accepted.
* **Functions are verb phrases, types are noun phrases.** `submitOrder()`, `OrderSummaryCard`,
  `OrderEntity`. A function named like a noun hides that it does work; a class named like a verb
  hides what it holds.
* **Booleans read as a claim about the object:** `isOpen`, `hasDiscount`, `canSubmit`,
  `shouldRefresh`. A bare adjective (`enabled`, `selected`) is acceptable only on a widget
  parameter that mirrors the Flutter API it wraps.
* **Parameters carry the caller's meaning, not the type's.** `OrderEntity order`, never
  `OrderEntity data` / `item` / `model`. Prefer named parameters when a call has more than two
  arguments or any boolean, so the call site reads as a sentence:
  `showRepeatOrderSheet(order: order, allowScheduling: true)` — not `showRepeatOrderSheet(order, true)`.
* **One concept keeps one name across all layers.** If the domain calls it `orderId`, the model,
  the data source, the state and the widget parameter all call it `orderId` — not `id` here,
  `orderNo` there. A rename between layers is a bug waiting for a mapper.
* **Do not open a rename-only merge request.** Apply this to code you write and to files you
  already have open for another reason (rule `20` § Applying this).

