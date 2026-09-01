# Flutter Best Practices

* **Immutable widgets:** every `StatelessWidget` and its fields are `final`.
* **Composition:** compose small widgets instead of deep-extending existing ones.
* **Private widget classes over helper methods:** extract `_HeaderRow`, `_ProductTile`, etc. rather than `_buildHeader()`. This gives correct element identity and better rebuild scoping.
* **Small `build()` methods:** if `build` grows past ~30–40 lines, split it (see `CLAUDE.md` § Widget-based Responsive UI).
* **Lists:** always use `ListView.builder` / `SliverList` for lists with more than a handful of items. Never `ListView(children: [...bigList])`.
* **Isolates:** move heavy JSON parsing or CPU-bound work off the UI thread with `compute()`.
* **`const` constructors:** apply everywhere the analyzer allows — the project relies on this to minimize rebuilds.
* **Lifecycle safety:** dispose every controller, animation, focus node, subscription, and timer. After every `await` inside a `State`, guard with `if (!mounted) return;` before touching `context` or `setState` (see `CLAUDE.md` § Memory leak prevention).
* **Images:** always pass `errorBuilder` and `loadingBuilder` to network images (see `15-visual-design-and-theming.md`).
* **RTL awareness:** use `EdgeInsetsDirectional`, `AlignmentDirectional`, `Directionality`, and directional icons. Test in Arabic locale before reporting done.
