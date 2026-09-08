import 'package:isar_community/isar.dart';

part 'calendar_day_model.g.dart';

/// يوم مُعلَّم في تقويم العمل.
///
/// [companyId] فارغاً يعني «كل الجهات» — عيد وطني يُعلَّم مرّة لا مرّة لكل
/// جهة. وإدخالٌ يخصّ جهة بعينها يغلب العام في اليوم نفسه، فيمكن أن يكون
/// السادس والعشرون من سبتمبر عطلةً في مستشفى ودواماً عادياً في عملٍ حر.
@collection
class CalendarDayModel {
  Id id = Isar.autoIncrement;

  /// الجهة التي يخصّها هذا اليوم، أو null إن كان يسري على كلها.
  @Index()
  int? companyId;

  /// بداية اليوم. تُخزَّن منزوعة الوقت ليقارَن بها مباشرة.
  @Index()
  late DateTime date;

  @enumerated
  late CalendarDayKind kind;

  String? note;

  late DateTime createdAt;
}

enum CalendarDayKind {
  /// عطلة رسمية.
  publicHoliday,

  /// عطلة تخصّ جهة العمل وحدها.
  workplaceHoliday,

  /// يوم عمل استثنائي في يوم راحة.
  specialWorkday,
}
