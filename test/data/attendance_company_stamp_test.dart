import 'package:attendance_budget_app/data/models/attendance_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// سجل حضور فارغ بجهة محددة — يحاكي `_newRecord`.
AttendanceModel record(DateTime day, int companyId) {
  return AttendanceModel()
    ..companyId = companyId
    ..date = day
    ..sessions = []
    ..requiredHours = 8
    ..requiredMinutes = 0
    ..workedHours = 0
    ..workedMinutes = 0
    ..overtimeHours = 0
    ..overtimeMinutes = 0
    ..overtimeValue = 0
    ..deficitHours = 0
    ..deficitMinutes = 0
    ..deficitValue = 0
    ..isBiometricVerified = false
    ..isAbsent = false
    ..dayType = DayType.regular;
}

/// يحاكي ترشيح الاستعلامات بالجهة.
List<AttendanceModel> scoped(List<AttendanceModel> all, int companyId) =>
    all.where((r) => r.companyId == companyId).toList();

void main() {
  final day = DateTime(2026, 9, 2);

  test('السجل الجديد يحمل معرّف جهته لا صفراً', () {
    // بدونه يُكتب بـ companyId = 0 فلا يجده أي استعلام مُرشَّح بالجهة —
    // وهذا ما جعل زر الانصراف يقول "لا توجد جلسة دوام مفتوحة" بعد حضور ناجح.
    expect(record(day, 7).companyId, 7);
  });

  test('سجل بلا جهة يختفي من استعلام الجهة — سبب العطل', () {
    expect(scoped([record(day, 0)], 7), isEmpty);
    expect(scoped([record(day, 7)], 7), hasLength(1));
  });

  test('سجلات جهتين لنفس اليوم لا تختلطان', () {
    final all = [record(day, 1), record(day, 2)];

    expect(scoped(all, 1).single.companyId, 1);
    expect(scoped(all, 2).single.companyId, 2);
  });
}
