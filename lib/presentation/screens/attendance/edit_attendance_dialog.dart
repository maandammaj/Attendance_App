import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../providers/attendance_provider.dart';

/// تحرير يوم كامل: إضافة وحذف وتعديل جلساته، أو إعلانه غياباً.
class EditAttendanceDialog extends ConsumerStatefulWidget {
  const EditAttendanceDialog({super.key, required this.record});

  final AttendanceEntity record;

  @override
  ConsumerState<EditAttendanceDialog> createState() =>
      _EditAttendanceDialogState();
}

class _EditAttendanceDialogState extends ConsumerState<EditAttendanceDialog> {
  late List<WorkSessionEntity> _sessions;
  late TextEditingController _notes;
  late bool _isAbsent;

  @override
  void initState() {
    super.initState();
    _sessions = [...widget.record.sessions];
    _notes = TextEditingController(text: widget.record.notes);
    _isAbsent = widget.record.isAbsent;
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  DateTime _at(TimeOfDay time) {
    final date = widget.record.date;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<TimeOfDay?> _pick(TimeOfDay initial) =>
      showTimePicker(context: context, initialTime: initial);

  Future<void> _addSession() async {
    final start = await _pick(const TimeOfDay(hour: 8, minute: 0));
    if (start == null || !mounted) return;
    final end = await _pick(TimeOfDay(hour: (start.hour + 8) % 24, minute: start.minute));
    if (end == null) return;

    setState(() {
      _sessions = [
        ..._sessions,
        WorkSessionEntity(checkIn: _at(start), checkOut: _at(end)),
      ]..sort((a, b) => (a.checkIn ?? widget.record.date)
          .compareTo(b.checkIn ?? widget.record.date));
    });
  }

  Future<void> _editTime(int index, {required bool isStart}) async {
    final session = _sessions[index];
    final current = isStart ? session.checkIn : session.checkOut;
    final picked = await _pick(
      current == null
          ? const TimeOfDay(hour: 8, minute: 0)
          : TimeOfDay.fromDateTime(current),
    );
    if (picked == null) return;

    setState(() {
      _sessions[index] = isStart
          ? session.copyWith(checkIn: _at(picked))
          : session.copyWith(checkOut: _at(picked));
    });
  }

  String? _validate() {
    if (_isAbsent) return null;
    for (final session in _sessions) {
      if (session.checkIn == null) return 'كل جلسة تحتاج وقت حضور';
      if (session.checkOut != null &&
          session.checkOut!.isBefore(session.checkIn!)) {
        return 'وقت الانصراف قبل وقت الحضور في إحدى الجلسات';
      }
    }
    for (int i = 1; i < _sessions.length; i++) {
      final previousEnd = _sessions[i - 1].checkOut;
      final currentStart = _sessions[i].checkIn;
      if (previousEnd != null &&
          currentStart != null &&
          currentStart.isBefore(previousEnd)) {
        return 'الجلسات متداخلة زمنياً';
      }
    }
    return null;
  }

  Future<void> _save() async {
    final error = _validate();
    if (error != null) {
      UIHelpers.showErrorSnackBar(context, error);
      return;
    }

    await ref.read(attendanceControllerProvider.notifier).updateRecord(
          AttendanceEntity(
            id: widget.record.id,
            date: widget.record.date,
            sessions: _isAbsent ? const [] : _sessions,
            isAbsent: _isAbsent,
            notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
            workedHours: widget.record.workedHours,
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
          ),
        );

    if (!mounted) return;
    Navigator.pop(context);
    UIHelpers.showSuccessSnackBar(context, 'حُدّث السجل وأُعيد حساب اليوم');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSaving = ref.watch(attendanceControllerProvider) is AsyncLoading;

    return AlertDialog(
      title: Text(DateHelpers.formatShortDate(widget.record.date)),
      contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 0),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('يوم غياب'),
                subtitle: Text('يحذف كل الجلسات ويحتسب العجز كاملاً',
                    style: theme.textTheme.labelSmall),
                value: _isAbsent,
                onChanged: (value) => setState(() => _isAbsent = value),
              ),
              AnimatedCrossFade(
                duration: AppDurations.medium,
                crossFadeState: _isAbsent
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    for (int i = 0; i < _sessions.length; i++)
                      _SessionEditor(
                        index: i,
                        session: _sessions[i],
                        onEditStart: () => _editTime(i, isStart: true),
                        onEditEnd: () => _editTime(i, isStart: false),
                        onDelete: () =>
                            setState(() => _sessions.removeAt(i)),
                      ),
                    if (_sessions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text('لا جلسات — أضف واحدة',
                            style: theme.textTheme.bodySmall),
                      ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton.icon(
                        onPressed: _addSession,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('إضافة جلسة'),
                      ),
                    ),
                  ],
                ),
                secondChild: const SizedBox(width: double.infinity),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notes,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'ملاحظات'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: isSaving ? null : _save,
          child: Text(isSaving ? 'جارٍ الحفظ…' : 'حفظ'),
        ),
      ],
    );
  }
}

class _SessionEditor extends StatelessWidget {
  const _SessionEditor({
    required this.index,
    required this.session,
    required this.onEditStart,
    required this.onEditEnd,
    required this.onDelete,
  });

  final int index;
  final WorkSessionEntity session;
  final VoidCallback onEditStart;
  final VoidCallback onEditEnd;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 8),
      child: Row(
        children: [
          Text('${index + 1}', style: theme.textTheme.labelSmall),
          const SizedBox(width: 10),
          Expanded(
            child: _TimeChip(
              label: 'حضور',
              time: session.checkIn,
              onTap: onEditStart,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _TimeChip(
              label: 'انصراف',
              time: session.checkOut,
              onTap: onEditEnd,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
            tooltip: 'حذف الجلسة',
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.label,
    required this.time,
    required this.onTap,
  });

  final String label;
  final DateTime? time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.field),
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 8, 10, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.field),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelSmall),
            Text(
              time == null ? '—' : DateHelpers.formatTime(time!),
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
