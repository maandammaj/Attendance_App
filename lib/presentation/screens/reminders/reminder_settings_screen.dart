import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/reminder_settings_entity.dart';
import '../../providers/reminder_provider.dart';
import 'widgets/biometric_status_tile.dart';
import 'widgets/reminder_section.dart';
import 'widgets/reminder_switch_tile.dart';
import 'widgets/reminder_time_tile.dart';
import 'widgets/reminder_stepper_tile.dart';

class ReminderSettingsScreen extends ConsumerWidget {
  const ReminderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(reminderSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('التذكيرات الذكية'),
        centerTitle: true,
      ),
      body: settingsAsync.when(
        data: (settings) => _SettingsBody(settings: settings),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('تعذّر تحميل الإعدادات: $error')),
      ),
    );
  }
}

class _SettingsBody extends ConsumerWidget {
  const _SettingsBody({required this.settings});

  final ReminderSettingsEntity settings;

  Future<void> _update(
    BuildContext context,
    WidgetRef ref,
    ReminderSettingsEntity updated,
  ) async {
    await ref.read(reminderControllerProvider.notifier).saveSettings(updated);
    if (context.mounted) {
      UIHelpers.showSuccessSnackBar(context, 'تم حفظ التذكيرات وإعادة جدولتها');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void save(ReminderSettingsEntity updated) => _update(context, ref, updated);

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 40),
      children: [
        ReminderSection(
          title: 'تذكيرات الدوام',
          icon: Icons.access_time_rounded,
          children: [
            ReminderSwitchTile(
              title: 'تذكير قبل بداية الوردية',
              subtitle: 'يُجدول تلقائياً من جدول دوامك',
              value: settings.shiftStartEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(shiftStartEnabled: value)),
            ),
            if (settings.shiftStartEnabled)
              ReminderStepperTile(
                title: 'قبل البداية بـ',
                value: settings.shiftStartLeadMinutes,
                unit: 'دقيقة',
                step: 5,
                min: 5,
                max: 120,
                onChanged: (value) =>
                    save(settings.copyWith(shiftStartLeadMinutes: value)),
              ),
            ReminderSwitchTile(
              title: 'تذكير قبل نهاية الوردية',
              value: settings.shiftEndEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(shiftEndEnabled: value)),
            ),
            if (settings.shiftEndEnabled)
              ReminderStepperTile(
                title: 'قبل النهاية بـ',
                value: settings.shiftEndLeadMinutes,
                unit: 'دقيقة',
                step: 5,
                min: 5,
                max: 120,
                onChanged: (value) =>
                    save(settings.copyWith(shiftEndLeadMinutes: value)),
              ),
            ReminderSwitchTile(
              title: 'تنبيه عند اكتمال الساعات المطلوبة',
              subtitle: 'يخبرك متى يبدأ احتساب الإضافي',
              value: settings.requiredHoursDoneEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(requiredHoursDoneEnabled: value)),
            ),
            ReminderSwitchTile(
              title: 'تنبيه نسيان تسجيل الخروج',
              value: settings.forgotCheckOutEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(forgotCheckOutEnabled: value)),
            ),
            if (settings.forgotCheckOutEnabled)
              ReminderStepperTile(
                title: 'بعد مرور',
                value: settings.forgotCheckOutAfterHours,
                unit: 'ساعة',
                step: 1,
                min: 4,
                max: 24,
                onChanged: (value) =>
                    save(settings.copyWith(forgotCheckOutAfterHours: value)),
              ),
            ReminderSwitchTile(
              title: 'تنبيه عدم تسجيل الحضور',
              value: settings.missedCheckInEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(missedCheckInEnabled: value)),
            ),
            if (settings.missedCheckInEnabled)
              ReminderStepperTile(
                title: 'بعد بداية الوردية بـ',
                value: settings.missedCheckInAfterMinutes,
                unit: 'دقيقة',
                step: 15,
                min: 15,
                max: 180,
                onChanged: (value) =>
                    save(settings.copyWith(missedCheckInAfterMinutes: value)),
              ),
          ],
        ),
        ReminderSection(
          title: 'تذكيرات الديون',
          icon: Icons.handshake_outlined,
          children: [
            ReminderSwitchTile(
              title: 'تنبيه قبل الاستحقاق',
              subtitle: 'قبل ${settings.debtDueLeadDays.join(" و")} أيام',
              value: settings.debtDueEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(debtDueEnabled: value)),
            ),
            ReminderSwitchTile(
              title: 'تنبيه الديون المتأخرة',
              value: settings.debtOverdueEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(debtOverdueEnabled: value)),
            ),
          ],
        ),
        ReminderSection(
          title: 'تنبيهات مالية ذكية',
          icon: Icons.insights_rounded,
          children: [
            ReminderSwitchTile(
              title: 'تجاوز ميزانية فئة',
              subtitle: 'يعتمد على حدود الفئات التي تحددها',
              value: settings.budgetOverrunEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(budgetOverrunEnabled: value)),
            ),
            if (settings.budgetOverrunEnabled)
              ReminderStepperTile(
                title: 'تحذير عند استهلاك',
                value: (settings.budgetWarnThreshold * 100).round(),
                unit: '%',
                step: 5,
                min: 50,
                max: 95,
                onChanged: (value) =>
                    save(settings.copyWith(budgetWarnThreshold: value / 100)),
              ),
            ReminderSwitchTile(
              title: 'معدل صرف غير معتاد',
              subtitle: 'مقارنة بنفس الفترة من الشهر الماضي',
              value: settings.unusualSpendingEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(unusualSpendingEnabled: value)),
            ),
            ReminderSwitchTile(
              title: 'نسبة الدين إلى الراتب',
              value: settings.debtRatioEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(debtRatioEnabled: value)),
            ),
            if (settings.debtRatioEnabled)
              ReminderStepperTile(
                title: 'حد الخطر',
                value: (settings.debtRatioThreshold * 100).round(),
                unit: '% من الراتب',
                step: 10,
                min: 20,
                max: 200,
                onChanged: (value) =>
                    save(settings.copyWith(debtRatioThreshold: value / 100)),
              ),
            ReminderSwitchTile(
              title: 'توقّع عجز نهاية الشهر',
              subtitle: 'استقراء بمعدل الصرف اليومي',
              value: settings.monthEndForecastEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(monthEndForecastEnabled: value)),
            ),
            ReminderSwitchTile(
              title: 'مصروف متكرر لم يُسجَّل',
              value: settings.recurringExpenseEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(recurringExpenseEnabled: value)),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.tune_rounded),
              title: const Text('إدارة حدود الميزانية'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              onTap: () => Navigator.pushNamed(context, '/budget-limits'),
            ),
          ],
        ),
        ReminderSection(
          title: 'الملخصات الدورية',
          icon: Icons.summarize_outlined,
          children: [
            ReminderSwitchTile(
              title: 'ملخص يومي',
              value: settings.dailySummaryEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(dailySummaryEnabled: value)),
            ),
            if (settings.dailySummaryEnabled)
              ReminderTimeTile(
                title: 'وقت الملخص اليومي',
                time: settings.dailySummaryTime,
                onChanged: (value) =>
                    save(settings.copyWith(dailySummaryTime: value)),
              ),
            ReminderSwitchTile(
              title: 'ملخص أسبوعي',
              value: settings.weeklySummaryEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(weeklySummaryEnabled: value)),
            ),
            if (settings.weeklySummaryEnabled) ...[
              _WeekdayPicker(
                selected: settings.weeklySummaryDayOfWeek,
                onChanged: (value) =>
                    save(settings.copyWith(weeklySummaryDayOfWeek: value)),
              ),
              ReminderTimeTile(
                title: 'وقت الملخص الأسبوعي',
                time: settings.weeklySummaryTime,
                onChanged: (value) =>
                    save(settings.copyWith(weeklySummaryTime: value)),
              ),
            ],
            ReminderSwitchTile(
              title: 'التقرير الشهري',
              value: settings.monthlySummaryEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(monthlySummaryEnabled: value)),
            ),
            if (settings.monthlySummaryEnabled) ...[
              ReminderStepperTile(
                title: 'يوم الشهر',
                value: settings.monthlySummaryDayOfMonth,
                unit: '',
                step: 1,
                min: 1,
                max: 31,
                onChanged: (value) =>
                    save(settings.copyWith(monthlySummaryDayOfMonth: value)),
              ),
              ReminderTimeTile(
                title: 'وقت التقرير الشهري',
                time: settings.monthlySummaryTime,
                onChanged: (value) =>
                    save(settings.copyWith(monthlySummaryTime: value)),
              ),
            ],
          ],
        ),
        ReminderSection(
          title: 'الأمان والبصمة',
          icon: Icons.fingerprint_rounded,
          children: [
            ReminderSwitchTile(
              title: 'إلزام التحقق للحضور والانصراف',
              subtitle:
                  'عند إيقافه يُسجَّل الدوام دون بصمة على الأجهزة غير المدعومة',
              value: settings.requireBiometricForAttendance,
              onChanged: (value) => save(
                  settings.copyWith(requireBiometricForAttendance: value)),
            ),
            ReminderSwitchTile(
              title: 'قفل التطبيق عند الفتح',
              subtitle: 'يطلب تحققاً قبل عرض بياناتك المالية',
              value: settings.appLockEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(appLockEnabled: value)),
            ),
            ReminderSwitchTile(
              title: 'السماح بقفل الجهاز كبديل',
              subtitle: 'رمز PIN أو النمط حين تتعذّر البصمة',
              value: settings.allowDeviceCredential,
              onChanged: (value) =>
                  save(settings.copyWith(allowDeviceCredential: value)),
            ),
            const BiometricStatusTile(),
          ],
        ),
        ReminderSection(
          title: 'ساعات الهدوء',
          icon: Icons.bedtime_outlined,
          children: [
            ReminderSwitchTile(
              title: 'كتم التنبيهات ليلاً',
              subtitle: 'تنبيهات نسيان تسجيل الخروج تصل رغم ذلك',
              value: settings.quietHoursEnabled,
              onChanged: (value) =>
                  save(settings.copyWith(quietHoursEnabled: value)),
            ),
            if (settings.quietHoursEnabled) ...[
              ReminderTimeTile(
                title: 'من',
                time: settings.quietHoursStart,
                onChanged: (value) =>
                    save(settings.copyWith(quietHoursStart: value)),
              ),
              ReminderTimeTile(
                title: 'إلى',
                time: settings.quietHoursEnd,
                onChanged: (value) =>
                    save(settings.copyWith(quietHoursEnd: value)),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _WeekdayPicker extends StatelessWidget {
  const _WeekdayPicker({required this.selected, required this.onChanged});

  /// أيام الأسبوع بترقيم DateTime.weekday مرتبة من السبت إلى الجمعة.
  static const _weekOrder = <int>[
    DateTime.saturday,
    DateTime.sunday,
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
  ];

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 8, bottom: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          // الشرائح معروضة بترتيب arabicDays (السبت أولاً) لكن القيمة المخزَّنة
          // بترقيم DateTime.weekday، فالتحويل يتم عند العرض وعند الاختيار.
          for (final scheduleDay in _weekOrder)
            ChoiceChip(
              label: Text(
                  DateHelpers.arabicDayNameOfScheduleDay(scheduleDay)),
              selected: selected == scheduleDay,
              onSelected: (_) => onChanged(scheduleDay),
            ),
        ],
      ),
    );
  }
}
