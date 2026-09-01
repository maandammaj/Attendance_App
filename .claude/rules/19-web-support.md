# Web Support

Web is a shipped target, not an experiment: `apps/tawseel`, `apps/almuealim`, `apps/bazooka` and
`apps/sehabah_delivery` each carry a `web/` build directory. Any change to `lib/` must still
compile and run there, even when the task was described in Android or iOS terms.

Web differs from the mobile targets in two independent ways, and they are easy to confuse:

* **Platform** — the code runs in a browser, so `dart:io` is unusable and some plugins have no
  implementation.
* **"Web version"** — there is no encrypted SQLite, so the local database is not the source of
  truth and data must come from the API instead.

A screen can need one, the other, or both.

## Never touch `dart:io`'s `Platform`

`Platform.isAndroid` and friends compile for web but throw `UnsupportedError` the moment they are
read. A top-level `final x = Platform.isIOS ? … : …` therefore crashes during startup, before any
widget builds.

Use [`PlatformInfo`](../../lib/core/utils/platform_info.dart) instead:

```dart
PlatformInfo.isIOS      // false on web — no extra guard needed
PlatformInfo.isAndroid
PlatformInfo.isWeb      // only when web needs its own branch
PlatformInfo.osType     // 'ios' | 'android' | 'web' for the backend's os_type field
```

**Do not pair it with a web check.** `PlatformInfo.isIOS` already resolves to `false` on web, so
`!Singleton.IsWeb && PlatformInfo.isIOS` is redundant. That pairing is still scattered across
unmigrated screens (`cart_page.dart`, `legacy_notifications_page.dart`,
`legacy_suggestions_management_page.dart`) only because the legacy code called `dart:io`'s
`Platform` and needed the guard to avoid the throw. Drop the guard when you touch such a line;
`Singleton.IsWeb` (`= kIsWeb`, defined in `common`) stays only where web genuinely branches.

## No local database on web

`AppSingleton.isWebVersion()` — `Singleton.IsWeb || AppSingleton.IS_WEB_VERSION ||
!DatabaseProvider.isOpen` in [`lib/core/utils/app.dart`](../../lib/core/utils/app.dart) — is the
"there is no local DB" flag, not a platform check. Its third term means an unopened database on
mobile takes the same path, which is deliberate.

Consequences for the data layer:

* A local data source that reads `DatabaseProvider.db` cannot be the source of truth. Either the
  data source or its repository must fall back to the API when `isWebVersion()` is true.
  Reference: `Account.getAccount()` in [`lib/core/items/account.dart`](../../lib/core/items/account.dart)
  queries the setup endpoint instead of the `Account` table.
* Recorded as business rule OFF-002 in [`docs/ai/business-rules.md`](../../docs/ai/business-rules.md)
  — "Web uses API-first: direct HTTP calls".
* `SharedPreferences` **does** work on web, so prefs-backed local sources need no branch. This is
  why `auth`'s local data source is web-safe while a SQLite-backed one is not.
* `sqflite_common_ffi_web` is commented out in `pubspec.yaml`. Do not uncomment it to "fix" web —
  the API-first path is the design.

## Plugins on web

Do not assume a plugin is missing on web — most of this app's are not. `geolocator_web`,
`google_maps_flutter_web`, `firebase_messaging_web` and `permission_handler_html` all resolve in
`apps/tawseel/pubspec.lock` as endorsed federated implementations, pulled in automatically even
though `google_maps_flutter_web` is commented out in `pubspec.yaml`. Check the lock file before
writing a `kIsWeb` fallback for a plugin.

The real gap is **`sqflite_sqlcipher`**, which has no web implementation — hence the API-first
path above.

Where a web branch does exist for a supported plugin it is a product decision, not a missing
implementation: [`lib/core/views/map_page.dart`](../../lib/core/views/map_page.dart) returns early
on `kIsWeb` rather than asking the browser for location. Follow the existing decision when editing
such a screen instead of "restoring" the native path.

Whatever the cause, a plugin path that cannot run on web needs an explicit disabled state — never
a crash and never a silently empty view.

## Routing

`lib/core/utils/routes.dart` returns `NoAnimationMaterialPageRoute` on web and reads `market_id`
out of the routing data, because the browser URL is the navigation source. A new named route
inherits this automatically — do not add a second web branch inside a page.

## Do not remove web branches while refactoring

A `Singleton.IsWeb` / `kIsWeb` branch in legacy code is behavior, not noise. Removing one because
a task was scoped to mobile drops web support silently — the analyzer cannot catch it and there is
no web build in CI. Either carry the branch over, or record its removal in the migration's ADR as
a deliberate drop with a reason. `ADR-010` dropped one on the grounds that the project is
"Android/iOS only"; that premise was wrong, and the removal was harmless only because the branch
was the redundant `!IsWeb && Platform.isIOS` pairing described above.

## Verifying

`fvm flutter analyze` will not catch a web break — `dart:io` failures are runtime, and missing
plugin implementations surface only in the browser. Build the web target when a change touches
platform checks, local-DB reads, or a native plugin:

```bash
cd apps/tawseel && fvm flutter build web --debug
```
