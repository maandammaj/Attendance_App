import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/repositories/debt_repository_impl.dart';
import '../../domain/entities/debt_entity.dart';
import '../../domain/usecases/debt/add_debt_usecase.dart';
import '../../domain/usecases/debt/get_debts_summary_usecase.dart';
import '../../domain/usecases/debt/pay_debt_usecase.dart';
import '../../domain/usecases/debt/delete_debt_usecase.dart';

part 'debt_provider.g.dart';

final debtRepositoryProvider = Provider((ref) => DebtRepositoryImpl());

final addDebtUseCaseProvider = Provider(
      (ref) => AddDebtUseCase(ref.read(debtRepositoryProvider)),
);

final payDebtUseCaseProvider = Provider(
      (ref) => PayDebtUseCase(ref.read(debtRepositoryProvider)),
);

final deleteDebtUseCaseProvider = Provider(
      (ref) => DeleteDebtUseCase(ref.read(debtRepositoryProvider)),
);

final getDebtsSummaryUseCaseProvider = Provider(
      (ref) => GetDebtsSummaryUseCase(ref.read(debtRepositoryProvider)),
);

@riverpod
Future<List<DebtEntity>> allDebts(AllDebtsRef ref) async {
  final repo = ref.read(debtRepositoryProvider);
  return await repo.getAllDebts();
}

@riverpod
Future<DebtSummary> debtSummary(DebtSummaryRef ref) async {
  final useCase = ref.read(getDebtsSummaryUseCaseProvider);
  return await useCase();
}

@riverpod
class DebtController extends _$DebtController {
  @override
  FutureOr<void> build() => null;

  Future<void> addDebt(DebtEntity debt) async {
    state = const AsyncLoading();
    try {
      final useCase = ref.read(addDebtUseCaseProvider);
      await useCase(debt);
      ref.invalidate(allDebtsProvider);
      ref.invalidate(debtSummaryProvider);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> makePayment(int debtId, double amount, String? note) async {
    state = const AsyncLoading();
    try {
      final useCase = ref.read(payDebtUseCaseProvider);
      await useCase(debtId, amount, note);
      ref.invalidate(allDebtsProvider);
      ref.invalidate(debtSummaryProvider);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> deleteDebt(int id) async {
    state = const AsyncLoading();
    try {
      final useCase = ref.read(deleteDebtUseCaseProvider);
      await useCase(id);
      ref.invalidate(allDebtsProvider);
      ref.invalidate(debtSummaryProvider);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
