// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(todayAttendance)
final todayAttendanceProvider = TodayAttendanceProvider._();

final class TodayAttendanceProvider
    extends
        $FunctionalProvider<
          AsyncValue<AttendanceEntity?>,
          AttendanceEntity?,
          FutureOr<AttendanceEntity?>
        >
    with
        $FutureModifier<AttendanceEntity?>,
        $FutureProvider<AttendanceEntity?> {
  TodayAttendanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todayAttendanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todayAttendanceHash();

  @$internal
  @override
  $FutureProviderElement<AttendanceEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AttendanceEntity?> create(Ref ref) {
    return todayAttendance(ref);
  }
}

String _$todayAttendanceHash() => r'419ed477bc4b014e2526a0968fd95b8dadea454d';

@ProviderFor(monthlyAttendance)
final monthlyAttendanceProvider = MonthlyAttendanceFamily._();

final class MonthlyAttendanceProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AttendanceEntity>>,
          List<AttendanceEntity>,
          FutureOr<List<AttendanceEntity>>
        >
    with
        $FutureModifier<List<AttendanceEntity>>,
        $FutureProvider<List<AttendanceEntity>> {
  MonthlyAttendanceProvider._({
    required MonthlyAttendanceFamily super.from,
    required ({int year, int month}) super.argument,
  }) : super(
         retry: null,
         name: r'monthlyAttendanceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$monthlyAttendanceHash();

  @override
  String toString() {
    return r'monthlyAttendanceProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<AttendanceEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AttendanceEntity>> create(Ref ref) {
    final argument = this.argument as ({int year, int month});
    return monthlyAttendance(ref, year: argument.year, month: argument.month);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyAttendanceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthlyAttendanceHash() => r'7398fc7531de55a42d8206771a946373724cfd33';

final class MonthlyAttendanceFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<AttendanceEntity>>,
          ({int year, int month})
        > {
  MonthlyAttendanceFamily._()
    : super(
        retry: null,
        name: r'monthlyAttendanceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MonthlyAttendanceProvider call({required int year, required int month}) =>
      MonthlyAttendanceProvider._(
        argument: (year: year, month: month),
        from: this,
      );

  @override
  String toString() => r'monthlyAttendanceProvider';
}

@ProviderFor(attendanceStats)
final attendanceStatsProvider = AttendanceStatsFamily._();

final class AttendanceStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<MonthlyStats>,
          MonthlyStats,
          FutureOr<MonthlyStats>
        >
    with $FutureModifier<MonthlyStats>, $FutureProvider<MonthlyStats> {
  AttendanceStatsProvider._({
    required AttendanceStatsFamily super.from,
    required ({int year, int month}) super.argument,
  }) : super(
         retry: null,
         name: r'attendanceStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$attendanceStatsHash();

  @override
  String toString() {
    return r'attendanceStatsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<MonthlyStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MonthlyStats> create(Ref ref) {
    final argument = this.argument as ({int year, int month});
    return attendanceStats(ref, year: argument.year, month: argument.month);
  }

  @override
  bool operator ==(Object other) {
    return other is AttendanceStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$attendanceStatsHash() => r'663e3a7ad2952c4d8bb9a5d5befcb1545eae6ce0';

final class AttendanceStatsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<MonthlyStats>,
          ({int year, int month})
        > {
  AttendanceStatsFamily._()
    : super(
        retry: null,
        name: r'attendanceStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AttendanceStatsProvider call({required int year, required int month}) =>
      AttendanceStatsProvider._(
        argument: (year: year, month: month),
        from: this,
      );

  @override
  String toString() => r'attendanceStatsProvider';
}

/// جلسة مفتوحة في أي جهة — تكشف ما نُسي في جهة غير المعروضة.

@ProviderFor(anyOpenSession)
final anyOpenSessionProvider = AnyOpenSessionProvider._();

/// جلسة مفتوحة في أي جهة — تكشف ما نُسي في جهة غير المعروضة.

final class AnyOpenSessionProvider
    extends
        $FunctionalProvider<
          AsyncValue<AttendanceEntity?>,
          AttendanceEntity?,
          FutureOr<AttendanceEntity?>
        >
    with
        $FutureModifier<AttendanceEntity?>,
        $FutureProvider<AttendanceEntity?> {
  /// جلسة مفتوحة في أي جهة — تكشف ما نُسي في جهة غير المعروضة.
  AnyOpenSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'anyOpenSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$anyOpenSessionHash();

  @$internal
  @override
  $FutureProviderElement<AttendanceEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AttendanceEntity?> create(Ref ref) {
    return anyOpenSession(ref);
  }
}

String _$anyOpenSessionHash() => r'0004c38ed2c0e6b8fe123bcdc61083c63d299abe';

@ProviderFor(AttendanceController)
final attendanceControllerProvider = AttendanceControllerProvider._();

final class AttendanceControllerProvider
    extends $AsyncNotifierProvider<AttendanceController, void> {
  AttendanceControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'attendanceControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$attendanceControllerHash();

  @$internal
  @override
  AttendanceController create() => AttendanceController();
}

String _$attendanceControllerHash() =>
    r'12729d4538ed72e9de676861af6624963ae54612';

abstract class _$AttendanceController extends $AsyncNotifier<void> {
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
