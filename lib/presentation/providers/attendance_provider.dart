import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/repositories/attendance_repository_impl.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/usecases/attendance/check_in_usecase.dart';
import '../../domain/usecases/attendance/check_out_usecase.dart';
import '../../domain/usecases/attendance/get_monthly_stats_usecase.dart';
import '../../core/utils/biometric_auth.dart';
import '../../domain/services/attendance_auth_policy.dart';
import 'analytics_provider.dart';
import 'company_provider.dart';
import 'reminder_provider.dart';

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
  final company = ref.watch(activeCompanyProvider).valueOrNull;

  if (company == null) {
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
  return await useCase(year, month, company);
}

/// جلسة مفتوحة في أي جهة — تكشف ما نُسي في جهة غير المعروضة.
@riverpod
Future<AttendanceEntity?> anyOpenSession(Ref ref) async {
  return await ref.read(attendanceRepositoryProvider).getAnyOpenSession();
}

// keepAlive: هذه المتحكّمات بعمر التطبيق لا بعمر شاشة. بدونها يُتلَف
// المتحكّم حين تُبدَّل شاشته أثناء عملية جارية — بوابة الإعداد تفعل ذلك فور
// إنشاء أول جهة — فتُكتب الحالة على مزوّد مُتلَف ويُرمى
// "Bad state: Future already completed".
@Riverpod(keepAlive: true)
class AttendanceController extends _$AttendanceController {
  @override
  FutureOr<void> build() => null;

  bool _isProcessing = false;

  void _invalidateAll() {
    ref.invalidate(todayAttendanceProvider);
    ref.invalidate(anyOpenSessionProvider);
    ref.invalidate(monthlyAttendanceProvider);
    ref.invalidate(attendanceStatsProvider);
    ref.invalidate(analyticsReportProvider);
  }

  /// يبدأ جلسة دوام جديدة. اليوم يقبل عدة جلسات.
  Future<AttendanceActionResult> checkIn({int? companyId}) => _run(
        reason: 'أكّد هويتك لتسجيل الحضور',
        successMessage: 'تم تسجيل الحضور',
        action: (verified) async {
          await ref.read(checkInUseCaseProvider)(
            DateTime.now(),
            isBiometricVerified: verified,
            companyId: companyId,
          );
        },
      );

  /// ينهي الجلسة المفتوحة.
  Future<AttendanceActionResult> checkOut() => _run(
        reason: 'أكّد هويتك لتسجيل الانصراف',
        successMessage: 'تم تسجيل الانصراف',
        action: (_) async {
          await ref.read(checkOutUseCaseProvider)(DateTime.now());
        },
      );

  /// مسار واحد للتحقق ثم التنفيذ، حتى لا تتفرّع سياسة الأمان بين الزرّين.
  ///
  /// القرار كله في [AttendanceAuthPolicy]: متى تلزم البصمة، ومتى يُقبل قفل
  /// الجهاز، ومتى يُمنع التسجيل. هنا التنفيذ فقط.
  Future<AttendanceActionResult> _run({
    required String reason,
    required String successMessage,
    required Future<void> Function(bool isBiometricVerified) action,
  }) async {
    if (_isProcessing) {
      return const AttendanceActionResult.failure('العملية قيد التنفيذ');
    }
    _isProcessing = true;
    state = const AsyncLoading();

    try {
      final settings = await ref.read(reminderSettingsProvider.future);
      final auth = BiometricAuthService();
      final capability = await auth.capability();
      final requirement = AttendanceAuthPolicy.resolve(
        capability: capability,
        settings: settings,
      );

      if (requirement == AuthRequirement.blocked) {
        state = const AsyncData(null);
        return AttendanceActionResult.failure(
            AttendanceAuthPolicy.blockedReason(capability));
      }

      var isVerified = false;
      if (requirement != AuthRequirement.none) {
        final result = await auth.authenticate(
          reason: reason,
          // البصمة المسجّلة لا يُقبل عنها بديل.
          allowDeviceCredential:
              requirement == AuthRequirement.deviceCredential,
        );
        if (!result.isSuccess) {
          state = const AsyncData(null);
          return AttendanceActionResult.failure(
              result.message ?? 'تعذّر التحقق من هويتك');
        }
        isVerified = true;
      }

      await action(isVerified);
      _invalidateAll();
      state = const AsyncData(null);

      return AttendanceActionResult.success(
        isVerified ? successMessage : '$successMessage — دون تحقق',
        isBiometricVerified: isVerified,
      );
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return AttendanceActionResult.failure(_readable(error));
    } finally {
      _isProcessing = false;
    }
  }

  static String _readable(Object error) {
    final text = error.toString();
    return text.startsWith('Exception: ')
        ? text.substring('Exception: '.length)
        : text;
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

/// نتيجة عملية حضور/انصراف، جاهزة للعرض دون أن تعرف الواجهة تفاصيل الأمان.
class AttendanceActionResult {
  const AttendanceActionResult.success(
    this.message, {
    this.isBiometricVerified = true,
  }) : isSuccess = true;

  const AttendanceActionResult.failure(this.message)
      : isSuccess = false,
        isBiometricVerified = false;

  final bool isSuccess;
  final String message;
  final bool isBiometricVerified;
}
