import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/company_entity.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../providers/company_provider.dart';
import '../../providers/profile_provider.dart';
import '../schedule/widgets/schedule_presets.dart';
import 'widgets/setup_identity_step.dart';
import 'widgets/setup_progress.dart';
import 'widgets/setup_salary_step.dart';
import 'widgets/setup_schedule_step.dart';
import 'widgets/setup_welcome.dart';

/// الإعداد الأول. يظهر قبل أي شاشة أخرى ما دام الملف الشخصي غير موجود.
///
/// إلزامي لأن كل حساب في التطبيق مشتق من الراتب وجدول الدوام: بدونهما
/// يرمي `checkIn` استثناء وتظهر التقارير أصفاراً.
class SetupFlowScreen extends ConsumerStatefulWidget {
  const SetupFlowScreen({super.key});

  @override
  ConsumerState<SetupFlowScreen> createState() => _SetupFlowScreenState();
}

class _SetupFlowScreenState extends ConsumerState<SetupFlowScreen> {
  final _controller = PageController();
  final _identity = GlobalKey<FormState>();
  final _salary = GlobalKey<FormState>();

  int _step = 0;

  final _name = TextEditingController();
  final _job = TextEditingController();
  final _company = TextEditingController();
  final _baseSalary = TextEditingController();
  final _hourlyRate = TextEditingController();
  final _overtimeRate = TextEditingController(text: '1.5');
  String _currency = AppConstants.defaultCurrency;

  /// أيام الأسبوع بترقيم `DateTime.weekday` مرتبة من السبت.
  static const _weekOrder = <int>[
    DateTime.saturday,
    DateTime.sunday,
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
  ];

  late List<WorkDayConfigEntity> _schedule =
      SchedulePreset.all.first.build(_weekOrder);

  static const _lastStep = 3;

  @override
  void dispose() {
    _controller.dispose();
    for (final c in [
      _name,
      _job,
      _company,
      _baseSalary,
      _hourlyRate,
      _overtimeRate
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  bool _validateCurrentStep() {
    return switch (_step) {
      1 => _identity.currentState?.validate() ?? false,
      2 => _salary.currentState?.validate() ?? false,
      _ => true,
    };
  }

  void _next() {
    if (!_validateCurrentStep()) return;
    if (_step == _lastStep) {
      _finish();
      return;
    }
    setState(() => _step++);
    _controller.animateToPage(
      _step,
      duration: AppDurations.medium,
      curve: AppCurves.emphasized,
    );
  }

  void _back() {
    if (_step == 0) return;
    setState(() => _step--);
    _controller.animateToPage(
      _step,
      duration: AppDurations.medium,
      curve: AppCurves.emphasized,
    );
  }

  Future<void> _finish() async {
    final now = DateTime.now();

    // الشخص أولاً، ثم جهته الأولى: `create` يجعل أول جهة هي الفعّالة.
    await ref.read(profileControllerProvider.notifier).saveProfile(
          ProfileEntity(
            id: 0,
            fullName: _name.text.trim(),
            currency: _currency,
            updatedAt: now,
          ),
        );

    final companyId =
        await ref.read(companyControllerProvider.notifier).create(
              CompanyEntity(
                id: 0,
                name: _company.text.trim().isEmpty
                    ? 'جهة العمل'
                    : _company.text.trim(),
                jobTitle: _job.text.trim(),
                baseMonthlySalary:
                    double.tryParse(_baseSalary.text.trim()) ?? 0,
                hourlyRate: double.tryParse(_hourlyRate.text.trim()) ?? 0,
                overtimeRate:
                    double.tryParse(_overtimeRate.text.trim()) ?? 1.5,
                workSchedule: _schedule,
                adjustments: const [],
                currency: _currency,
                employmentStartDate: now,
                createdAt: now,
                updatedAt: now,
              ),
            );

    if (!mounted) return;
    if (companyId == null) {
      UIHelpers.showErrorSnackBar(context, 'تعذّر إنشاء جهة العمل');
      return;
    }
    // لا تنقّل: بوابة الإعداد تراقب الملف وتفتح التطبيق وحدها.
    UIHelpers.showSuccessSnackBar(context, 'تم الإعداد — أهلاً بك');
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(profileControllerProvider) is AsyncLoading ||
        ref.watch(companyControllerProvider) is AsyncLoading;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SetupProgress(step: _step, total: _lastStep + 1, onBack: _back),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const SetupWelcome(),
                  SetupIdentityStep(
                    formKey: _identity,
                    name: _name,
                    job: _job,
                    company: _company,
                  ),
                  SetupSalaryStep(
                    formKey: _salary,
                    baseSalary: _baseSalary,
                    hourlyRate: _hourlyRate,
                    overtimeRate: _overtimeRate,
                    currency: _currency,
                    onCurrencyChanged: (value) =>
                        setState(() => _currency = value),
                  ),
                  SetupScheduleStep(
                    schedule: _schedule,
                    weekOrder: _weekOrder,
                    onChanged: (value) => setState(() => _schedule = value),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: FilledButton(
                onPressed: isSaving ? null : _next,
                child: Text(
                  isSaving
                      ? 'جارٍ الحفظ…'
                      : (_step == _lastStep ? 'ابدأ الاستخدام' : 'التالي'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
