class AttendanceEntity {
  final int id;
  final DateTime date;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int workedHours;
  final int workedMinutes;
  final int requiredHours;
  final int requiredMinutes;
  final int overtimeHours;
  final int overtimeMinutes;
  final double overtimeValue;
  final int deficitHours;
  final int deficitMinutes;
  final double deficitValue;
  final String? notes;
  final bool isBiometricVerified;
  final String dayType;
  final bool isAbsent;

  AttendanceEntity({
    required this.id,
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.workedHours,
    required this.workedMinutes,
    required this.requiredHours,
    required this.requiredMinutes,
    required this.overtimeHours,
    required this.overtimeMinutes,
    required this.overtimeValue,
    required this.deficitHours,
    required this.deficitMinutes,
    required this.deficitValue,
    this.notes,
    required this.isBiometricVerified,
    required this.dayType,
    this.isAbsent = false,
  });
}
