import 'package:attendance_budget_app/data/local/repositories/attendance_repository_impl.dart';
import 'package:attendance_budget_app/data/local/repositories/calendar_repository_impl.dart';
import 'package:attendance_budget_app/data/models/profile_model.dart';
import 'package:attendance_budget_app/domain/entities/calendar_day_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_database.dart';

OvertimeRate _rate(OvertimeRateKindStored kind, double value) =>
    OvertimeRate()
      ..kind = kind
      ..value = value;

void main() {
  late TestDatabase db;
  late AttendanceRepositoryImpl attendance;
  late CalendarRepositoryImpl calendar;

  final from = DateTime(2026, 10, 1);
  final to = DateTime(2026, 10, 31);

  setUp(() async {
    db = await TestDatabase.open();
    attendance = AttendanceRepositoryImpl();
    calendar = CalendarRepositoryImpl();
  });

  tearDown(() async => db.close());

  test('العطلة الرسمية تُدفع بمعدّلها لا بمعدّل يوم العمل', () async {
    // عادي ×1.5 · عطلة رسمية ×2.5 — أجر الساعة 10.
    final company = await db.addCompany(
      name: 'أ',
      hourlyRate: 10,
      hoursPerDay: 8,
      startTime: '08:00',
      endTime: '16:00',
      overtimePolicy: OvertimePolicy()
        ..normal = _rate(OvertimeRateKindStored.multiplier, 1.5)
        ..publicHoliday = _rate(OvertimeRateKindStored.multiplier, 2.5),
    );
    await db.setActiveCompany(company);

    // ساعتان إضافيتان في يوم عمل عادي: 2 × 10 × 1.5 = 30
    await attendance.addManualRecord(
      date: DateTime(2026, 10, 5),
      checkIn: DateTime(2026, 10, 5, 8),
      checkOut: DateTime(2026, 10, 5, 18),
    );

    // ساعتان في يوم عطلة رسمية: 2 × 10 × 2.5 = 50
    await calendar.mark(
        date: DateTime(2026, 10, 6),
        kind: CalendarDayKindEntity.publicHoliday);
    await attendance.addManualRecord(
      date: DateTime(2026, 10, 6),
      checkIn: DateTime(2026, 10, 6, 8),
      checkOut: DateTime(2026, 10, 6, 10),
    );

    final records = await attendance.getRecordsForCompany(company, from, to);
    final normal =
        records.firstWhere((r) => r.date.day == 5);
    final holiday =
        records.firstWhere((r) => r.date.day == 6);

    expect(normal.overtimeValue, closeTo(30, 0.001));
    expect(holiday.overtimeValue, closeTo(50, 0.001),
        reason: 'دُفعت العطلة بمعدّل يوم العمل');
  });

  test('المبلغ المقطوع لليوم لا يتضاعف بالساعات', () async {
    final company = await db.addCompany(
      name: 'ب',
      hourlyRate: 10,
      hoursPerDay: 8,
      startTime: '08:00',
      endTime: '16:00',
      overtimePolicy: OvertimePolicy()
        ..normal = _rate(OvertimeRateKindStored.fixedPerDay, 5000),
    );
    await db.setActiveCompany(company);

    await attendance.addManualRecord(
      date: DateTime(2026, 10, 7),
      checkIn: DateTime(2026, 10, 7, 8),
      checkOut: DateTime(2026, 10, 7, 20), // أربع ساعات إضافية
    );

    final record =
        (await attendance.getRecordsForCompany(company, from, to)).single;
    expect(record.overtimeHours, 4);
    expect(record.overtimeValue, 5000);
  });

  test('جهة بلا سياسة تحسب كما كانت قبل وجودها', () async {
    final company = await db.addCompany(
        name: 'ج', hourlyRate: 10, hoursPerDay: 8,
        startTime: '08:00', endTime: '16:00');
    await db.setActiveCompany(company);

    await attendance.addManualRecord(
      date: DateTime(2026, 10, 8),
      checkIn: DateTime(2026, 10, 8, 8),
      checkOut: DateTime(2026, 10, 8, 18),
    );

    final record =
        (await attendance.getRecordsForCompany(company, from, to)).single;
    // الافتراضي في المِعمل ×1.5 → 2 × 10 × 1.5 = 30
    expect(record.overtimeValue, closeTo(30, 0.001));
  });
}
