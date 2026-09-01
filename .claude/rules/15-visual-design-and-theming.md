# Visual Design & Theming

The authoritative rules live in `CLAUDE.md` § "Theme consistency" and § "Widget-based Responsive UI". This file lists the concrete project-specific pointers.
For refactor visual-regression checks, also follow
`23-ui-ux-regression-and-visual-qa.md`.

## Theme access
* **Colors:** `Theme.of(context).colorScheme.*` — never `Color(0xFF...)` inline.
* **Text:** `Theme.of(context).textTheme.*` — never a raw `TextStyle(...)` inline.
* **Icons:** rely on `IconTheme.of(context)` or pass a `color:` derived from `colorScheme`.
* **Brand tokens not in `colorScheme`:** use the existing theme extension / colors file in the project. If you cannot find one, **ask** before introducing a new color.

## Interactive components
* Use `WidgetStateProperty.resolveWith` (or `MaterialStateProperty` on older APIs) for hover / pressed / disabled tints — never conditionally build two whole widgets.

## Images
* **Network images:** always pass `loadingBuilder` and `errorBuilder`. A missing image must degrade gracefully (placeholder / retry), never a red error box.
* **SVGs:** use `flutter_svg`. Tint via `colorFilter`, driven by `colorScheme`.

## Dark & light
* Every new/changed screen must be verified in both dark and light modes before it is called done. Check text contrast, disabled states, dividers, and icon visibility.

## Responsive layout
* Use `LayoutBuilder`, `MediaQuery`, `Flexible`, `Expanded`, `FractionallySizedBox`, `AspectRatio`. Avoid hard-coded widths/heights for content containers.
* If `flutter_screenutil` is in use for a screen, do not mix raw pixels with `.sp` / `.w` / `.h` in the same screen — pick one and stick to it (per `CLAUDE.md`).
