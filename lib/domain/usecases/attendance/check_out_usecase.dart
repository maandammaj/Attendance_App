import '../../repositories/attendance_repository.dart';

class CheckOutUseCase {
  final AttendanceRepository repository;
  CheckOutUseCase(this.repository);

  Future<void> call(DateTime time, {int? companyId}) async {
    return await repository.checkOut(time, companyId: companyId);
  }
}