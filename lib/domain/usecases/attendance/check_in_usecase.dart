import '../../repositories/attendance_repository.dart';

class CheckInUseCase {
  final AttendanceRepository repository;
  CheckInUseCase(this.repository);

  Future<void> call(DateTime time) async {
    return await repository.checkIn(time);
  }
}