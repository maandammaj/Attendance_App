import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/payroll_entity.dart';
import '../../domain/usecases/payroll/build_personal_payroll_usecase.dart';
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

  return ref.read(buildPersonalPayrollUseCaseProvider)(
    companies: companies,
    from: DateTime(year, month, 1),
    to: DateTime(year, month + 1, 0, 23, 59, 59),
  );
}
