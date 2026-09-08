import 'package:attendance_budget_app/domain/entities/attendance_entity.dart';
import 'package:flutter_test/flutter_test.dart';

/// يحاكي ما يفعله المستودع: البحث عن الجلسة المفتوحة عبر الجهات كلها،
/// لا داخل الجهة المعروضة وحدها.
AttendanceEntity? findOpen(
  List<AttendanceEntity> records, {
  int? companyId,
}) {
  final open = records.where((r) => r.isOpen);
  final scoped =
      companyId == null ? open : open.where((r) => r.companyId == companyId);
  return scoped.isEmpty ? null : scoped.first;
}

AttendanceEntity _record({
  required int id,
  required int companyId,
  required bool isOpen,
}) {
  final date = DateTime(2026, 9, 1);
  return AttendanceEntity(
    id: id,
    companyId: companyId,
    date: date,
    sessions: [
      WorkSessionEntity(checkIn: date, checkOut: isOpen ? null : date),
    ],
    totalPresenceMinutes: 0,
    sessionCount: 1,
    workedHours: 0,
    workedMinutes: 0,
    requiredHours: 8,
    requiredMinutes: 0,
    overtimeHours: 0,
    overtimeMinutes: 0,
    overtimeValue: 0,
    deficitHours: 0,
    deficitMinutes: 0,
    deficitValue: 0,
    isBiometricVerified: true,
    dayType: 'regular',
    // isOpen حقل مخزَّن على السجل (Isar لا يستعلم داخل قائمة مضمّنة).
    isOpen: isOpen,
  );
}

void main() {
  group('الانصراف بعد تبديل الجهة', () {
    // حضور في الجهة 1، ثم بُدّلت المعروضة إلى الجهة 2.
    final records = [_record(id: 1, companyId: 1, isOpen: true)];

    test('يجد الجلسة المفتوحة وإن كانت في جهة غير المعروضة', () {
      expect(findOpen(records)?.companyId, 1,
          reason: 'البحث بلا تقييد بالجهة هو ما يمنع "لا توجد جلسة مفتوحة"');
    });

    test('التقييد بالجهة المعروضة كان يُخفي الجلسة — سبب العطل', () {
      expect(findOpen(records, companyId: 2), isNull);
    });

    test('التقييد الصريح بجهة الجلسة يجدها', () {
      expect(findOpen(records, companyId: 1)?.id, 1);
    });
  });

  test('بلا جلسات مفتوحة يعيد null بدل رمي استثناء', () {
    expect(findOpen([_record(id: 2, companyId: 1, isOpen: false)]), isNull);
  });
}
