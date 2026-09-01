# Naming & File Organization

`05-code-quality.md` owns the identifier-naming rules and `02-project-structure.md` owns the
top-level folders. This file covers what neither does: how a file is **named** and which
**sub-folder** it belongs in once it is inside a feature.

The goal is that a file's path answers "what is this and who uses it" before the file is opened.

## Names are full words

* **No abbreviations, no initials, no single letters.** `management` not `mangmant`,
  `state_extensions` not `state_x`, `configuration` not `cfg`. If a name needs a comment to be
  understood, it is the wrong name.
* **No redundant suffixes.** A file in `widgets/` is already a widget — `cart_body.dart`, not
  `cart_body_widget.dart`. Same for `_ui`, `_class`, `_file`, `_impl` on anything that is not a
  data-layer implementation of a named contract (`*_repository_impl.dart` is correct because it
  pairs with `*_repository.dart`).
* **`snake_case` files, `PascalCase` types**, and the file name matches its primary type:
  `notification_card.dart` → `NotificationCard`. One public widget/class per file.
* **No `_old`, `_new`, `_v2`, `_copy`, `_bak`, or dated names.** Git history is the previous
  version. A file that must survive a migration temporarily is prefixed `legacy_` and deleted in
  the same merge request, never left behind.
* **Suffixes that carry meaning are required, not optional:** `*_page.dart`, `*_sheet.dart`,
  `*_dialog.dart`, `*_bloc.dart`, `*_cubit.dart`, `*_state.dart`, `*_event.dart`,
  `*_entity.dart`, `*_model.dart`, `*_repository.dart`, `*_data_source.dart`.

Known debt, kept only to avoid a wide rename — do not imitate, and fix when you touch the file:
`lib/features/account_mangmant/` (misspelled), `*_state_x.dart` in `auth` / `subscriptions` /
`chat_bot`, the `*_widget.dart` suffixes in `cart`, `voice_message_bubble_ui.dart`, and the
`t_name` / `c_id` column prefixes in `lib/core/items/` (part of the shipped DAO contract).

## Every file sits in a folder that owns it

Nothing loose at the root of `presentation/` except the feature's `<feature>_strings.dart`.
A helper that is not a page, a widget, or a state holder still belongs somewhere named — a
launcher goes in `services/`, an icon map in `widgets/` or `constants/`.

Current strays to relocate when touched: `presentation/tenant_selector.dart`,
`presentation/account_menu_icons.dart`, `presentation/chat_link_launcher.dart`,
`cart/presentation/cart_page.dart` (belongs in `pages/`).

A file also has to stay small enough that its folder still explains it — the repo's median is 65
lines and ~300 is where you stop and ask what else is in there. When one grows past that, split it
along the feature's own seams (`domain/` / `data/` / `presentation/`, then `pages/` vs
`widgets/<page_name>/` vs `bloc/`), never into `*_part2.dart` / `*_helpers.dart` / `*_extra.dart`
— a file named after its leftovers is banned by the naming rules above and solves nothing. See
CLAUDE.md § File size — no god files.

## State holders: one folder per holder

`bloc/` holds Blocs, `cubit/` holds Cubits. **Never mix the two, and never let a state file sit
beside an unrelated holder.** Each holder owns a folder named after it, containing its own
event/state/extension files:

```
presentation/
  bloc/
    account/
      account_bloc.dart
      account_event.dart
      account_state.dart
      account_state_extensions.dart
  cubit/
    account_balance/
      account_balance_cubit.dart
      account_balance_state.dart
    tenant_selection/
      tenant_selection_cubit.dart
      tenant_selection_state.dart
```

* **A feature with exactly one Bloc skips the nesting** — its files sit directly in `bloc/`
  (`bloc/auth_bloc.dart`), since `bloc/auth/auth_bloc.dart` only stutters. The same applies to a
  lone Cubit in `cubit/`. Add the per-holder folder the moment a second holder of that kind
  appears.
* A state extension (`extension <Feature>StateX on <Feature>State`) lives with its holder and is
  named `*_state_extensions.dart`.
* A Cubit never lives in an ad-hoc folder named after its purpose. `notifications` currently puts
  one in `presentation/badge/`; that is the pattern this rule replaces.

## Widgets: mirror the pages

```
presentation/widgets/
  <page_name>/        — used by exactly one page
  shared/             — used by 2+ pages inside this feature
```

* Group as soon as `widgets/` would hold more than ~8 files, or the feature owns more than one
  page. Below that a flat `widgets/` is fine.
* A bottom sheet or dialog belongs to the page that opens it; move it to `shared/` only when a
  second page opens it too.
* Used by 2+ **features** → it is no longer a feature widget: move it to
  `lib/core/views/widgets/` (CLAUDE.md § Reusability).
