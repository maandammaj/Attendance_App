import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/attendance_provider.dart';
import '../../widgets/attendance_timeline.dart';

class AttendanceHistoryScreen extends ConsumerWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();

    // تم تصحيح طريقة الاستدلال لتتوافق مع الكود المولد من Riverpod Generator
    final records = ref.watch(
      monthlyAttendanceProvider(
        year: now.year,
        month: now.month,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل الحضور'),
        centerTitle: true,
      ),
      body: records.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد سجلات حضور لهذا الشهر',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: list.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final record = list[index];
              return AttendanceTimelineItem(record: record);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('خطأ: $err')),
      ),
    );
  }
}