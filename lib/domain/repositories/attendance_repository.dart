import '../entities/attendance_entity.dart';

abstract class AttendanceRepository {
  Future<AttendanceEntity?> getTodayRecord();
  Future<List<AttendanceEntity>> getMonthlyRecords(int year, int month);
  Future<void> checkIn(DateTime time);
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
