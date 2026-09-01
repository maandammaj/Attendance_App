import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../widgets/app_button.dart';
import '../../providers/attendance_provider.dart';

class ManualAttendanceDialog extends ConsumerStatefulWidget {
  const ManualAttendanceDialog({super.key});

  @override
  ConsumerState<ManualAttendanceDialog> createState() => _ManualAttendanceDialogState();
}

class _ManualAttendanceDialogState extends ConsumerState<ManualAttendanceDialog> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 16, minute: 0);
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceState = ref.watch(attendanceControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              ListTile(
                title: const Text('تاريخ الدوام'),
                subtitle: Text(DateFormat('EEEE, d MMMM yyyy', 'ar').format(_selectedDate)),
                leading: const Icon(Icons.calendar_month_outlined),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              const Divider(height: 1),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: const Text('وقت الحضور'),
                      subtitle: Text(_startTime.format(context)),
                      leading: const Icon(Icons.login_outlined),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _startTime,
                        );
                        if (picked != null) setState(() => _startTime = picked);
                      },
                    ),
                  ),
                  Container(width: 1, height: 40, color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
                  Expanded(
                    child: ListTile(
                      title: const Text('وقت الانصراف'),
                      subtitle: Text(_endTime.format(context)),
                      leading: const Icon(Icons.logout_outlined),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _endTime,
                        );
                        if (picked != null) setState(() => _endTime = picked);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'ملاحظات اختيارية',
            prefixIcon: Icon(Icons.note_alt_outlined),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 32),
        AppButton(
          label: 'حفظ سجل الحضور',
          icon: Icons.save_outlined,
          isLoading: attendanceState is AsyncLoading,
          onPressed: () async {
            final checkIn = DateTime(_selectedDate.year, _selectedDate.month,
                _selectedDate.day, _startTime.hour, _startTime.minute);
            DateTime checkOut = DateTime(_selectedDate.year, _selectedDate.month,
                _selectedDate.day, _endTime.hour, _endTime.minute);
            
            if (checkOut.isBefore(checkIn)) {
              checkOut = checkOut.add(const Duration(days: 1));
            }

            await ref.read(attendanceControllerProvider.notifier).addManual(
                  date: _selectedDate,
                  checkIn: checkIn,
                  checkOut: checkOut,
                  notes: _notesController.text.trim(),
                );
                
            if (mounted) {
              final state = ref.read(attendanceControllerProvider);
              if (state is! AsyncError) {
                Navigator.pop(context);
                UIHelpers.showSuccessSnackBar(context, 'تم حفظ الدوام بنجاح');
              } else {
                UIHelpers.showErrorSnackBar(context, 'فشل حفظ الدوام: ${state.error}');
              }
            }
          },
        ),
      ],
    );
  }
}
