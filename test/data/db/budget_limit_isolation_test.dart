import 'package:attendance_budget_app/data/local/repositories/budget_limit_repository_impl.dart';
import 'package:attendance_budget_app/data/models/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_database.dart';

void main() {
  late TestDatabase db;
  late BudgetLimitRepositoryImpl repository;

  setUp(() async {
    db = await TestDatabase.open();
    repository = BudgetLimitRepositoryImpl();
  });

  tearDown(() async => db.close());

  Future<void> addExpense({
    required int companyId,
    required double amount,
    required String category,
  }) async {
    await db.isar.writeTxn(() async {
      await db.isar.transactionModels.put(TransactionModel()
        ..companyId = companyId
        ..amount = amount
        ..date = DateTime(2026, 4, 10)
        ..categoryName = category
        ..categoryId = 1
        ..type = TransactionType.expense);
    });
  }

  test('سقف الجهة يُقاس بمصروفاتها وحدها', () async {
    final a = await db.addCompany(name: 'أ', hourlyRate: 10, hoursPerDay: 8);
    final b = await db.addCompany(name: 'ب', hourlyRate: 10, hoursPerDay: 8);

    await db.setActiveCompany(a);
    await repository.upsert(categoryName: 'مواصلات', monthlyLimit: 1000);
    await addExpense(companyId: a, amount: 200, category: 'مواصلات');

    // إنفاق ضخم في جهة أخرى على التصنيف نفسه — يجب ألا يُحتسب هنا.
    await addExpense(companyId: b, amount: 5000, category: 'مواصلات');

    final status = await repository.getStatus(2026, 4);
    expect(status, hasLength(1));
    expect(status.single.spent, 200,
        reason: 'سُحبت مصروفات جهة أخرى إلى سقف هذه الجهة');
    expect(status.single.ratio, closeTo(0.2, 0.001));
  });

  test('سقوف جهة لا تظهر في جهة أخرى', () async {
    final a = await db.addCompany(name: 'أ', hourlyRate: 10, hoursPerDay: 8);
    final b = await db.addCompany(name: 'ب', hourlyRate: 10, hoursPerDay: 8);

    await db.setActiveCompany(a);
    await repository.upsert(categoryName: 'مواصلات', monthlyLimit: 1000);

    await db.setActiveCompany(b);
    expect(await repository.getAll(), isEmpty);
    expect(await repository.getStatus(2026, 4), isEmpty);
  });
}
