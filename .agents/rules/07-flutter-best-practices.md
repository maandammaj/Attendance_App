# Flutter Best Practices

* **Immutability:** Widgets (especially `StatelessWidget`) are immutable.
* **Composition:** Compose smaller widgets over extending existing ones to avoid deep nesting.
* **Private Widgets:** Use small, private `Widget` classes instead of private helper methods returning widgets.
* **Build Methods:** Break down large `build()` methods into smaller private Widget classes. Avoid heavy computations or network calls inside `build()`.
* **List Performance:** Use `ListView.builder` or `SliverList` for lazy-loaded lists.
* **Isolates:** Use `compute()` to run heavy tasks (e.g., JSON parsing) on a separate isolate.
* **Const Constructors:** Use `const` constructors wherever possible to avoid unnecessary rebuilds.