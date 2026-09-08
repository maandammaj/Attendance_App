// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// حالة تسليم التنبيهات كما يراها النظام.

@ProviderFor(notificationDiagnostics)
final notificationDiagnosticsProvider = NotificationDiagnosticsProvider._();

/// حالة تسليم التنبيهات كما يراها النظام.

final class NotificationDiagnosticsProvider
    extends
        $FunctionalProvider<
          AsyncValue<NotificationDiagnostics>,
          NotificationDiagnostics,
          FutureOr<NotificationDiagnostics>
        >
    with
        $FutureModifier<NotificationDiagnostics>,
        $FutureProvider<NotificationDiagnostics> {
  /// حالة تسليم التنبيهات كما يراها النظام.
  NotificationDiagnosticsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationDiagnosticsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationDiagnosticsHash();

  @$internal
  @override
  $FutureProviderElement<NotificationDiagnostics> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<NotificationDiagnostics> create(Ref ref) {
    return notificationDiagnostics(ref);
  }
}

String _$notificationDiagnosticsHash() =>
    r'6085d93c0c86e1b4879aa4fd9d7b6c95a4d42fbf';

@ProviderFor(reminderSettings)
final reminderSettingsProvider = ReminderSettingsProvider._();

final class ReminderSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReminderSettingsEntity>,
          ReminderSettingsEntity,
          FutureOr<ReminderSettingsEntity>
        >
    with
        $FutureModifier<ReminderSettingsEntity>,
        $FutureProvider<ReminderSettingsEntity> {
  ReminderSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderSettingsHash();

  @$internal
  @override
  $FutureProviderElement<ReminderSettingsEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReminderSettingsEntity> create(Ref ref) {
    return reminderSettings(ref);
  }
}

String _$reminderSettingsHash() => r'cab030f6cc6c4f7d4a29c034a0716b27e75abf86';

@ProviderFor(budgetLimits)
final budgetLimitsProvider = BudgetLimitsProvider._();

final class BudgetLimitsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BudgetLimitEntity>>,
          List<BudgetLimitEntity>,
          FutureOr<List<BudgetLimitEntity>>
        >
    with
        $FutureModifier<List<BudgetLimitEntity>>,
        $FutureProvider<List<BudgetLimitEntity>> {
  BudgetLimitsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetLimitsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetLimitsHash();

  @$internal
  @override
  $FutureProviderElement<List<BudgetLimitEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BudgetLimitEntity>> create(Ref ref) {
    return budgetLimits(ref);
  }
}

String _$budgetLimitsHash() => r'bc0cc6349b38b93b93b50932093a1153cf040a71';

@ProviderFor(budgetStatus)
final budgetStatusProvider = BudgetStatusFamily._();

final class BudgetStatusProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BudgetStatusEntity>>,
          List<BudgetStatusEntity>,
          FutureOr<List<BudgetStatusEntity>>
        >
    with
        $FutureModifier<List<BudgetStatusEntity>>,
        $FutureProvider<List<BudgetStatusEntity>> {
  BudgetStatusProvider._({
    required BudgetStatusFamily super.from,
    required ({int year, int month}) super.argument,
  }) : super(
         retry: null,
         name: r'budgetStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$budgetStatusHash();

  @override
  String toString() {
    return r'budgetStatusProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<BudgetStatusEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BudgetStatusEntity>> create(Ref ref) {
    final argument = this.argument as ({int year, int month});
    return budgetStatus(ref, year: argument.year, month: argument.month);
  }

  @override
  bool operator ==(Object other) {
    return other is BudgetStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$budgetStatusHash() => r'220f1ae76c8100dd6e84139477f7b6c761fe0bb2';

final class BudgetStatusFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<BudgetStatusEntity>>,
          ({int year, int month})
        > {
  BudgetStatusFamily._()
    : super(
        retry: null,
        name: r'budgetStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BudgetStatusProvider call({required int year, required int month}) =>
      BudgetStatusProvider._(argument: (year: year, month: month), from: this);

  @override
  String toString() => r'budgetStatusProvider';
}

@ProviderFor(ReminderController)
final reminderControllerProvider = ReminderControllerProvider._();

final class ReminderControllerProvider
    extends $AsyncNotifierProvider<ReminderController, void> {
  ReminderControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderControllerHash();

  @$internal
  @override
  ReminderController create() => ReminderController();
}

String _$reminderControllerHash() =>
    r'648db70ebe91ecfc461e2277cdd68483a2729950';

abstract class _$ReminderController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
