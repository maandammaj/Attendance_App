import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<AttendanceEntity?> getTodayRecord();

  /// أي جلسة مفتوحة في أي جهة، مع معرّف جهتها.
  ///
  /// جلسة مفتوحة في جهة غير الفعّالة تبقى مفتوحة وتُنسى؛ هذه تكشفها.
  Future<AttendanceEntity?> getAnyOpenSession();
  Future<List<AttendanceEntity>> getMonthlyRecords(int year, int month);

  /// سجلات الجهة الفعّالة ضمن مدى تواريخ شامل الطرفين.
  Future<List<AttendanceEntity>> getRecordsBetween(DateTime from, DateTime to);

  /// سجلات جهة بعينها — أساس المقارنة بين الجهات.
  Future<List<AttendanceEntity>> getRecordsForCompany(
    int companyId,
    DateTime from,
    DateTime to,
  );
  /// يفتح جلسة دوام جديدة. اليوم يقبل عدة جلسات، لا جلستين مفتوحتين معاً.
  /// يفتح جلسة. [companyId] صريح حين يعمل المستخدم في أكثر من جهة —
  /// الاعتماد على الجهة الفعّالة وحدها يكتب الساعات لجهة خاطئة إن نسي
  /// التبديل، وهو خطأ مالي لا يُكتشف إلا في الكشف.
  Future<void> checkIn(
    DateTime time, {
    bool isBiometricVerified,
    int? companyId,
  });
  /// يغلق الجلسة المفتوحة ويعيد حساب اليوم من كل جلساته.
  Future<void> checkOut(DateTime time);
  Future<void> addManualRecord({
    required DateTime date,
    required DateTime checkIn,
    required DateTime checkOut,
    String? notes,
  });
  Future<void> updateRecord(AttendanceEntity entity);
  Future<void> deleteRecord(int id);
}
