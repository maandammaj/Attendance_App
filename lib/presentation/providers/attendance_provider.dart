import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/repositories/attendance_repository_impl.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/usecases/attendance/check_in_usecase.dart';
import '../../domain/usecases/attendance/check_out_usecase.dart';
import '../../domain/usecases/attendance/get_monthly_stats_usecase.dart';
import '../../core/utils/biometric_auth.dart';
import 'profile_provider.dart';

part 'attendance_provider.g.dart';

final attendanceRepositoryProvider =
    Provider((ref) => AttendanceRepositoryImpl());

final checkInUseCaseProvider = Provider(
  (ref) => CheckInUseCase(ref.read(attendanceRepositoryProvider)),
);

final checkOutUseCaseProvider = Provider(
  (ref) => CheckOutUseCase(ref.read(attendanceRepositoryProvider)),
);

final getMonthlyStatsUseCaseProvider = Provider(
  (ref) => GetMonthlyStatsUseCase(ref.read(attendanceRepositoryProvider)),
);

@riverpod
Future<AttendanceEntity?> todayAttendance(Ref ref) async {
  final repo = ref.read(attendanceRepositoryProvider);
  return await repo.getTodayRecord();
}

@riverpod
Future<List<AttendanceEntity>> monthlyAttendance(
  Ref ref, {
  required int year,
  required int month,
}) async {
  final repo = ref.read(attendanceRepositoryProvider);
  return await repo.getMonthlyRecords(year, month);
}

@riverpod
Future<MonthlyStats> attendanceStats(
  Ref ref, {
  required int year,
  required int month,
}) async {
  final profileAsync = ref.watch(profileProvider);
  final profile = profileAsync.valueOrNull;

  if (profile == null) {
    return MonthlyStats(
      expectedWorkingDays: 0,
      actualWorkingDays: 0,
      absentDays: 0,
      totalOvertimeHours: 0,
      totalLatenessHours: 0,
      totalAbsenceHours: 0,
      totalOvertimeValue: 0,
      totalDeficitValue: 0,
      netExtraValue: 0,
    );
  }

  final useCase = ref.read(getMonthlyStatsUseCaseProvider);
  return await useCase(year, month, profile);
}

@riverpod
class AttendanceController extends _$AttendanceController {
  @override
  FutureOr<void> build() => null;

  bool _isProcessing = false;

  void _invalidateAll() {
    ref.invalidate(todayAttendanceProvider);
    ref.invalidate(monthlyAttendanceProvider);
    ref.invalidate(attendanceStatsProvider);
  }

  Future<bool> checkIn() async {
    if (_isProcessing) return false;
    _isProcessing = true;
    state = const AsyncLoading();
    try {
      final auth = BiometricAuthService();
      bool authResult = false;
      
      try {
        final available = await auth.isAvailable;
        if (available) {
          authResult = await auth.authenticate(
            localizedReason: 'سجل دخولك الآن',
          );
        } else {
          // إذا لم تتوفر البصمة (محاكي أو ويندوز)، نعتبر التحقق ناجحاً للتسهيل في بيئة التطوير
          // أو يمكن طلب رمز PIN. هنا سأفترض النجاح مؤقتاً للتأكد من عمل المنطق.
          authResult = true; 
        }
      } catch (e) {
        state = AsyncError('خطأ في البصمة: $e', StackTrace.current);
        return false;
      }

      if (!authResult) {
        state = AsyncError('التحقق مطلوب للاستمرار', StackTrace.current);
        return false;
      }

      final useCase = ref.read(checkInUseCaseProvider);
      await useCase(DateTime.now());
      _invalidateAll();
      state = const AsyncData(null);
      return true;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    } finally {
      _isProcessing = false;
    }
  }

  Future<bool> checkOut() async {
    if (_isProcessing) return false;
    _isProcessing = true;
    state = const AsyncLoading();
    try {
      final auth = BiometricAuthService();
      bool authResult = false;
      
      try {
        final available = await auth.isAvailable;
        if (available) {
          authResult = await auth.authenticate(
            localizedReason: 'سجل انصرافك الآن',
          );
        } else {
          authResult = true;
        }
      } catch (e) {
        state = AsyncError('خطأ في البصمة: $e', StackTrace.current);
        return false;
      }

      if (!authResult) {
        state = AsyncError('التحقق مطلوب للاستمرار', StackTrace.current);
        return false;
      }

      final useCase = ref.read(checkOutUseCaseProvider);
      await useCase(DateTime.now());
      _invalidateAll();
      state = const AsyncData(null);
      return true;
    } catch (e, stack) {
      state = AsyncError(e, stack);
      return false;
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> addManual({
    required DateTime date,
    required DateTime checkIn,
    required DateTime checkOut,
    String? notes,
  }) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(attendanceRepositoryProvider);
      await repo.addManualRecord(
        date: date,
        checkIn: checkIn,
        checkOut: checkOut,
        notes: notes,
      );
      _invalidateAll();
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> deleteRecord(int id) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(attendanceRepositoryProvider);
      await repo.deleteRecord(id);
      _invalidateAll();
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> updateRecord(AttendanceEntity entity) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(attendanceRepositoryProvider);
      await repo.updateRecord(entity);
      _invalidateAll();
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
