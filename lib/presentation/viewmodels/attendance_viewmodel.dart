import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/attendance_entity.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../data/local/repositories/attendance_repository_impl.dart';

// 1. مزود لمستودع الحضور (يحصل على النسخة المحققة Implementation)
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepositoryImpl(); // قم بتغيير اسم الكلاس هنا حسب اسم الـ Implementation لديك
});

// 2. مزود يجلب سجلات الشهر مباشرة باستدلال المعاملين (year و month)
final monthlyAttendanceProvider = FutureProvider.family<List<AttendanceEntity>, ({int year, int month})>((ref, date) async {
  final repo = ref.watch(attendanceRepositoryProvider);
  return await repo.getMonthlyRecords(date.year, date.month);
});

// 3. مزود حالة تسجيل اليوم
final todayAttendanceProvider = FutureProvider<AttendanceEntity?>((ref) async {
  final repo = ref.watch(attendanceRepositoryProvider);
  return await repo.getTodayRecord();
});

// 4. الـ ViewModel لإدارة العمليات التفاعلية (تسجيل الدخول والخروج)
final attendanceViewModelProvider = StateNotifierProvider<AttendanceViewModel, AsyncValue<void>>((ref) {
  final repo = ref.watch(attendanceRepositoryProvider);
  return AttendanceViewModel(repo, ref);
});

class AttendanceViewModel extends StateNotifier<AsyncValue<void>> {
  final AttendanceRepository _repository;
  final Ref _ref;

  AttendanceViewModel(this._repository, this._ref) : super(const AsyncValue.data(null));

  Future<void> checkIn() async {
    state = const AsyncValue.loading();
    try {
      await _repository.checkIn(DateTime.now());
      // تحديث حالة تسجيل اليوم وسجل الشهر تلقائياً
      _ref.invalidate(todayAttendanceProvider);
      _ref.invalidate(monthlyAttendanceProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> checkOut() async {
    state = const AsyncValue.loading();
    try {
      await _repository.checkOut(DateTime.now());
      // تحديث حالة تسجيل اليوم وسجل الشهر تلقائياً
      _ref.invalidate(todayAttendanceProvider);
      _ref.invalidate(monthlyAttendanceProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}