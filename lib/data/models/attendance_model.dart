// data/models/attendance_model.dart
import 'package:isar_community/isar.dart';

part 'attendance_model.g.dart';

@collection
class AttendanceModel {
  Id id = Isar.autoIncrement;

  /// الجهة التي يخص هذا السجل دوامها.
  ///
  /// مفهرس لأن كل استعلام في التطبيق يُرشّح به بعد تعدّد الجهات.
  @Index()
  int companyId = 0;

  @Index()
  late DateTime date;

  /// كل فترات التواجد في هذا اليوم بالترتيب الزمني.
  ///
  /// يوم واحد قد يحتوي عدة جلسات (خروج للغداء، مهمة خارجية، وردية مقسّمة).
  /// آخر جلسة بلا `checkOut` تعني أن الدوام مفتوح الآن.
  List<WorkSession> sessions = [];

  /// هل آخر جلسة ما تزال مفتوحة؟ حقل مفهرس لأن Isar لا يستعلم داخل
  /// القوائم المضمّنة، والبحث عن السجل المفتوح يتم عند كل فتح للتطبيق.
  @Index()
  bool isOpen = false;

  /// أول دخول وآخر خروج في اليوم — مشتقّان من [sessions] عند كل كتابة،
  /// ويُبقيان التقارير والاستعلامات القديمة تعمل دون المرور على القائمة.
  DateTime? checkIn;
  DateTime? checkOut;

  /// إجمالي دقائق التواجد الفعلي عبر كل الجلسات.
  int totalPresenceMinutes = 0;

  /// عدد الجلسات المكتملة — يظهر في التقارير كمؤشر على تقطّع اليوم.
  int sessionCount = 0;

  late int workedHours;
  late int workedMinutes;

  late int requiredHours;
  late int requiredMinutes;

  late int overtimeHours;
  late int overtimeMinutes;
  late double overtimeValue;

  late int deficitHours;
  late int deficitMinutes;
  late double deficitValue;

  String? notes;

  /// هل تحقّقت كل الجلسات بالبصمة؟ يكفي فشل واحدة لتصبح false.
  late bool isBiometricVerified;

  @enumerated
  late DayType dayType;

  bool isAbsent = false;
}

/// فترة تواجد واحدة داخل يوم.
@embedded
class WorkSession {
  DateTime? checkIn;
  DateTime? checkOut;

  /// هل تم التحقق بالبصمة عند بدء هذه الجلسة تحديداً؟
  bool isBiometricVerified = false;

  String? note;
}

enum DayType {
  regular,
  thursday,
  friday,
  holiday,
  custom,
}
