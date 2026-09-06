import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/leave_entity.dart';
import '../../domain/entities/payroll_entity.dart';
import '../../domain/entities/personal_insight_entity.dart';
import '../../domain/usecases/payroll/build_personal_payroll_usecase.dart';
import '../../domain/usecases/reports/build_personal_insights_usecase.dart';
import 'attendance_provider.dart';
import 'company_provider.dart';

part 'payroll_provider.g.dart';

final buildPersonalPayrollUseCaseProvider = Provider(
  (ref) => BuildPersonalPayrollUseCase(ref.read(attendanceRepositoryProvider)),
);

/// دخل المستخدم من كل جهاته في شهر.
///
/// المزوّد الوحيد الذي يقرأ الجهات كلها عمداً — بقية القراءات مُرشَّحة بجهة
/// واحدة، وهذه تجيب سؤالاً لا معنى له داخل جهة: «كم دخلي هذا الشهر».
@riverpod
Future<PersonalPayroll> personalPayroll(
  Ref ref, {
  required int year,
  required int month,
}) async {
  final companies = (await ref.watch(companiesProvider.future))
      .where((company) => !company.isArchived)
      .toList();

  // الإجازات تُقرأ للجهات كلها لا للفعّالة وحدها: هذه الشاشة تعبر الجهات.
  final leaveRepository = ref.read(leaveRepositoryProvider);
  final leaves = <LeaveEntity>[];
  for (final company in companies) {
    leaves.addAll(await leaveRepository.getBetweenForCompany(
      company.id,
      DateTime(year, month, 1),
      DateTime(year, month + 1, 0),
    ));
  }

  return ref.read(buildPersonalPayrollUseCaseProvider)(
    companies: companies,
    from: DateTime(year, month, 1),
    to: DateTime(year, month + 1, 0, 23, 59, 59),
    leaves: leaves,
  );
}

final buildPersonalInsightsUseCaseProvider =
    Provider((ref) => const BuildPersonalInsightsUseCase());

/// رؤى شخصية عن الشهر مقارنةً بما قبله.
@riverpod
Future<List<PersonalInsight>> personalInsights(
  Ref ref, {
  required int year,
  required int month,
}) async {
  final current =
      await ref.watch(personalPayrollProvider(year: year, month: month).future);

  // الشهر السابق بحدوده الصحيحة: يناير يسبقه ديسمبر من السنة الماضية.
  final previousMonth = DateTime(year, month - 1);
  final previous = await ref.watch(personalPayrollProvider(
    year: previousMonth.year,
    month: previousMonth.month,
  ).future);

  final balances =
      await ref.watch(leaveBalancesProvider(year: year).future);

  return ref.read(buildPersonalInsightsUseCaseProvider)(
    current: current,
    previous: previous,
    leaveBalances: balances,
  );
}
