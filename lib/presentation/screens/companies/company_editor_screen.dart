import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/company_entity.dart';
import '../../providers/company_provider.dart';
import '../../providers/profile_provider.dart';
import '../schedule/widgets/schedule_presets.dart';
import '../../widgets/common/section_header.dart';

/// إنشاء جهة أو تعديلها. الجدول يُختار بقالب هنا ويُضبط تفصيلاً في شاشة
/// جدول الدوام، فلا يتضخّم هذا النموذج.
class CompanyEditorScreen extends ConsumerStatefulWidget {
  const CompanyEditorScreen({super.key, this.company});

  final CompanyEntity? company;

  @override
  ConsumerState<CompanyEditorScreen> createState() =>
      _CompanyEditorScreenState();
}

class _CompanyEditorScreenState extends ConsumerState<CompanyEditorScreen> {
  final _formKey = GlobalKey<FormState>();

  late final _name = TextEditingController(text: widget.company?.name);
  late final _job = TextEditingController(text: widget.company?.jobTitle);
  late final _salary = TextEditingController(
      text: widget.company?.baseMonthlySalary.toStringAsFixed(0));
  late final _hourly = TextEditingController(
      text: (widget.company?.hourlyRate ?? 0) == 0
          ? ''
          : widget.company!.hourlyRate.toStringAsFixed(0));
  late final _overtime = TextEditingController(
      text: (widget.company?.overtimeRate ?? 1.5).toString());

  late String _currency = widget.company?.currency ??
      ref.read(profileProvider).valueOrNull?.currency ??
      AppConstants.defaultCurrency;
  late int _colorIndex = widget.company?.colorIndex ?? 0;

  static const _weekOrder = <int>[
    DateTime.saturday,
    DateTime.sunday,
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
  ];

  late var _schedule = widget.company?.workSchedule ??
      SchedulePreset.all.first.build(_weekOrder);

  bool get _isNew => widget.company == null;

  @override
  void dispose() {
    for (final c in [_name, _job, _salary, _hourly, _overtime]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final now = DateTime.now();
    final controller = ref.read(companyControllerProvider.notifier);

    if (_isNew) {
      await controller.create(CompanyEntity(
        id: 0,
        name: _name.text.trim(),
        jobTitle: _job.text.trim(),
        baseMonthlySalary: double.tryParse(_salary.text.trim()) ?? 0,
        hourlyRate: double.tryParse(_hourly.text.trim()) ?? 0,
        overtimeRate: double.tryParse(_overtime.text.trim()) ?? 1.5,
        workSchedule: _schedule,
        adjustments: const [],
        currency: _currency,
        employmentStartDate: now,
        colorIndex: _colorIndex,
        createdAt: now,
        updatedAt: now,
      ));
    } else {
      await controller.save(widget.company!.copyWith(
        name: _name.text.trim(),
        jobTitle: _job.text.trim(),
        baseMonthlySalary: double.tryParse(_salary.text.trim()) ?? 0,
        hourlyRate: double.tryParse(_hourly.text.trim()) ?? 0,
        overtimeRate: double.tryParse(_overtime.text.trim()) ?? 1.5,
        workSchedule: _schedule,
        currency: _currency,
        colorIndex: _colorIndex,
      ));
    }

    if (!mounted) return;
    final state = ref.read(companyControllerProvider);
    if (state is AsyncError) {
      UIHelpers.showErrorSnackBar(context, 'تعذّر الحفظ: ${state.error}');
      return;
    }
    Navigator.pop(context);
    UIHelpers.showSuccessSnackBar(
        context, _isNew ? 'أُضيفت الجهة' : 'حُفظت التعديلات');
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isSaving = ref.watch(companyControllerProvider) is AsyncLoading;

    return Scaffold(
      appBar: AppBar(title: Text(_isNew ? 'جهة عمل جديدة' : 'تعديل الجهة')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'اسم الجهة',
                prefixIcon: Icon(Icons.business_outlined),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'أدخل اسم الجهة'
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _job,
              decoration: const InputDecoration(
                labelText: 'مسمّاك فيها',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'أدخل المسمّى'
                  : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(title: 'الراتب'),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _salary,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'الراتب الشهري'),
                    validator: (value) {
                      final amount = double.tryParse(value?.trim() ?? '');
                      return (amount == null || amount <= 0)
                          ? 'أدخل مبلغاً صحيحاً'
                          : null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _currency,
                    decoration: const InputDecoration(labelText: 'العملة'),
                    items: const [
                      DropdownMenuItem(value: 'ر.ي', child: Text('ر.ي')),
                      DropdownMenuItem(value: 'ر.س', child: Text('ر.س')),
                      DropdownMenuItem(value: 'د.إ', child: Text('د.إ')),
                      DropdownMenuItem(value: 'ج.م', child: Text('ج.م')),
                      DropdownMenuItem(value: 'USD', child: Text('USD')),
                    ],
                    onChanged: (value) =>
                        setState(() => _currency = value ?? _currency),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _hourly,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'أجر الساعة (اختياري)',
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _overtime,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'معامل الإضافي'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(
              title: 'الدوام',
              subtitle: 'اختر قالباً — الضبط التفصيلي في شاشة جدول الدوام',
            ),
            for (final preset in SchedulePreset.all)
              RadioListTile<String>(
                value: preset.name,
                groupValue: _matchedPreset,
                title: Text(preset.name),
                subtitle: Text(preset.description),
                contentPadding: EdgeInsets.zero,
                onChanged: (_) =>
                    setState(() => _schedule = preset.build(_weekOrder)),
              ),
            const SizedBox(height: AppSpacing.xl),
            const SectionHeader(
              title: 'لون التمييز',
              subtitle: 'يميّز الجهة في القوائم والرسوم',
            ),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                for (int i = 0; i < palette.categorical.length; i++)
                  GestureDetector(
                    onTap: () => setState(() => _colorIndex = i),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: palette.categorical[i],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _colorIndex == i
                              ? palette.onSurface
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: _colorIndex == i
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: AppIconSize.md)
                          : null,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            FilledButton(
              onPressed: isSaving ? null : _save,
              child: Text(isSaving ? 'جارٍ الحفظ…' : 'حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  /// القالب المطابق للجدول الحالي، أو null إن كان مضبوطاً يدوياً.
  String? get _matchedPreset {
    final offDays = _schedule
        .where((day) => !day.isWorkingDay || day.isHoliday)
        .map((day) => day.dayOfWeek)
        .toSet();
    final working = _schedule.firstWhere(
      (day) => day.isWorkingDay && !day.isHoliday,
      orElse: () => _schedule.first,
    );
    for (final preset in SchedulePreset.all) {
      if (preset.offDays.length == offDays.length &&
          preset.offDays.containsAll(offDays) &&
          preset.startTime == working.startTime &&
          preset.endTime == working.endTime) {
        return preset.name;
      }
    }
    return null;
  }
}
