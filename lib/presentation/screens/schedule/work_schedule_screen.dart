import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/company_entity.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../providers/company_provider.dart';
import '../../widgets/common/animated_entrance.dart';
import '../../widgets/common/section_header.dart';
import 'widgets/schedule_day_tile.dart';
import 'widgets/schedule_presets.dart';
import 'widgets/schedule_summary.dart';

/// تخصيص أيام وأوقات الدوام. مفصولة عن شاشة الملف الشخصي لأنها أطول
/// من بقية الحقول ولأن تعديلها يعيد جدولة كل تذكيرات الوردية.
class WorkScheduleScreen extends ConsumerStatefulWidget {
  const WorkScheduleScreen({super.key});

  @override
  ConsumerState<WorkScheduleScreen> createState() => _WorkScheduleScreenState();
}

class _WorkScheduleScreenState extends ConsumerState<WorkScheduleScreen> {
  List<WorkDayConfigEntity>? _schedule;
  bool _isDirty = false;

  /// ترتيب العرض من السبت إلى الجمعة، بقيم `DateTime.weekday`.
  static const _weekOrder = <int>[
    DateTime.saturday,
    DateTime.sunday,
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
  ];

  List<WorkDayConfigEntity> _seed(CompanyEntity? company) {
    final existing = {
      for (final day in company?.workSchedule ?? const <WorkDayConfigEntity>[])
        day.dayOfWeek: day,
    };
    return [
      for (final day in _weekOrder)
        existing[day] ??
            WorkDayConfigEntity(
              dayOfWeek: day,
              isWorkingDay: day != DateTime.friday,
              requiredHours: 8,
              requiredMinutes: 0,
              isHoliday: day == DateTime.friday,
              startTime: '08:00',
              endTime: '16:00',
            ),
    ];
  }

  void _update(int dayOfWeek, WorkDayConfigEntity updated) {
    setState(() {
      _isDirty = true;
      _schedule = [
        for (final day in _schedule!)
          day.dayOfWeek == dayOfWeek ? updated : day,
      ];
    });
  }

  /// ينسخ توقيت أول يوم عمل مفعّل إلى بقية أيام العمل.
  void _applyToAllWorkingDays() {
    final source = _schedule!.firstWhere(
      (day) => day.isWorkingDay && !day.isHoliday,
      orElse: () => _schedule!.first,
    );
    setState(() {
      _isDirty = true;
      _schedule = [
        for (final day in _schedule!)
          day.isWorkingDay && !day.isHoliday
              ? day.copyWith(
                  requiredHours: source.requiredHours,
                  requiredMinutes: source.requiredMinutes,
                  startTime: source.startTime,
                  endTime: source.endTime,
                  isCrossDay: source.isCrossDay,
                )
              : day,
      ];
    });
    UIHelpers.showInfoSnackBar(
        context, 'طُبّق توقيت ${DateHelpers.arabicDayNameOfScheduleDay(source.dayOfWeek)} على أيام العمل');
  }

  void _applyPreset(SchedulePreset preset) {
    setState(() {
      _isDirty = true;
      _schedule = preset.build(_weekOrder);
    });
  }

  Future<void> _save() async {
    final company = ref.read(activeCompanyProvider).value;
    if (company == null) {
      UIHelpers.showErrorSnackBar(context, 'اختر جهة عمل أولاً');
      return;
    }

    // copyWith يحفظ بقية شروط الجهة؛ هذه الشاشة تملك الجدول وحده.
    await ref
        .read(companyControllerProvider.notifier)
        .save(company.copyWith(workSchedule: _schedule!));

    if (!mounted) return;
    final state = ref.read(companyControllerProvider);
    if (state is AsyncError) {
      UIHelpers.showErrorSnackBar(context, 'تعذّر الحفظ: ${state.error}');
      return;
    }
    setState(() => _isDirty = false);
    UIHelpers.showSuccessSnackBar(
        context, 'حُفظ الجدول وأُعيدت جدولة التذكيرات');
  }

  @override
  Widget build(BuildContext context) {
    final companyAsync = ref.watch(activeCompanyProvider);
    final isSaving = ref.watch(companyControllerProvider) is AsyncLoading;

    return companyAsync.when(
      loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator())),
      error: (error, _) =>
          Scaffold(body: Center(child: Text('تعذّر التحميل: $error'))),
      data: (company) {
        _schedule ??= _seed(company);
        final schedule = _schedule!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('جدول الدوام'),
            actions: [
              IconButton(
                icon: const Icon(Icons.content_copy_rounded),
                tooltip: 'تطبيق التوقيت على كل أيام العمل',
                onPressed: _applyToAllWorkingDays,
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                onPressed: (!_isDirty || isSaving) ? null : _save,
                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.save_rounded),
                label: Text(_isDirty ? 'حفظ الجدول' : 'لا تغييرات'),
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
            children: [
              AnimatedEntrance(child: ScheduleSummary(schedule: schedule)),
              const SizedBox(height: 20),
              const AnimatedEntrance(
                index: 1,
                child: SectionHeader(
                  title: 'قوالب جاهزة',
                  subtitle: 'تبدأ منها ثم تعدّل ما تشاء',
                ),
              ),
              AnimatedEntrance(
                index: 2,
                child: SchedulePresets(onSelected: _applyPreset),
              ),
              const SizedBox(height: 24),
              const AnimatedEntrance(
                index: 3,
                child: SectionHeader(
                  title: 'أيام الأسبوع',
                  subtitle: 'فعّل اليوم ثم اضبط ساعاته ونافذة ورديته',
                ),
              ),
              for (int i = 0; i < schedule.length; i++)
                AnimatedEntrance(
                  index: 4 + i,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 10),
                    child: ScheduleDayTile(
                      config: schedule[i],
                      onChanged: (updated) =>
                          _update(schedule[i].dayOfWeek, updated),
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        );
      },
    );
  }
}
