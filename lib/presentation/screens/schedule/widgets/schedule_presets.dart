import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../../domain/entities/profile_entity.dart';

/// قالب جدول جاهز يملأ الأسبوع دفعةً واحدة.
class SchedulePreset {
  const SchedulePreset({
    required this.name,
    required this.description,
    required this.icon,
    required this.offDays,
    required this.startTime,
    required this.endTime,
    required this.requiredMinutes,
    this.isCrossDay = false,
  });

  final String name;
  final String description;
  final IconData icon;

  /// أيام العطلة بترقيم `DateTime.weekday`.
  final Set<int> offDays;

  final String startTime;
  final String endTime;
  final int requiredMinutes;
  final bool isCrossDay;

  List<WorkDayConfigEntity> build(List<int> weekOrder) {
    return [
      for (final day in weekOrder)
        WorkDayConfigEntity(
          dayOfWeek: day,
          isWorkingDay: !offDays.contains(day),
          isHoliday: offDays.contains(day),
          requiredHours: requiredMinutes ~/ 60,
          requiredMinutes: requiredMinutes % 60,
          startTime: offDays.contains(day) ? null : startTime,
          endTime: offDays.contains(day) ? null : endTime,
          isCrossDay: offDays.contains(day) ? false : isCrossDay,
        ),
    ];
  }

  static const all = <SchedulePreset>[
    SchedulePreset(
      name: 'دوام صباحي',
      description: 'السبت–الخميس، 8 ص إلى 4 م',
      icon: Icons.wb_sunny_outlined,
      offDays: {DateTime.friday},
      startTime: '08:00',
      endTime: '16:00',
      requiredMinutes: 480,
    ),
    SchedulePreset(
      name: 'خمسة أيام',
      description: 'الأحد–الخميس، 9 ص إلى 5 م',
      icon: Icons.calendar_view_week_rounded,
      offDays: {DateTime.friday, DateTime.saturday},
      startTime: '09:00',
      endTime: '17:00',
      requiredMinutes: 480,
    ),
    SchedulePreset(
      name: 'دوام مسائي',
      description: 'السبت–الخميس، 4 م إلى 11 م',
      icon: Icons.nightlight_outlined,
      offDays: {DateTime.friday},
      startTime: '16:00',
      endTime: '23:00',
      requiredMinutes: 420,
    ),
    SchedulePreset(
      name: 'وردية ليلية',
      description: 'تمتد لليوم التالي، 10 م إلى 6 ص',
      icon: Icons.bedtime_outlined,
      offDays: {DateTime.friday},
      startTime: '22:00',
      endTime: '06:00',
      requiredMinutes: 480,
      isCrossDay: true,
    ),
  ];
}

class SchedulePresets extends StatelessWidget {
  const SchedulePresets({super.key, required this.onSelected});

  final ValueChanged<SchedulePreset> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: SchedulePreset.all.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) => _PresetCard(
          preset: SchedulePreset.all[index],
          onTap: () => onSelected(SchedulePreset.all[index]),
        ),
      ),
    );
  }
}

class _PresetCard extends StatelessWidget {
  const _PresetCard({required this.preset, required this.onTap});

  final SchedulePreset preset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 190,
      child: Material(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadius.field),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.field),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(preset.icon, color: theme.colorScheme.primary, size: 22),
                const SizedBox(height: 8),
                Text(preset.name, style: theme.textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(
                  preset.description,
                  style: theme.textTheme.labelSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
