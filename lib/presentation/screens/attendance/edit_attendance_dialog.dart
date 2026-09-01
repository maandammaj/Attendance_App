import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../providers/attendance_provider.dart';

class EditAttendanceDialog extends StatefulWidget {
  final AttendanceEntity record;

  const EditAttendanceDialog({super.key, required this.record});

  @override
  State<EditAttendanceDialog> createState() => _EditAttendanceDialogState();
}

class _EditAttendanceDialogState extends State<EditAttendanceDialog> {
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late TextEditingController _notesController;
  late bool _isAbsent;

  @override
  void initState() {
    super.initState();
    _startTime = widget.record.checkIn != null
        ? TimeOfDay.fromDateTime(widget.record.checkIn!)
        : const TimeOfDay(hour: 8, minute: 0);
    _endTime = widget.record.checkOut != null
        ? TimeOfDay.fromDateTime(widget.record.checkOut!)
        : const TimeOfDay(hour: 16, minute: 0);
    _notesController = TextEditingController(text: widget.record.notes);
    _isAbsent = widget.record.isAbsent;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تعديل سجل الحضور'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('حالة غياب'),
              value: _isAbsent,
              onChanged: (v) => setState(() => _isAbsent = v),
            ),
            if (!_isAbsent) ...[
              ListTile(
                title: const Text('وقت الحضور'),
                subtitle: Text(_startTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _startTime,
                  );
                  if (picked != null) setState(() => _startTime = picked);
                },
              ),
              ListTile(
                title: const Text('وقت الانصراف'),
                subtitle: Text(_endTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _endTime,
                  );
                  if (picked != null) setState(() => _endTime = picked);
                },
              ),
            ],
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'ملاحظات'),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('حذف السجل'),
                content: const Text('هل أنت متأكد من حذف هذا السجل نهائياً؟'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('إلغاء')),
                  TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('حذف', style: TextStyle(color: Colors.red))),
                ],
              ),
            );
            if (confirm == true) {
              // ignore: use_build_context_synchronously
              final ref = ProviderScope.containerOf(context);
              await ref.read(attendanceControllerProvider.notifier).deleteRecord(widget.record.id);
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            }
          },
          child: const Text('حذف', style: TextStyle(color: Colors.red)),
        ),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        Consumer(
          builder: (context, ref, _) => ElevatedButton(
            onPressed: () async {
              final checkIn = DateTime(
                  widget.record.date.year,
                  widget.record.date.month,
                  widget.record.date.day,
                  _startTime.hour,
                  _startTime.minute);
              DateTime checkOut = DateTime(
                  widget.record.date.year,
                  widget.record.date.month,
                  widget.record.date.day,
                  _endTime.hour,
                  _endTime.minute);

              if (checkOut.isBefore(checkIn)) {
                checkOut = checkOut.add(const Duration(days: 1));
              }

              final updated = AttendanceEntity(
                id: widget.record.id,
                date: widget.record.date,
                checkIn: _isAbsent ? null : checkIn,
                checkOut: _isAbsent ? null : checkOut,
                notes: _notesController.text,
                isAbsent: _isAbsent,
                workedHours: widget.record.workedHours, // Will be recalculated by repo if we implement update logic there
                workedMinutes: widget.record.workedMinutes,
                requiredHours: widget.record.requiredHours,
                requiredMinutes: widget.record.requiredMinutes,
                overtimeHours: widget.record.overtimeHours,
                overtimeMinutes: widget.record.overtimeMinutes,
                overtimeValue: widget.record.overtimeValue,
                deficitHours: widget.record.deficitHours,
                deficitMinutes: widget.record.deficitMinutes,
                deficitValue: widget.record.deficitValue,
                isBiometricVerified: widget.record.isBiometricVerified,
                dayType: widget.record.dayType,
              );

              await ref.read(attendanceControllerProvider.notifier).updateRecord(updated);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('حفظ التعديلات'),
          ),
        ),
      ],
    );
  }
}
