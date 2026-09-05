import 'package:flutter/material.dart';
import '../../../core/constants/design_tokens.dart';
import 'package:isar_community/isar.dart';
import 'package:intl/intl.dart';
import '../../../data/local/database/isar_database.dart';
import '../../../data/models/notification_model.dart';
import '../../widgets/common/empty_state.dart';

class NotificationHistoryScreen extends StatelessWidget {
  const NotificationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Scaffold(
      appBar: AppBar(title: const Text('التنبيهات'), centerTitle: true),
      body: FutureBuilder<Isar>(
        future: IsarDatabase.instance,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final isar = snapshot.data!;
          return StreamBuilder(
            stream: isar.notificationModels.where().sortByTimestampDesc().watch(fireImmediately: true),
            builder: (context, streamSnapshot) {
              final list = streamSnapshot.data ?? [];
              if (list.isEmpty) {
                return const EmptyState(
                  icon: Icons.notifications_none_rounded,
                  title: 'لا تنبيهات بعد',
                  message: 'تذكيرات الحضور والانصراف والديون تُحفظ هنا بعد وصولها.',
                );
              }
              return ListView.builder(
                itemCount: list.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final notif = list[index];
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.notifications)),
                      title: Text(notif.title),
                      subtitle: Text(notif.body),
                      trailing: Text(DateFormat('HH:mm').format(notif.timestamp), 
                          style: TextStyle(fontSize: 12, color: palette.onSurfaceVariant)),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
