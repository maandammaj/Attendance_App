import '../entities/leave_entity.dart';

abstract class LeaveRepository {
  /// إجازات الجهة الفعّالة المتقاطعة مع مدى.
  Future<List<LeaveEntity>> getBetween(DateTime from, DateTime to);

  /// أرصدة الجهة الفعّالة لسنة، بعد خصم المستهلك.
  Future<List<LeaveBalanceEntity>> getBalances(int year);

  Future<void> add({
    required DateTime from,
    required DateTime to,
    required LeaveTypeEntity type,
    String? note,
  });

  Future<void> delete(int id);
}
