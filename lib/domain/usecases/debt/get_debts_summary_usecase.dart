import '../../repositories/debt_repository.dart';

class DebtSummary {
  final double totalOwe;
  final double remainingOwe;
  final double totalPaidOwe;
  final double totalOwed;
  final double remainingOwed;
  final double netDebtPosition;

  DebtSummary({
    required this.totalOwe,
    required this.remainingOwe,
    required this.totalPaidOwe,
    required this.totalOwed,
    required this.remainingOwed,
    required this.netDebtPosition,
  });
}

class GetDebtsSummaryUseCase {
  final DebtRepository repository;
  GetDebtsSummaryUseCase(this.repository);

  Future<DebtSummary> call() async {
    final debts = await repository.getAllDebts();

    double totalOwe = 0;
    double totalOwed = 0;
    double paidOwe = 0;
    double paidOwed = 0;

    for (final debt in debts) {
      if (debt.debtType == 'owe') {
        totalOwe += debt.totalAmount;
        paidOwe += debt.paidAmount;
      } else {
        totalOwed += debt.totalAmount;
        paidOwed += debt.paidAmount;
      }
    }

    return DebtSummary(
      totalOwe: totalOwe,
      remainingOwe: totalOwe - paidOwe,
      totalPaidOwe: paidOwe,
      totalOwed: totalOwed,
      remainingOwed: totalOwed - paidOwed,
      netDebtPosition: (totalOwed - paidOwed) - (totalOwe - paidOwe),
    );
  }
}