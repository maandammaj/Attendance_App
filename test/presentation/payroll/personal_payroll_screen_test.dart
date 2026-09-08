import 'package:attendance_budget_app/app.dart';
import 'package:attendance_budget_app/core/constants/theme.dart';
import 'package:attendance_budget_app/domain/entities/company_entity.dart';
import 'package:attendance_budget_app/domain/entities/payroll_entity.dart';
import 'package:attendance_budget_app/domain/entities/personal_insight_entity.dart';
import 'package:attendance_budget_app/presentation/providers/payroll_provider.dart';
import 'package:attendance_budget_app/presentation/screens/payroll/personal_payroll_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

CompanyEntity _company(int id, String name) => CompanyEntity(
      id: id,
      name: name,
      jobTitle: 'موظف',
      baseMonthlySalary: 3000,
      hourlyRate: 10,
      overtimeRate: 1.5,
      workSchedule: const [],
      adjustments: const [],
      currency: 'YER',
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

WorkplacePayroll _wp(int id, String name, {double overtime = 0}) =>
    WorkplacePayroll(
      company: _company(id, name),
      basic: 3000,
      overtime: overtime,
      deductions: 0,
      adjustments: 0,
      workedMinutes: 0,
      overtimeMinutes: 0,
      attendedDays: 0,
    );

Widget _harness(List<WorkplacePayroll> workplaces) {
  final now = DateTime.now();
  final payroll = PersonalPayroll(
    from: DateTime(now.year, now.month, 1),
    to: DateTime(now.year, now.month + 1, 0),
    workplaces: workplaces,
  );

  return ProviderScope(
    retry: noAutoRetry,
    overrides: [
      personalPayrollProvider(year: now.year, month: now.month)
          .overrideWith((ref) async => payroll),
      personalInsightsProvider(year: now.year, month: now.month)
          .overrideWith((ref) async => const <PersonalInsight>[]),
    ],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('ar'),
      home: const PersonalPayrollScreen(),
    ),
  );
}

void main() {
  testWidgets('بجهة واحدة لا يُسمّى الرقم إجمالياً ولا يُكرَّر تفصيله',
      (tester) async {
    await tester.pumpWidget(_harness([_wp(1, 'الجهة أ')]));
    await tester.pumpAndSettle();

    expect(find.textContaining('إجمالي دخلك'), findsNothing,
        reason: 'إجماليُّ جهة واحدة ليس إجمالياً');
    expect(find.textContaining('دخلك في'), findsOneWidget);

    // التفصيل يعيش في بطاقة الجهة وحدها، فلا يُقرأ مرّتين.
    expect(find.text('الأساسي'), findsOneWidget);
  });

  testWidgets('بجهتين يظهر الإجمالي وتفصيله', (tester) async {
    await tester.pumpWidget(
        _harness([_wp(1, 'الجهة أ', overtime: 500), _wp(2, 'الجهة ب')]));
    await tester.pumpAndSettle();

    expect(find.textContaining('من جهتين'), findsOneWidget);
    // «الأساسي» في بطاقة الإجمالي وفي بطاقات الجهات — بعضها خارج الشاشة،
    // فالمهم أنه ظهر في الإجمالي إلى جانب جهة على الأقل.
    expect(find.text('الأساسي'), findsAtLeastNWidgets(2));
  });

  testWidgets('البنود الصفرية لا تُعرض في بطاقة الإجمالي', (tester) async {
    await tester.pumpWidget(_harness([_wp(1, 'أ'), _wp(2, 'ب')]));
    await tester.pumpAndSettle();

    // «الخصم» تسمية تخصّ بطاقة الإجمالي وحدها، فغيابها يثبت حذف البند الصفري.
    expect(find.text('الخصم'), findsNothing,
        reason: 'عُرض بند صفري يُسطّح ما يستحق الانتباه');

    // «الإضافي» يبقى مرّة واحدة: خانة الملخّص التي تعرض الساعات لا المال.
    expect(find.text('الإضافي'), findsOneWidget);
  });

  testWidgets('الرقم مقرون بشهره', (tester) async {
    await tester.pumpWidget(_harness([_wp(1, 'أ')]));
    await tester.pumpAndSettle();

    final heading = tester
        .widgetList<Text>(find.textContaining('دخلك في'))
        .first
        .data!;
    // مبلغٌ بلا فترة ليس معلومة — فاسم الشهر داخل الترويسة نفسها.
    expect(heading.split(' ').length, greaterThan(2));
  });
}
