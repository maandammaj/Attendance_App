# Retiring the Legacy `StateProvider` Bus

`StateProvider` (`package:common/core/utils/state_provider.dart`) is the app-wide notification
bus every screen predates Bloc with: a widget mixes in `StateListener`, calls
`StateProvider.subscribe(this)`, and receives an untyped `int` id for every signal any other
screen fires. It is **frozen and being removed** — ADR-003 replaced it with feature-owned streams.

It cannot be deleted in one pass: ~280 live `notify` calls sit inside legacy screens that have not
migrated yet (`order` alone is 24k LOC). So the policy is *freeze, then shrink*.

## Never add a new listener

* **Do not mix in `StateListener`** anywhere. Not in a widget, not in a Bloc, not in a repository.
* **Do not call `StateProvider.subscribe` / `StateProvider.dispose`** outside the one bridge below.
* **Do not add constants** to `ObserverState` (`lib/core/utils/app.dart`) or to `StateProvider`.
  A genuinely new cross-feature signal means the owning feature should expose a stream from its
  repository and the consumer should depend on that repository — not on a global id.

## Listen through the shared bridge instead

[`lib/core/utils/events/app_events_data_source.dart`](../../lib/core/utils/events/app_events_data_source.dart)
is the single subscriber the app needs. It is registered in `_registerCore` and hands out ordinary
streams:

```dart
abstract class AppEventsDataSource {
  Stream<int> get signals;              // raw ids
  Stream<void> whenAny(Set<int> wanted); // payload-free, filtered
}
```

A feature does **not** depend on it directly from a Bloc. It declares its own narrow interface in
its data layer, names the signals it cares about, and injects the bridge:

```dart
class NotificationsEventsDataSourceImpl implements NotificationsEventsDataSource {
  const NotificationsEventsDataSourceImpl(this._events);

  static const Set<int> _watched = {
    StateProvider.SYNC_DATA,
    ObserverState.MARKET_LOADING,
    ObserverState.NOTIFICATION_COUNT_UPDATED,
  };

  final AppEventsDataSource _events;

  @override
  Stream<void> get onExternalChange => _events.whenAny(_watched);
}
```

Reference: [`notifications_events_data_source.dart`](../../lib/features/notifications/data/datasources/notifications_events_data_source.dart)
and its registration in `notifications_injection.dart`. The bloc sees a `Stream<void>`, and tests
substitute a fake of the feature's own interface — no global bus in the test at all.

## Keep notifying while legacy listeners remain

This is the part that is easy to get wrong. A migrated feature that mutates shared data (cart,
address, order status) **must still call `StateProvider.notify(...)`**, because unmigrated screens
are still subscribed and have no other way to hear about it. Removing a `notify` is only safe once
every listener of that signal is gone.

So during a migration:

* **Listeners** — remove them. They become the bridge + a feature stream.
* **Notifiers** — keep them, and add a `// legacy bus: <screens still listening>` note. They are
  removed in the pass that migrates the last listener.

`grep -rn "case ObserverState.SIGNAL_NAME" lib` tells you who is still listening.

## Deleting the bus

**That point has been reached** (2026-08-08): `grep -rl 'StateProvider.subscribe(this)' lib`
returns only `app_events_data_source.dart`, the bridge. Every feature, the app shell and `core/`
are clear.

What is left is the other half — **297 `notify` calls**. They are not dead: they are how a migrated
feature tells the others something changed, and they reach those features *through* the bridge. The
bus cannot be deleted while they are the only channel; what has to happen first is that each
signal's producer and consumer both live in features that can talk through a repository stream
instead.

Four `ObserverState` constants are fully retired so far — `ATTRIBUTE_CHANGED`, `NO_OFFER`,
`SHOW_LOADING_DIALOG`, `HIDE_LOADING_DIALOG` — each because its last producer or consumer was
deleted, not because it was migrated. Retiring the rest is a per-signal job: find its producers,
find which feature's stream should carry it instead, move it, delete the constant.

When the last `notify` is gone: delete the bridge, then `state_provider.dart` and
`state_observer.dart` from `common`, and drop `ObserverState`. `common` is shared with the other
`apps/` brands — check them in the same pass (`grep -rn StateProvider apps/`).

## The implementation is hardened, not safe

`StateProvider.notify` now iterates a copy (a listener may unsubscribe itself mid-delivery),
isolates each listener's exception so one failure cannot swallow the signal for the rest, and logs
a `dispose()` for an observer that was never subscribed — that log line is how a leaked listener
becomes visible. This makes the remaining lifetime survivable; it does not make the pattern
acceptable for new code.
