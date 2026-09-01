import 'package:flutter/material.dart';

/// يعرض وقتاً بصيغة "HH:mm" ويفتح `showTimePicker` لتعديله.
class ReminderTimeTile extends StatelessWidget {
  const ReminderTimeTile({
    super.key,
    required this.title,
    required this.time,
    required this.onChanged,
  });

  final String title;

  /// بصيغة "HH:mm" — نفس الصيغة المخزنة في الإعدادات وجدول الدوام.
  final String time;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsetsDirectional.only(start: 12),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      trailing: TextButton.icon(
        icon: const Icon(Icons.schedule_rounded, size: 18),
        label: Text(time),
        onPressed: () async {
          final parts = time.split(':');
          final picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
              hour: int.tryParse(parts.first) ?? 0,
              minute: int.tryParse(parts.last) ?? 0,
            ),
          );
          if (picked == null) return;
          final hour = picked.hour.toString().padLeft(2, '0');
          final minute = picked.minute.toString().padLeft(2, '0');
          onChanged('$hour:$minute');
        },
      ),
    );
  }
}
