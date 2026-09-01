import '../../repositories/attendance_repository.dart';

class CheckInUseCase {
  final AttendanceRepository repository;
  CheckInUseCase(this.repository);

  Future<void> call(
    DateTime time, {
    bool isBiometricVerified = false,
    int? companyId,
  }) {
    return repository.checkIn(
      time,
      isBiometricVerified: isBiometricVerified,
      companyId: companyId,
    );
  }
}
