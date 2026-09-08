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

/// أيام التقويم المُعلَّمة لشهر — تُقرأ مرّة وتُمرَّر للحساب.

@ProviderFor(monthCalendar)
final monthCalendarProvider = MonthCalendarFamily._();

/// أيام التقويم المُعلَّمة لشهر — تُقرأ مرّة وتُمرَّر للحساب.

final class MonthCalendarProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CalendarDayEntity>>,
          List<CalendarDayEntity>,
          FutureOr<List<CalendarDayEntity>>
        >
    with
        $FutureModifier<List<CalendarDayEntity>>,
        $FutureProvider<List<CalendarDayEntity>> {
  /// أيام التقويم المُعلَّمة لشهر — تُقرأ مرّة وتُمرَّر للحساب.
  MonthCalendarProvider._({
    required MonthCalendarFamily super.from,
    required ({int year, int month}) super.argument,
  }) : super(
         retry: null,
         name: r'monthCalendarProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$monthCalendarHash();

  @override
  String toString() {
    return r'monthCalendarProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<CalendarDayEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CalendarDayEntity>> create(Ref ref) {
    final argument = this.argument as ({int year, int month});
    return monthCalendar(ref, year: argument.year, month: argument.month);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthCalendarProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthCalendarHash() => r'ea10173b682127c003afd2c9189d4d7b98e57fa4';

/// أيام التقويم المُعلَّمة لشهر — تُقرأ مرّة وتُمرَّر للحساب.

final class MonthCalendarFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<CalendarDayEntity>>,
          ({int year, int month})
        > {
  MonthCalendarFamily._()
    : super(
        retry: null,
        name: r'monthCalendarProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// أيام التقويم المُعلَّمة لشهر — تُقرأ مرّة وتُمرَّر للحساب.

  MonthCalendarProvider call({required int year, required int month}) =>
      MonthCalendarProvider._(argument: (year: year, month: month), from: this);

  @override
  String toString() => r'monthCalendarProvider';
}

/// إجازات شهر في الجهة الفعّالة.

@ProviderFor(monthLeaves)
final monthLeavesProvider = MonthLeavesFamily._();

/// إجازات شهر في الجهة الفعّالة.

final class MonthLeavesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LeaveEntity>>,
          List<LeaveEntity>,
          FutureOr<List<LeaveEntity>>
        >
    with
        $FutureModifier<List<LeaveEntity>>,
        $FutureProvider<List<LeaveEntity>> {
  /// إجازات شهر في الجهة الفعّالة.
  MonthLeavesProvider._({
    required MonthLeavesFamily super.from,
    required ({int year, int month}) super.argument,
  }) : super(
         retry: null,
         name: r'monthLeavesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$monthLeavesHash();

  @override
  String toString() {
    return r'monthLeavesProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<LeaveEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LeaveEntity>> create(Ref ref) {
    final argument = this.argument as ({int year, int month});
    return monthLeaves(ref, year: argument.year, month: argument.month);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthLeavesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthLeavesHash() => r'6e03ce8e8b4acb5e3d50f09b582a2f7c05b276c6';

/// إجازات شهر في الجهة الفعّالة.

final class MonthLeavesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<LeaveEntity>>,
          ({int year, int month})
        > {
  MonthLeavesFamily._()
    : super(
        retry: null,
        name: r'monthLeavesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// إجازات شهر في الجهة الفعّالة.

  MonthLeavesProvider call({required int year, required int month}) =>
      MonthLeavesProvider._(argument: (year: year, month: month), from: this);

  @override
  String toString() => r'monthLeavesProvider';
}

/// كل إجازات سنة في الجهة الفعّالة.

@ProviderFor(allLeaves)
final allLeavesProvider = AllLeavesFamily._();

/// كل إجازات سنة في الجهة الفعّالة.

final class AllLeavesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LeaveEntity>>,
          List<LeaveEntity>,
          FutureOr<List<LeaveEntity>>
        >
    with
        $FutureModifier<List<LeaveEntity>>,
        $FutureProvider<List<LeaveEntity>> {
  /// كل إجازات سنة في الجهة الفعّالة.
  AllLeavesProvider._({
    required AllLeavesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'allLeavesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$allLeavesHash();

  @override
  String toString() {
    return r'allLeavesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<LeaveEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LeaveEntity>> create(Ref ref) {
    final argument = this.argument as int;
    return allLeaves(ref, year: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AllLeavesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$allLeavesHash() => r'f175dd401c5c0aef5c1c2747477a498a78df49aa';

/// كل إجازات سنة في الجهة الفعّالة.

final class AllLeavesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<LeaveEntity>>, int> {
  AllLeavesFamily._()
    : super(
        retry: null,
        name: r'allLeavesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// كل إجازات سنة في الجهة الفعّالة.

  AllLeavesProvider call({required int year}) =>
      AllLeavesProvider._(argument: year, from: this);

  @override
  String toString() => r'allLeavesProvider';
}

/// أرصدة الإجازات لسنة في الجهة الفعّالة.

@ProviderFor(leaveBalances)
final leaveBalancesProvider = LeaveBalancesFamily._();

/// أرصدة الإجازات لسنة في الجهة الفعّالة.

final class LeaveBalancesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LeaveBalanceEntity>>,
          List<LeaveBalanceEntity>,
          FutureOr<List<LeaveBalanceEntity>>
        >
    with
        $FutureModifier<List<LeaveBalanceEntity>>,
        $FutureProvider<List<LeaveBalanceEntity>> {
  /// أرصدة الإجازات لسنة في الجهة الفعّالة.
  LeaveBalancesProvider._({
    required LeaveBalancesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'leaveBalancesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$leaveBalancesHash();

  @override
  String toString() {
    return r'leaveBalancesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<LeaveBalanceEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LeaveBalanceEntity>> create(Ref ref) {
    final argument = this.argument as int;
    return leaveBalances(ref, year: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LeaveBalancesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$leaveBalancesHash() => r'1d11f51185a4376e27ffac920482712cfc62df0f';

/// أرصدة الإجازات لسنة في الجهة الفعّالة.

final class LeaveBalancesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<LeaveBalanceEntity>>, int> {
  LeaveBalancesFamily._()
    : super(
        retry: null,
        name: r'leaveBalancesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// أرصدة الإجازات لسنة في الجهة الفعّالة.

  LeaveBalancesProvider call({required int year}) =>
      LeaveBalancesProvider._(argument: year, from: this);

  @override
  String toString() => r'leaveBalancesProvider';
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

String _$attendanceStatsHash() => r'e4eb749186be3292181e774d4324ea8cc7d7c52d';

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
