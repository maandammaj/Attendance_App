import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/attendance_entity.dart';

class AttendanceTimeline extends StatelessWidget {
  final List<AttendanceEntity> records;

  const AttendanceTimeline({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: records.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return AttendanceTimelineItem(
          record: records[index],
          isFirst: index == 0,
          isLast: index == records.length - 1,
        );
      },
    );
  }
}

class AttendanceTimelineItem extends StatelessWidget {
  final AttendanceEntity record;
  final bool isFirst;
  final bool isLast;

  const AttendanceTimelineItem({
    super.key,
    required this.record,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPresent = record.checkIn != null;

    final String checkInTime = record.checkIn != null
        ? DateFormat('hh:mm a', 'ar').format(record.checkIn!)
        : '--:--';

    final String checkOutTime = record.checkOut != null
        ? DateFormat('hh:mm a', 'ar').format(record.checkOut!)
        : '--:--';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('dd').format(record.date),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('EEE', 'ar').format(record.date),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Container(
                  width: 2,
                  color: isFirst ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isPresent ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: (isPresent ? Colors.green : Colors.red).withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: isLast ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
            ],
          ),
          Expanded(
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 0,
              color: isPresent ? Colors.green.shade50 : Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isPresent ? Colors.green.shade200 : Colors.red.shade200,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              isPresent ? 'حاضر' : 'غائب',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isPresent ? Colors.green.shade800 : Colors.red.shade800,
                              ),
                            ),
                            if (record.isBiometricVerified) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.fingerprint, size: 16, color: Colors.blue),
                            ],
                          ],
                        ),
                        if (isPresent)
                          Text(
                            '$checkInTime - $checkOutTime',
                            style: const TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                      ],
                    ),
                    if (isPresent && (record.workedHours > 0 || record.workedMinutes > 0)) ...[
                      const SizedBox(height: 4),
                      Text(
                        'ساعات العمل: ${record.workedHours} س و ${record.workedMinutes} د',
                        style: const TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ],
                    if (record.notes != null && record.notes!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        record.notes!,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}