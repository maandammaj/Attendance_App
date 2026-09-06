import 'package:attendance_budget_app/domain/entities/attendance_entity.dart';
import 'package:attendance_budget_app/domain/entities/company_entity.dart';
import 'package:attendance_budget_app/domain/entities/leave_entity.dart';
import 'package:attendance_budget_app/domain/entities/profile_entity.dart';
import 'package:attendance_budget_app/domain/repositories/attendance_repository.dart';
import 'package:attendance_budget_app/domain/usecases/payroll/build_personal_payroll_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

/// مستودع يعيد سجلات لكل جهة على حدة.
class _FakeRepository implements AttendanceRepository {
  _FakeRepository(this._byCompany);

  final Map<int, List<AttendanceEntity>> _byCompany;

  @override
  Future<List<AttendanceEntity>> getRecordsForCompany(
          int companyId, DateTime from, DateTime to) async =>
      _byCompany[companyId] ?? const [];

  @override
  Future<List<AttendanceEntity>> getMonthlyRecords(int y, int m) async => const [];
  @override
  Future<List<AttendanceEntity>> getRecordsBetween(DateTime f, DateTime t) async => const [];
  @override
  Future<AttendanceEntity?> getTodayRecord() async => null;
  @override
  Future<AttendanceEntity?> getAnyOpenSession() async => null;
  @override
  Future<void> checkIn(DateTime t, {bool isBiometricVerified = false, int? companyId}) async {}
  @override
  Future<void> checkOut(DateTime t, {int? companyId}) async {}
  @override
  Future<void> addManualRecord({required DateTime date, required DateTime checkIn, required DateTime checkOut, String? notes}) async {}
  @override
  Future<void> updateRecord(AttendanceEntity e) async {}
  @override
  Future<void> deleteRecord(int id) async {}
}

