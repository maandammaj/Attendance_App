class WorkSessionEntity {
  final DateTime? checkIn;
  final DateTime? checkOut;
  final bool isBiometricVerified;
  final String? note;

  const WorkSessionEntity({
    this.checkIn,
    this.checkOut,
    this.isBiometricVerified = false,
    this.note,
  });

  bool get isOpen => checkIn != null && checkOut == null;

  /// مدة الجلسة، أو المدة حتى [now] إن كانت ما تزال مفتوحة.
  int minutesUntil(DateTime now) {
    if (checkIn == null) return 0;
    final end = checkOut ?? now;
    final minutes = end.difference(checkIn!).inMinutes;
    return minutes < 0 ? 0 : minutes;
  }

  WorkSessionEntity copyWith({
    DateTime? checkIn,
    DateTime? checkOut,
    bool? isBiometricVerified,
    String? note,
  }) {
    return WorkSessionEntity(
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      isBiometricVerified: isBiometricVerified ?? this.isBiometricVerified,
      note: note ?? this.note,
    );
  }
}

class AttendanceEntity {
  final int id;

  /// الجهة التي يخص هذا السجل دوامها.
  final int companyId;
  final DateTime date;

  /// كل فترات التواجد في اليوم بالترتيب الزمني.
  final List<WorkSessionEntity> sessions;

  /// أول دخول وآخر خروج — مشتقّان من [sessions].
  final DateTime? checkIn;
  final DateTime? checkOut;

  final bool isOpen;
  final int totalPresenceMinutes;
  final int sessionCount;

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

  const AttendanceEntity({
    required this.id,
    this.companyId = 0,
    required this.date,
    this.sessions = const [],
    this.checkIn,
    this.checkOut,
    this.isOpen = false,
    this.totalPresenceMinutes = 0,
    this.sessionCount = 0,
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

  /// الجلسة المفتوحة حالياً، إن وجدت.
  WorkSessionEntity? get openSession {
    if (!isOpen || sessions.isEmpty) return null;
    final last = sessions.last;
    return last.isOpen ? last : null;
  }

  int get requiredMinutesTotal => (requiredHours * 60) + requiredMinutes;

  /// دقائق التواجد شاملةً الجلسة المفتوحة حتى [now].
  int presenceMinutesAt(DateTime now) {
    var total = 0;
    for (final session in sessions) {
      total += session.minutesUntil(now);
    }
    return total;
  }
}
