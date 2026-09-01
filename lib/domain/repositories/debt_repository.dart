import '../entities/debt_entity.dart';

abstract class DebtRepository {
  Future<List<DebtEntity>> getAllDebts();
  Future<List<DebtEntity>> getDebtsByType(String type);
  Future<void> addDebt(DebtEntity debt);
  Future<void> updateDebt(DebtEntity debt);
  Future<void> addPayment(int debtId, double amount, String? note);
  Future<void> deleteDebt(int id);
}