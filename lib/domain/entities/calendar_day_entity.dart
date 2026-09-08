/// نوع اليوم المُعلَّم في التقويم.
enum CalendarDayKindEntity {
  publicHoliday,
  workplaceHoliday,
  specialWorkday;

  /// هل يُعطّل هذا النوع الدوام.
  bool get isOff =>
      this == CalendarDayKindEntity.publicHoliday ||
      this == CalendarDayKindEntity.workplaceHoliday;

  String get label => switch (this) {
        CalendarDayKindEntity.publicHoliday => 'عطلة رسمية',
        CalendarDayKindEntity.workplaceHoliday => 'عطلة جهة العمل',
        CalendarDayKindEntity.specialWorkday => 'دوام استثنائي',
      };
}

/// يوم مُعلَّم في تقويم العمل.
class CalendarDayEntity {
  const CalendarDayEntity({
    required this.id,
    required this.companyId,
    required this.date,
    required this.kind,
    this.note,
    required this.createdAt,
  });

  final int id;

  /// null يعني أن اليوم يسري على كل الجهات.
  final int? companyId;

  final DateTime date;
  final CalendarDayKindEntity kind;
  final String? note;
  final DateTime createdAt;

  /// إدخال يخصّ جهة بعينها أَولى من إدخال عام لليوم نفسه.
  bool get isWorkplaceSpecific => companyId != null;
}
