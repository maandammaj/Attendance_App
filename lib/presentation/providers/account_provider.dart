import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/repositories/account_repository_impl.dart';
import '../../domain/entities/account_entity.dart';

part 'account_provider.g.dart';

final accountRepositoryProvider = Provider((ref) => AccountRepositoryImpl());

@riverpod
Future<List<AccountEntity>> allAccounts(Ref ref) async {
  final repo = ref.read(accountRepositoryProvider);
  return await repo.getAllAccounts();
}

@riverpod
class AccountController extends _$AccountController {
  @override
  FutureOr<void> build() => null;

  Future<void> saveAccount(AccountEntity account) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(accountRepositoryProvider);
      await repo.saveAccount(account);
      ref.invalidate(allAccountsProvider);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> updateAccount(AccountEntity account) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(accountRepositoryProvider);
      await repo.saveAccount(account); // uses same saveAccount which handles update via id
      ref.invalidate(allAccountsProvider);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }

  Future<void> deleteAccount(int id) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(accountRepositoryProvider);
      await repo.deleteAccount(id);
      ref.invalidate(allAccountsProvider);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
