import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../domain/entities/profile_entity.dart';

/// بطاقة يوم واحد: تفعيل، ساعات مطلوبة، ونافذة وردية اختيارية.
///
/// تنطوي عند تعطيل اليوم حتى لا يزدحم الجدول بحقول لا معنى لها.
class ScheduleDayTile extends StatelessWidget {
  const ScheduleDayTile({
    super.key,
    required this.config,
    required this.onChanged,
  });

  final WorkDayConfigEntity config;
  final ValueChanged<WorkDayConfigEntity> onChanged;

  bool get _isActive => config.isWorkingDay && !config.isHoliday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = DateHelpers.arabicDayNameOfScheduleDay(config.dayOfWeek);

    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: AppCurves.emphasized,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: _isActive
              ? theme.colorScheme.primary.withValues(alpha: 0.4)
              : theme.dividerColor,
          width: _isActive ? 1.4 : 1,
        ),
      ),
      child: Column(
        children: [
          SwitchListTile.adaptive(
            contentPadding:
                const EdgeInsetsDirectional.fromSTEB(16, 4, 8, 0),
            title: Text(name, style: theme.textTheme.titleMedium),
            subtitle: Text(
              _isActive ? _summary() : 'يوم عطلة',
              style: theme.textTheme.bodySmall?.copyWith(
                color: _isActive
                    ? theme.colorScheme.primary
                    : theme.disabledColor,
              ),
            ),
            value: _isActive,
            onChanged: (value) => onChanged(
              config.copyWith(isWorkingDay: value, isHoliday: !value),
            ),
          ),
          AnimatedCrossFade(
            duration: AppDurations.medium,
            sizeCurve: AppCurves.emphasized,
            crossFadeState: _isActive
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: _Editor(config: config, onChanged: onChanged),
            secondChild: const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  String _summary() {
    final hours = DateHelpers.formatDurationCompact(config.requiredMinutesTotal);
    if (!config.hasShiftWindow) return '$hours — بلا وردية محددة';
    return '${config.startTime} ← ${config.endTime}  •  $hours';
  }
}

class _Editor extends StatelessWidget {
  const _Editor({required this.config, required this.onChanged});

  final WorkDayConfigEntity config;
  final ValueChanged<WorkDayConfigEntity> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 20),
          Row(
            children: [
              Expanded(
                child: Text('الساعات المطلوبة',
                    style: theme.textTheme.bodyMedium),
              ),
              _Stepper(
                minutes: config.requiredMinutesTotal,
                onChanged: (minutes) => onChanged(config.copyWith(
                  requiredHours: minutes ~/ 60,
                  requiredMinutes: minutes % 60,
                )),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text('نافذة الوردية', style: theme.textTheme.bodyMedium),
              ),
              Switch.adaptive(
                value: config.hasShiftWindow,
                onChanged: (value) => onChanged(
                  value
                      ? config.copyWith(startTime: '08:00', endTime: '16:00')
                      : config.copyWith(clearWindow: true),
                ),
              ),
            ],
          ),
          if (config.hasShiftWindow) ...[
            Text(
              'خارج هذه النافذة يُحتسب الوقت إضافياً، وداخلها الغياب عجزاً.',
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.disabledColor),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _TimeField(
                    label: 'من',
                    value: config.startTime!,
                    onChanged: (value) =>
                        onChanged(config.copyWith(startTime: value)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TimeField(
                    label: 'إلى',
                    value: config.endTime!,
                    onChanged: (value) =>
                        onChanged(config.copyWith(endTime: value)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text('تمتد لليوم التالي',
                  style: theme.textTheme.bodySmall),
              value: config.isCrossDay,
              onChanged: (value) =>
                  onChanged(config.copyWith(isCrossDay: value ?? false)),
            ),
            if (config.windowMinutes != null &&
                config.windowMinutes != config.requiredMinutesTotal)
              _Mismatch(
                windowMinutes: config.windowMinutes!,
                requiredMinutes: config.requiredMinutesTotal,
                onAlign: () => onChanged(config.copyWith(
                  requiredHours: config.windowMinutes! ~/ 60,
                  requiredMinutes: config.windowMinutes! % 60,
                )),
              ),
          ],
        ],
      ),
    );
  }
}

/// تنبيه حين تختلف نافذة الوردية عن الساعات المطلوبة — الاختلاف مقصود أحياناً
/// (استراحة غير محسوبة) لكنه غالباً سهو، فنعرض إصلاحاً بنقرة.
class _Mismatch extends StatelessWidget {
  const _Mismatch({
    required this.windowMinutes,
    required this.requiredMinutes,
    required this.onAlign,
  });

  final int windowMinutes;
  final int requiredMinutes;
  final VoidCallback onAlign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    return Container(
      margin: const EdgeInsetsDirectional.only(top: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: palette.warning.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: AppIconSize.sm, color: palette.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'النافذة ${DateHelpers.formatDurationCompact(windowMinutes)} '
              'والمطلوب ${DateHelpers.formatDurationCompact(requiredMinutes)}',
              style: theme.textTheme.labelSmall,
            ),
          ),
          TextButton(onPressed: onAlign, child: const Text('توحيد')),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.minutes, required this.onChanged});

  final int minutes;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
              tooltip: 'إنقاص',
          visualDensity: VisualDensity.compact,
          onPressed: minutes >= 30 ? () => onChanged(minutes - 30) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        SizedBox(
          width: 64,
          child: Text(
            DateHelpers.formatDurationCompact(minutes),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        IconButton(
              tooltip: 'زيادة',
          visualDensity: VisualDensity.compact,
          onPressed:
              minutes <= (16 * 60) - 30 ? () => onChanged(minutes + 30) : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.field),
      onTap: () async {
        final parts = value.split(':');
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: int.tryParse(parts.first) ?? 8,
            minute: int.tryParse(parts.last) ?? 0,
          ),
        );
        if (picked == null) return;
        onChanged('${picked.hour.toString().padLeft(2, '0')}:'
            '${picked.minute.toString().padLeft(2, '0')}');
      },
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(14, 10, 14, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.field),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          children: [
            Icon(Icons.schedule_rounded,
                size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelSmall),
                Text(value, style: theme.textTheme.titleSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
