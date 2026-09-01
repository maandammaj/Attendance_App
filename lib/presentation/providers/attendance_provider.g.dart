// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayAttendanceHash() => r'419ed477bc4b014e2526a0968fd95b8dadea454d';

/// See also [todayAttendance].
@ProviderFor(todayAttendance)
final todayAttendanceProvider =
    AutoDisposeFutureProvider<AttendanceEntity?>.internal(
      todayAttendance,
      name: r'todayAttendanceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$todayAttendanceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayAttendanceRef = AutoDisposeFutureProviderRef<AttendanceEntity?>;
String _$monthlyAttendanceHash() => r'7398fc7531de55a42d8206771a946373724cfd33';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [monthlyAttendance].
@ProviderFor(monthlyAttendance)
const monthlyAttendanceProvider = MonthlyAttendanceFamily();

/// See also [monthlyAttendance].
class MonthlyAttendanceFamily
    extends Family<AsyncValue<List<AttendanceEntity>>> {
  /// See also [monthlyAttendance].
  const MonthlyAttendanceFamily();

  /// See also [monthlyAttendance].
  MonthlyAttendanceProvider call({required int year, required int month}) {
    return MonthlyAttendanceProvider(year: year, month: month);
  }

  @override
  MonthlyAttendanceProvider getProviderOverride(
    covariant MonthlyAttendanceProvider provider,
  ) {
    return call(year: provider.year, month: provider.month);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'monthlyAttendanceProvider';
}

/// See also [monthlyAttendance].
class MonthlyAttendanceProvider
    extends AutoDisposeFutureProvider<List<AttendanceEntity>> {
  /// See also [monthlyAttendance].
  MonthlyAttendanceProvider({required int year, required int month})
    : this._internal(
        (ref) => monthlyAttendance(
          ref as MonthlyAttendanceRef,
          year: year,
          month: month,
        ),
        from: monthlyAttendanceProvider,
        name: r'monthlyAttendanceProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$monthlyAttendanceHash,
        dependencies: MonthlyAttendanceFamily._dependencies,
        allTransitiveDependencies:
            MonthlyAttendanceFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  MonthlyAttendanceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  Override overrideWith(
    FutureOr<List<AttendanceEntity>> Function(MonthlyAttendanceRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyAttendanceProvider._internal(
        (ref) => create(ref as MonthlyAttendanceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AttendanceEntity>> createElement() {
    return _MonthlyAttendanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyAttendanceProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlyAttendanceRef
    on AutoDisposeFutureProviderRef<List<AttendanceEntity>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _MonthlyAttendanceProviderElement
    extends AutoDisposeFutureProviderElement<List<AttendanceEntity>>
    with MonthlyAttendanceRef {
  _MonthlyAttendanceProviderElement(super.provider);

  @override
  int get year => (origin as MonthlyAttendanceProvider).year;
  @override
  int get month => (origin as MonthlyAttendanceProvider).month;
}

String _$attendanceStatsHash() => r'1a6f2b7e07e53ff6aa2cf128fb5ec9458475bf0f';

/// See also [attendanceStats].
@ProviderFor(attendanceStats)
const attendanceStatsProvider = AttendanceStatsFamily();

/// See also [attendanceStats].
class AttendanceStatsFamily extends Family<AsyncValue<MonthlyStats>> {
  /// See also [attendanceStats].
  const AttendanceStatsFamily();

  /// See also [attendanceStats].
  AttendanceStatsProvider call({required int year, required int month}) {
    return AttendanceStatsProvider(year: year, month: month);
  }

  @override
  AttendanceStatsProvider getProviderOverride(
    covariant AttendanceStatsProvider provider,
  ) {
    return call(year: provider.year, month: provider.month);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'attendanceStatsProvider';
}

/// See also [attendanceStats].
class AttendanceStatsProvider extends AutoDisposeFutureProvider<MonthlyStats> {
  /// See also [attendanceStats].
  AttendanceStatsProvider({required int year, required int month})
    : this._internal(
        (ref) => attendanceStats(
          ref as AttendanceStatsRef,
          year: year,
          month: month,
        ),
        from: attendanceStatsProvider,
        name: r'attendanceStatsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$attendanceStatsHash,
        dependencies: AttendanceStatsFamily._dependencies,
        allTransitiveDependencies:
            AttendanceStatsFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  AttendanceStatsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  Override overrideWith(
    FutureOr<MonthlyStats> Function(AttendanceStatsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AttendanceStatsProvider._internal(
        (ref) => create(ref as AttendanceStatsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MonthlyStats> createElement() {
    return _AttendanceStatsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AttendanceStatsProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AttendanceStatsRef on AutoDisposeFutureProviderRef<MonthlyStats> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _AttendanceStatsProviderElement
    extends AutoDisposeFutureProviderElement<MonthlyStats>
    with AttendanceStatsRef {
  _AttendanceStatsProviderElement(super.provider);

  @override
  int get year => (origin as AttendanceStatsProvider).year;
  @override
  int get month => (origin as AttendanceStatsProvider).month;
}

String _$attendanceControllerHash() =>
    r'4f7b509eddde3795089feeace33dadc77d73d107';

/// See also [AttendanceController].
@ProviderFor(AttendanceController)
final attendanceControllerProvider =
    AutoDisposeAsyncNotifierProvider<AttendanceController, void>.internal(
      AttendanceController.new,
      name: r'attendanceControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$attendanceControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AttendanceController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
