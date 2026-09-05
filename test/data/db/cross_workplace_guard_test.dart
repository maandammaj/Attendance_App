import 'package:attendance_budget_app/data/local/repositories/account_repository_impl.dart';
import 'package:attendance_budget_app/data/local/repositories/attendance_repository_impl.dart';
import 'package:attendance_budget_app/data/local/repositories/budget_limit_repository_impl.dart';
import 'package:attendance_budget_app/data/local/repositories/debt_repository_impl.dart';
import 'package:attendance_budget_app/data/local/repositories/transaction_repository_impl.dart';
import 'package:attendance_budget_app/domain/entities/account_entity.dart';
import 'package:attendance_budget_app/domain/entities/debt_entity.dart';
import 'package:attendance_budget_app/domain/entities/transaction_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_database.dart';

AccountEntity _account({required String name, required double balance}) =>
    AccountEntity(
      id: 0,
      name: name,
      type: AccountTypeEntity.supplier,
      totalBalance: balance,
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
    );

void main() {
  late TestDatabase db;
  late int companyA;
  late int companyB;

  setUp(() async {
    db = await TestDatabase.open();
    companyA = await db.addCompany(name: 'أ', hourlyRate: 10, hoursPerDay: 8);
    companyB = await db.addCompany(name: 'ب', hourlyRate: 10, hoursPerDay: 8);
  });

  tearDown(() async => db.close());

  group('معرّف من جهة أخرى يُرفض', () {
    test('حذف حساب جهة أخرى يفشل ولا يمسّ السجل', () async {
      final accounts = AccountRepositoryImpl();
      await db.setActiveCompany(companyA);
      await accounts.saveAccount(_account(name: 'مورّد', balance: 0));
      final created = (await accounts.getAllAccounts()).single;

      await db.setActiveCompany(companyB);
      await expectLater(
        accounts.deleteAccount(created.id),
        throwsA(isA<Exception>()),
      );

      await db.setActiveCompany(companyA);
      expect(await accounts.getAllAccounts(), hasLength(1),
          reason: 'حُذف حساب جهة أخرى');
    });

    test('حساب جهة أخرى لا يُقرأ بالمعرّف', () async {
      final accounts = AccountRepositoryImpl();
      await db.setActiveCompany(companyA);
      await accounts.saveAccount(_account(name: 'مورّد', balance: 0));
      final created = (await accounts.getAllAccounts()).single;

      await db.setActiveCompany(companyB);
      expect(await accounts.getAccountById(created.id), isNull);
    });

    test('حذف دين جهة أخرى يفشل', () async {
      final debts = DebtRepositoryImpl();
      await db.setActiveCompany(companyA);
      await debts.addDebt(DebtEntity(
        id: 0,
        debtType: 'owe',
        personName: 'خالد',
        totalAmount: 500,
        paidAmount: 0,
        remainingAmount: 500,
        status: 'active',
        createdAt: DateTime(2026, 5, 1),
        paymentHistory: const [],
      ));
      final created = (await debts.getAllDebts()).single;

      await db.setActiveCompany(companyB);
      await expectLater(
          debts.deleteDebt(created.id), throwsA(isA<Exception>()));
      await expectLater(debts.addPayment(created.id, 100, null),
          throwsA(isA<Exception>()));

      await db.setActiveCompany(companyA);
      expect((await debts.getAllDebts()).single.paidAmount, 0);
    });

    test('حذف سجل دوام جهة أخرى يفشل', () async {
      final attendance = AttendanceRepositoryImpl();
      await db.setActiveCompany(companyA);
      await attendance.checkIn(DateTime(2026, 5, 4, 8), companyId: companyA);
      await attendance.checkOut(DateTime(2026, 5, 4, 16));
      final record = (await attendance.getRecordsForCompany(
              companyA, DateTime(2026, 5, 1), DateTime(2026, 5, 31)))
          .single;

      await db.setActiveCompany(companyB);
      await expectLater(
          attendance.deleteRecord(record.id), throwsA(isA<Exception>()));

      expect(
        await attendance.getRecordsForCompany(
            companyA, DateTime(2026, 5, 1), DateTime(2026, 5, 31)),
        hasLength(1),
      );
    });

    test('حذف سقف جهة أخرى يفشل', () async {
      final limits = BudgetLimitRepositoryImpl();
      await db.setActiveCompany(companyA);
      await limits.upsert(categoryName: 'مواصلات', monthlyLimit: 500);
      final created = (await limits.getAll()).single;

      await db.setActiveCompany(companyB);
      await expectLater(limits.delete(created.id), throwsA(isA<Exception>()));

      await db.setActiveCompany(companyA);
      expect(await limits.getAll(), hasLength(1));
    });
  });

  group('حذف حركة يعكس أثرها على الحساب', () {
    test('الرصيد يعود كما كان قبل الحركة', () async {
      final accounts = AccountRepositoryImpl();
      final transactions = TransactionRepositoryImpl();
      await db.setActiveCompany(companyA);

      await accounts.saveAccount(_account(name: 'محفظة', balance: 1000));
      final account = (await accounts.getAllAccounts()).single;

      await transactions.addTransaction(TransactionEntity(
        id: 0,
        amount: 250,
        date: DateTime(2026, 5, 10),
        categoryName: 'مواصلات',
        categoryId: 1,
        accountId: account.id,
        type: TransactionTypeEntity.expense,
      ));
      expect((await accounts.getAccountById(account.id))!.totalBalance, 750);

      final created = (await transactions.getTransactionsBetween(
              DateTime(2026, 5, 1), DateTime(2026, 5, 31)))
          .single;
      await transactions.deleteTransaction(created.id);

      expect((await accounts.getAccountById(account.id))!.totalBalance, 1000,
          reason: 'بقي أثر حركة محذوفة في الرصيد');
    });
  });
}
