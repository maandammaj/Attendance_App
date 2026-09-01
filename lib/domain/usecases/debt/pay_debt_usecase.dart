import '../../repositories/debt_repository.dart';

class PayDebtUseCase {
  final DebtRepository repository;
  PayDebtUseCase(this.repository);

  Future<void> call(int debtId, double amount, String? note) async {
    return await repository.addPayment(debtId, amount, note);
  }
}