import 'package:attendance_budget_app/data/local/repositories/attendance_repository_impl.dart';
import 'package:attendance_budget_app/data/local/repositories/company_repository_impl.dart';
import 'package:attendance_budget_app/data/local/repositories/leave_repository_impl.dart';
import 'package:attendance_budget_app/domain/entities/leave_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_database.dart';

void main() {
  late TestDatabase db;
  late LeaveRepositoryImpl leaves;
  late AttendanceRepositoryImpl attendance;

  setUp(() async {
    db = await TestDatabase.open();
    leaves = LeaveRepositoryImpl();
    attendance = AttendanceRepositoryImpl();
  });

  tearDown(() async => db.close());

  group('الأرصدة مستقلّة لكل جهة', () {
    test('20 يوماً في جهة و12 في أخرى لا تختلطان', () async {
      final a = await db.addCompany(
          name: 'أ', hourlyRate: 10, hoursPerDay: 8,
          annualLeaveDays: 20);
      final b = await db.addCompany(
          name: 'ب', hourlyRate: 10, hoursPerDay: 8,
          annualLeaveDays: 12);

      await db.setActiveCompany(a);
      await leaves.add(
        from: DateTime(2026, 3, 1),
        to: DateTime(2026, 3, 5),
        type: LeaveTypeEntity.annual,
      );

      final atA = (await leaves.getBalances(2026))
          .firstWhere((x) => x.type == LeaveTypeEntity.annual);
      expect(atA.allowance, 20);
      expect(atA.used, 5);
      expect(atA.remaining, 15);

      await db.setActiveCompany(b);
      final atB = (await leaves.getBalances(2026))
          .firstWhere((x) => x.type == LeaveTypeEntity.annual);
      expect(atB.allowance, 12);
      expect(atB.used, 0, reason: 'سُحبت إجازة جهة أخرى من رصيد هذه');
      expect(atB.remaining, 12);
    });

    test('إجازة تعبر رأس السنة تُقسَّم على سنتيها', () async {
      final a = await db.addCompany(
          name: 'أ', hourlyRate: 10, hoursPerDay: 8, annualLeaveDays: 30);
      await db.setActiveCompany(a);

      // 28 ديسمبر → 3 يناير: أربعة أيام في 2026 وثلاثة في 2027.
      await leaves.add(
        from: DateTime(2026, 12, 28),
        to: DateTime(2027, 1, 3),
        type: LeaveTypeEntity.annual,
      );

      expect(
          (await leaves.getBalances(2026))
              .firstWhere((x) => x.type == LeaveTypeEntity.annual)
              .used,
          4);
      expect(
          (await leaves.getBalances(2027))
              .firstWhere((x) => x.type == LeaveTypeEntity.annual)
              .used,
          3);
    });

    test('تجاوز الرصيد يُعرض ولا يُمنع', () async {
      final a = await db.addCompany(
          name: 'أ', hourlyRate: 10, hoursPerDay: 8, annualLeaveDays: 3);
      await db.setActiveCompany(a);
      await leaves.add(
        from: DateTime(2026, 3, 1),
        to: DateTime(2026, 3, 10),
        type: LeaveTypeEntity.annual,
      );

      final balance = (await leaves.getBalances(2026))
          .firstWhere((x) => x.type == LeaveTypeEntity.annual);
      expect(balance.used, 10);
      expect(balance.isOverdrawn, isTrue);
      expect(balance.remaining, -7);
    });

    test('حذف إجازة جهة أخرى يُرفض', () async {
      final a = await db.addCompany(name: 'أ', hourlyRate: 10, hoursPerDay: 8);
      final b = await db.addCompany(name: 'ب', hourlyRate: 10, hoursPerDay: 8);

      await db.setActiveCompany(a);
      await leaves.add(
        from: DateTime(2026, 4, 1),
        to: DateTime(2026, 4, 2),
        type: LeaveTypeEntity.sick,
      );
      final entry = (await leaves.getBetween(
              DateTime(2026, 4, 1), DateTime(2026, 4, 30)))
          .single;

      await db.setActiveCompany(b);
      await expectLater(leaves.delete(entry.id), throwsA(isA<Exception>()));
    });
  });

  group('أثر الإجازة على المال', () {
    test('الإجازة المدفوعة تُفرِّغ مطلوب اليوم فلا عجز', () async {
      final a = await db.addCompany(
          name: 'أ', hourlyRate: 10, hoursPerDay: 8,
          startTime: '08:00', endTime: '16:00');
      await db.setActiveCompany(a);

      await leaves.add(
        from: DateTime(2026, 5, 4),
        to: DateTime(2026, 5, 4),
        type: LeaveTypeEntity.annual,
      );

      // يوم إجازة سُجّل فيه غياب صريح: لا مطلوب فلا خصم.
      await attendance.addManualRecord(
        date: DateTime(2026, 5, 4),
        checkIn: DateTime(2026, 5, 4, 9),
        checkOut: DateTime(2026, 5, 4, 10),
      );

      final record = (await attendance.getRecordsForCompany(
              a, DateTime(2026, 5, 1), DateTime(2026, 5, 31)))
          .single;
      expect(record.requiredHours * 60 + record.requiredMinutes, 0);
      expect(record.deficitValue, 0);
      // ساعة عمل في يوم لا يُطلب فيه شيء تصير إضافياً.
      expect(record.overtimeHours, 1);
    });

    test('الإجازة بلا أجر تُبقي المطلوب فيُخصم اليوم', () async {
      final a = await db.addCompany(
          name: 'أ', hourlyRate: 10, hoursPerDay: 8,
          startTime: '08:00', endTime: '16:00');
      await db.setActiveCompany(a);

      await leaves.add(
        from: DateTime(2026, 5, 5),
        to: DateTime(2026, 5, 5),
        type: LeaveTypeEntity.unpaid,
      );

      await attendance.addManualRecord(
        date: DateTime(2026, 5, 5),
        checkIn: DateTime(2026, 5, 5, 9),
        checkOut: DateTime(2026, 5, 5, 10),
      );

      final record = (await attendance.getRecordsForCompany(
              a, DateTime(2026, 5, 1), DateTime(2026, 5, 31)))
          .single;
      expect(record.requiredHours, 8, reason: 'أُفرِّغ المطلوب في إجازة بلا أجر');
      expect(record.deficitValue, greaterThan(0));
    });
  });

  test('الرصيد المُدخَل يُحفظ ويُقرأ عبر مستودع الجهات', () async {
    final repo = CompanyRepositoryImpl();
    final id = await db.addCompany(name: 'أ', hourlyRate: 10, hoursPerDay: 8);
    await db.setActiveCompany(id);

    final company = (await repo.getById(id))!;
    await repo.update(company.copyWith(leaveAllowances: const [
      LeaveAllowanceEntity(type: LeaveTypeEntity.annual, days: 21),
      LeaveAllowanceEntity(type: LeaveTypeEntity.sick, days: 7),
    ]));

    final balances = await leaves.getBalances(2026);
    expect(
        balances.firstWhere((b) => b.type == LeaveTypeEntity.annual).allowance,
        21);
    expect(balances.firstWhere((b) => b.type == LeaveTypeEntity.sick).allowance,
        7);
  });
}
