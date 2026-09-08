# Project Structure

## Roots
* `lib/main.dart` — application entry.
* `lib/features/<feature>/` — one folder per feature. Inside, use `presentation/` (and `data/` + `domain/` only when the feature is large enough to warrant them).
  * Example: `lib/features/order/order_summary_page/presentation/{order_summary_page.dart, widgets/}`.
* `lib/core/` — cross-feature app-level code:
  * `items/` — data models with their generated `*.g.dart` (json_serializable) siblings.
  * `utils/` — utilities and services: `database_provider.dart`, `routes.dart`, `helpers.dart`, `services/`, `app.dart`.
  * `functions/`, `pages/`, `security/`, `views/` — other horizontal building blocks.
* `../flutter_libs/common/` — sibling local package (path dependency) shared across Tawseel apps. **Before adding to `core/`, check whether it belongs in `common/`.** Anything reused by another Tawseel app lives in `common/`.
* `docs/` — organized by category (see `CLAUDE.md` § Documentation paths). New feature → add a file under `docs/features/`.

## Organization rules
* **Feature-first:** never put feature logic inside `core/`. `core/` is only for cross-feature building blocks.
* **Reused widgets:** widget used in 2+ places inside the same feature → move to `widgets/` inside that feature. Widget used in 2+ features → move to `lib/core/views/widgets/` (see `CLAUDE.md` § Reusability).
* **Models:** live in `lib/core/items/` alongside their `*.g.dart`. Do not put models inside feature folders.
* **Routes:** every named route is registered in `lib/core/utils/routes.dart`. The project does **not** use `go_router` or `auto_route`.
* **Inside a feature:** file names and sub-folders (`bloc/` vs `cubit/`, grouping under `widgets/`, nothing loose at the `presentation/` root) follow `20-naming-and-file-organization.md`.
