import 'package:isar_community/isar.dart';

part 'notification_model.g.dart';

@collection
class NotificationModel {
  Id id = Isar.autoIncrement;

  late String title;
  late String body;
  late DateTime timestamp;
  bool isRead = false;
}
