import 'package:isar_community/isar.dart';

part 'leave_model.g.dart';

/// إجازة مأخوذة في مدى من التواريخ، تخصّ جهة واحدة.
@collection
class LeaveModel {
  Id id = Isar.autoIncrement;

  /// الجهة التي أُخذت منها. لا إجازة عامة: الأرصدة مستقلّة لكل جهة.
  @Index()
  int companyId = 0;

  @Index()
  late DateTime from;

  late DateTime to;

  @enumerated
  late LeaveTypeStored type;

  String? note;

  late DateTime createdAt;
}

enum LeaveTypeStored { annual, sick, emergency, official, unpaid, other }
