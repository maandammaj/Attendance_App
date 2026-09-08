import 'package:isar_community/isar.dart';

part 'notification_model.g.dart';

@collection
class NotificationModel {
  Id id = Isar.autoIncrement;

  late String title;
  late String body;

  @Index()
  late DateTime timestamp;

  bool isRead = false;

  @enumerated
  NotificationCategory category = NotificationCategory.general;

  /// مرجع اختياري للكيان الذي أطلق التنبيه (رقم دين، فئة مصروف…).
  String? payload;

  /// يمنع تكرار نفس التنبيه في نفس اليوم — انظر `NotificationService.showNotification`.
  @Index()
  String? dedupeKey;
}

enum NotificationCategory {
  general,
  attendance,
  debt,
  finance,
  summary,
}
