# Visual Design & Theming

* **Theme Centralization:** Use `ThemeData` and `ColorScheme.fromSeed` for dark and light modes.
* **Custom Design Tokens:** Use `ThemeExtension` for extended properties (e.g., custom state colors).
* **Dynamic Styling:** Use `WidgetStateProperty.resolveWith` for interactive components (hover, press, disable).
* **Assets & Images:** Always handle network images using `loadingBuilder` and `errorBuilder`.