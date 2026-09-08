# State Management & Routing

## State Management
* **Built-in Solutions:** Prefer built-in solutions (`ValueNotifier`, `ChangeNotifier`, `StreamBuilder`, `FutureBuilder`) unless third-party packages are requested.
* **MVVM:** Use MVVM for complex state architecture.
* **Dependency Injection:** Use simple manual constructor dependency injection, or `provider` if explicitly required.

## Routing
* **GoRouter:** Use `go_router` for main application routing, deep linking, and web support.
* **Authentication Redirects:** Handle redirects directly in `GoRouter` configuration.
* **Navigator:** Use standard `Navigator` for short-lived screens like dialogs and popups.