CompanyEntity _company({
  required int id,
  required String name,
  required double salary,
  List<SalaryAdjustmentEntity> adjustments = const [],
}) =>
    CompanyEntity(
      id: id,
      name: name,
      jobTitle: 'موظف',
      baseMonthlySalary: salary,
      hourlyRate: 100,
      overtimeRate: 1.5,
      workSchedule: const [],
      adjustments: adjustments,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

AttendanceEntity _record({
  required int day,
  required int workedMinutes,
  required int overtimeMinutes,
  double overtimeValue = 0,
  double deficitValue = 0,
}) =>
    AttendanceEntity(
      id: day,
      date: DateTime(2026, 9, day),
      sessions: [
        WorkSessionEntity(
          checkIn: DateTime(2026, 9, day, 8),
          checkOut: DateTime(2026, 9, day, 16),
        ),
      ],
      workedHours: workedMinutes ~/ 60,
      workedMinutes: workedMinutes % 60,
      requiredHours: 8,
      requiredMinutes: 0,
      overtimeHours: overtimeMinutes ~/ 60,
      overtimeMinutes: overtimeMinutes % 60,
      overtimeValue: overtimeValue,
      deficitHours: 0,
      deficitMinutes: 0,
      deficitValue: deficitValue,
      isBiometricVerified: true,
      dayType: 'regular',
    );

void main() {
  final from = DateTime(2026, 9, 1);
  final to = DateTime(2026, 9, 30);

  group('الدخل الشخصي من كل الجهات', () {
    test('المثال في المواصفة: 85,500 + 43,000 = 128,500', () async {
      final a = _company(
        id: 1,
        name: 'الجهة أ',
        salary: 80000,
        adjustments: [
          SalaryAdjustmentEntity(
              title: 'استقطاع', amount: 2000, isAddition: false),
        ],
      );
      final b = _company(id: 2, name: 'الجهة ب', salary: 40000);

      final payroll = await BuildPersonalPayrollUseCase(_FakeRepository({
        1: [_record(day: 1, workedMinutes: 480, overtimeMinutes: 60, overtimeValue: 7500)],
        2: [_record(day: 1, workedMinutes: 480, overtimeMinutes: 60, overtimeValue: 3000)],
      }))(companies: [a, b], from: from, to: to);

      final atA = payroll.workplaces.firstWhere((w) => w.company.id == 1);
      final atB = payroll.workplaces.firstWhere((w) => w.company.id == 2);

      expect(atA.basic, 80000);
      expect(atA.overtime, 7500);
      expect(atA.adjustments, -2000);
      expect(atA.net, 85500);

      expect(atB.basic, 40000);
      expect(atB.overtime, 3000);
      expect(atB.net, 43000);

      expect(payroll.totalNet, 128500);
      expect(payroll.totalBasic, 120000);
      expect(payroll.totalOvertime, 10500);
    });

    test('الترتيب تنازلي بالصافي', () async {
      final small = _company(id: 1, name: 'صغيرة', salary: 1000);
      final big = _company(id: 2, name: 'كبيرة', salary: 9000);

      final payroll = await BuildPersonalPayrollUseCase(_FakeRepository(const {}))(
          companies: [small, big], from: from, to: to);

      expect(payroll.workplaces.first.company.id, 2);
      expect(payroll.topEarner!.company.name, 'كبيرة');
    });

    test('الأعلى دخلاً قد لا يكون الأعلى عائداً للساعة', () async {
      // أ: 8000 عن 160 ساعة = 50/ساعة · ب: 4000 عن 20 ساعة = 200/ساعة
      final a = _company(id: 1, name: 'أ', salary: 8000);
      final b = _company(id: 2, name: 'ب', salary: 4000);

      final payroll = await BuildPersonalPayrollUseCase(_FakeRepository({
        1: [_record(day: 1, workedMinutes: 160 * 60, overtimeMinutes: 0)],
        2: [_record(day: 1, workedMinutes: 20 * 60, overtimeMinutes: 0)],
      }))(companies: [a, b], from: from, to: to);

      expect(payroll.topEarner!.company.id, 1);
      expect(payroll.bestHourlyReturn!.company.id, 2,
          reason: 'العائد للساعة تبع الراتب لا الساعات');
      expect(payroll.bestHourlyReturn!.netPerHour, closeTo(200, 0.001));
    });

    test('الخصم ينقص من الصافي', () async {
      final a = _company(id: 1, name: 'أ', salary: 5000);
      final payroll = await BuildPersonalPayrollUseCase(_FakeRepository({
        1: [_record(day: 1, workedMinutes: 480, overtimeMinutes: 0, deficitValue: 750)],
      }))(companies: [a], from: from, to: to);

      expect(payroll.workplaces.single.deductions, 750);
      expect(payroll.totalNet, 4250);
    });

    test('بلا جهات لا دخل ولا انهيار', () async {
      final payroll = await BuildPersonalPayrollUseCase(_FakeRepository(const {}))(
          companies: const [], from: from, to: to);
      expect(payroll.totalNet, 0);
      expect(payroll.topEarner, isNull);
      expect(payroll.bestHourlyReturn, isNull);
    });
  });

  group('ملخّص الشهر', () {
    test('الساعات والإضافي والإجازات تُجمع عبر الجهات', () async {
      final a = _company(id: 1, name: 'أ', salary: 5000);
      final b = _company(id: 2, name: 'ب', salary: 3000);

      final payroll = await BuildPersonalPayrollUseCase(_FakeRepository({
        1: [_record(day: 1, workedMinutes: 160 * 60, overtimeMinutes: 6 * 60)],
        2: [_record(day: 1, workedMinutes: 24 * 60, overtimeMinutes: 4 * 60)],
      }))(
        companies: [a, b],
        from: from,
        to: to,
        leaves: [
          LeaveEntity(
            id: 1,
            companyId: 1,
            from: DateTime(2026, 9, 10),
            to: DateTime(2026, 9, 12),
            type: LeaveTypeEntity.annual,
            createdAt: DateTime(2026),
          ),
        ],
      );

      expect(payroll.totalWorkedMinutes, 184 * 60);
      expect(payroll.totalOvertimeMinutes, 10 * 60);
      expect(payroll.totalLeaveDays, 3);
    });

    test('الإجازة تُقصّ على حدّي الفترة', () async {
      final a = _company(id: 1, name: 'أ', salary: 5000);

      // إجازة من 28 أغسطس إلى 3 سبتمبر — ثلاثة أيام منها في سبتمبر.
      final payroll = await BuildPersonalPayrollUseCase(_FakeRepository(const {}))(
        companies: [a],
        from: from,
        to: to,
        leaves: [
          LeaveEntity(
            id: 1,
            companyId: 1,
            from: DateTime(2026, 8, 28),
            to: DateTime(2026, 9, 3),
            type: LeaveTypeEntity.annual,
            createdAt: DateTime(2026),
          ),
        ],
      );

      expect(payroll.totalLeaveDays, 3);
    });

    test('إجازة جهة أخرى لا تُحسب على هذه', () async {
      final a = _company(id: 1, name: 'أ', salary: 5000);

      final payroll = await BuildPersonalPayrollUseCase(_FakeRepository(const {}))(
        companies: [a],
        from: from,
        to: to,
        leaves: [
          LeaveEntity(
            id: 1,
            companyId: 99,
            from: DateTime(2026, 9, 1),
            to: DateTime(2026, 9, 5),
            type: LeaveTypeEntity.annual,
            createdAt: DateTime(2026),
          ),
        ],
      );

      expect(payroll.workplaces.single.leaveDays, 0);
    });
  });
}