* The folder name matches the page's file name without the suffix — `pages/chat_bot_page.dart`
  → `widgets/chat_bot/`.
* **One public widget per file.** Private sibling widgets (`_ImagePreviewCard` and `_CloseButton`
  inside `image_preview_dialog.dart`) may share the file only while it stays small — roughly 200
  lines, and one screenful per helper. Past that, or the moment a second file references one of
  them, it becomes a public widget in its own file named after it.
* **A page file holds the page and its view only** — `BlocProvider` plus the `BlocConsumer`.
  Sections, rows, bars, sheets and dialogs live in `widgets/<page_name>/`, never inline in the
  page. A `Widget _build…()` helper method is banned outright (rules `03`, `07`); the replacement
  is a private widget class, and once it is one, the bullet above decides whether it stays in the
  file. See CLAUDE.md § Widget-based Responsive UI → One file, one widget.

## Imports & exports: one curated facade per feature

`08-application-architecture.md` decides that a feature has a facade; this is what the file must
contain, who may import it, and what a long import list actually means.

### A long import list is a file-size signal, not an import-syntax problem

The median `.dart` file under `lib/` imports **4** files; p90 is 12. The 22 files above 20 imports
are the known god files — `order_summary_page.dart` (72), `markets_page.dart` (69),
`database_provider.dart` (65), `core/utils/app.dart` (53), `order_details_page.dart` (50). Their
import block is long because the file holds four layers, and the fix is the split in
CLAUDE.md § File size — **never** a barrel that hides the count. Do not "solve" a long import list
by adding a file to import from.

### The facade

`lib/features/<feature>/<feature>.dart` — every one of the 18 features has one, and 117 imports
across `lib/`, `apps/` and `test/` go through them.

* **Every `export` carries a `show` clause.** All 61 export directives in `lib/` do today; keep it
  at zero exceptions. A blanket `export 'foo.dart';` is banned — it re-exports whatever that file
  later grows, so the feature's surface changes without anyone editing the facade.
* **Exportable:** pages that `routes.dart` mounts, widgets another feature places, an app-wide
  service, and an entity another feature's page takes as an argument (`address.dart` exports
  `AddressEntity` for exactly that reason).
* **Never exportable:** anything under `data/` (data sources, models, `*RepositoryImpl`),
  `domain/repositories/`, `domain/usecases/`, and the feature's Bloc/Cubit with its state and event
  files. Those are wired by `get_it` and reached by no one else — exporting one deletes the
  boundary the facade exists to hold.
* **Relative paths inside the facade** (`export 'presentation/pages/x.dart' show X;`), not
  `package:`. `subscriptions.dart` is the lone exception — fix it when you touch the file.
* The doc comment says *why* each symbol is out there, as `cart.dart` and `auth.dart` do. A facade
  entry with no reason is a boundary leak that passed review.

### Who imports it

* **From another feature — always the facade, never a deep path.** Nine deep cross-feature imports
  survive outside the composition root — `search → suggestions_management` ×6 (reaching that
  feature's entity from `search`'s own domain, data and presentation layers), `cart → address` ×2,
  and `core/views/location_picker_page.dart → address`. Do not add a tenth.
  `grep -rn "features/<name>/\(data\|domain\|presentation\)/" lib` from outside that feature is
  the check.
* **The composition root is exempt by design.** `lib/core/di/injection.dart` and each
  `<feature>_injection.dart` import the `*Impl` types directly — that is the one place allowed to.
* **Inside the feature, never import your own facade.** A file under `features/foo/` reaching
  `features/foo/foo.dart` is an import cycle waiting to happen and hides which layer it is calling
  into. Deep relative-to-package paths are correct there, however many there are.
* **`lib/core/` gets no facade** — it is not a feature and has no single surface. No `core.dart`,
  no `widgets.dart`, no `imports.dart` / `exports.dart` anywhere in the repo.

### Tests: the doubles file is the feature's test-side module

* Shared fakes live in `test/features/<feature>/<feature>_test_doubles.dart` and import the real
  internal paths. **That file is allowed a long import block** — it is the one place that
  legitimately touches every layer of one feature, which is what keeps each `*_test.dart` short.
* 15 features have one. The name matches the folder it sits in; fix the drift when you touch it —
  `recharge_test_doubles.dart`, `chat_test_doubles.dart`, `subscription_test_doubles.dart`.
* `order` has 17 test files, no doubles file, and four of them declaring their own fakes. The next
  `order` test creates it rather than copying a fifth.

## Applying this

Do not open a rename-only merge request across the repo. Apply the rule to files you create, and
to files you already have open for another reason — a rename plus its import updates is cheap when
the file is being edited anyway, and expensive as a standalone review. New features have no excuse:
they follow this from the first commit.
