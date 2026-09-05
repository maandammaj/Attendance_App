import 'package:attendance_budget_app/domain/entities/company_entity.dart';
import 'package:attendance_budget_app/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';

CompanyEntity _company(List<WorkDayConfigEntity> schedule) => CompanyEntity(
      id: 1,
      name: 'جهة',
      jobTitle: 'موظف',
      baseMonthlySalary: 3000,
      hourlyRate: 20,
      overtimeRate: 1.5,
      workSchedule: schedule,
      adjustments: const [],
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

WorkDayConfigEntity _day(int dayOfWeek, int hours,
        {bool isWorkingDay = true, bool isHoliday = false}) =>
    WorkDayConfigEntity(
      dayOfWeek: dayOfWeek,
      isWorkingDay: isWorkingDay,
      requiredHours: hours,
      requiredMinutes: 0,
      isHoliday: isHoliday,
    );

void main() {
  group('اختيار إعداد اليوم من الجدول', () {
    test('الأحد يُطابق إعداده ولا يسقط على الافتراضي', () {
      // 2026-09-06 أحد. `weekday % 7` يعطي 0 ولا يطابق أي إعداد مخزَّن،
      // فيسقط اليوم على افتراضي ثماني ساعات ويفسد عجزه وإضافيه.
      final company = _company([
        _day(DateTime.sunday, 5),
        _day(DateTime.monday, 8),
      ]);

      final config = company.configFor(DateTime(2026, 9, 6));
      expect(config.dayOfWeek, DateTime.sunday);
      expect(config.requiredHours, 5, reason: 'سقط الأحد على الافتراضي');
    });

    test('كل أيام الأسبوع تُطابق إعداداتها', () {
      final company = _company([
        for (var day = 1; day <= 7; day++) _day(day, day),
      ]);

      // 2026-09-07 اثنين، فسبعة أيام متتالية تغطّي الأسبوع كاملاً.
      for (var offset = 0; offset < 7; offset++) {
        final date = DateTime(2026, 9, 7).add(Duration(days: offset));
        expect(company.configFor(date).requiredHours, date.weekday,
            reason: 'اليوم ${date.weekday} أخذ إعداد يوم آخر');
      }
    });

    test('يوم بلا إعداد يأخذ الافتراضي المعلن', () {
      final config = _company([_day(DateTime.monday, 8)])
          .configFor(DateTime(2026, 9, 5));
      expect(config.requiredHours, 8);
      expect(config.isWorkingDay, isTrue);
    });

    test('العطلة تُقرأ كما خُزّنت', () {
      final config = _company([
        _day(DateTime.friday, 0, isWorkingDay: false, isHoliday: true),
      ]).configFor(DateTime(2026, 9, 4));
      expect(config.isHoliday, isTrue);
      expect(config.requiredMinutesTotal, 0);
    });
  });
}
