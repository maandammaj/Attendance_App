import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/routes.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/state_switcher.dart';
import '../../widgets/app_button.dart';
import '../../../domain/entities/company_entity.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../providers/company_provider.dart';
import '../../providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtl;
  late TextEditingController _jobCtl;
  late TextEditingController _baseSalaryCtl;
  late TextEditingController _hourlyCtl;
  late TextEditingController _overtimeCtl;
  String? _currency = 'ر.ي';
  List<WorkDayConfigEntity> _schedule = [];
  List<SalaryAdjustmentEntity> _adjustments = [];

  bool _inited = false;

  @override
  void initState() {
    super.initState();
    _nameCtl = TextEditingController();
    _jobCtl = TextEditingController();
    _baseSalaryCtl = TextEditingController();
    _hourlyCtl = TextEditingController();
    _overtimeCtl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _jobCtl.dispose();
    _baseSalaryCtl.dispose();
    _hourlyCtl.dispose();
    _overtimeCtl.dispose();
    super.dispose();
  }

  /// الاسم يخص الشخص، وبقية الحقول تخص الجهة — يُحفظان في كيانين.
  ProfileEntity _buildProfile(ProfileEntity current) {
    return current.copyWith(
      fullName:
          _nameCtl.text.trim().isEmpty ? 'المستخدم' : _nameCtl.text.trim(),
      currency: _currency,
    );
  }

  CompanyEntity _buildCompany(CompanyEntity current) {
    return current.copyWith(
      jobTitle: _jobCtl.text.trim().isEmpty
          ? 'المسمى الوظيفي'
          : _jobCtl.text.trim(),
      baseMonthlySalary: double.tryParse(_baseSalaryCtl.text) ?? 0,
      hourlyRate: double.tryParse(_hourlyCtl.text) ?? 0,
      overtimeRate: double.tryParse(_overtimeCtl.text) ?? 1.5,
      workSchedule: _schedule,
      adjustments: _adjustments,
      currency: _currency,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final company = ref.watch(activeCompanyProvider).valueOrNull;
    final profileState = ref.watch(profileControllerProvider);

    profileAsync.whenData((profile) {
      if (!_inited) {
        _inited = true;
        if (profile != null) {
          _nameCtl.text = profile.fullName;
          _jobCtl.text = company?.jobTitle ?? '';
          _baseSalaryCtl.text = (company?.baseMonthlySalary ?? 0).toStringAsFixed(0);
          _hourlyCtl.text = (company?.hourlyRate ?? 0).toStringAsFixed(0);
          _overtimeCtl.text = (company?.overtimeRate ?? 1.5).toString();
          _currency = profile.currency ?? 'ر.ي';
          _schedule = company?.workSchedule ?? const [];
          _adjustments = company?.adjustments ?? const [];
        } else {
          _schedule = List.generate(7, (i) => WorkDayConfigEntity(
            dayOfWeek: i + 1,
            isWorkingDay: i < 5,
            requiredHours: 8,
            requiredMinutes: 0,
            isHoliday: i >= 5,
            startTime: '08:00',
            endTime: '16:00',
          ));
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي والرواتب')),
      body: profileAsync.when(
        data: (profile) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SectionHeader(title: 'البيانات الأساسية'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameCtl,
                decoration: const InputDecoration(labelText: 'الاسم الكامل', prefixIcon: Icon(Icons.person_outline)),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'الرجاء إدخال الاسم' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _baseSalaryCtl,
                      decoration: const InputDecoration(labelText: 'الراتب الأساسي'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _currency,
                      decoration: const InputDecoration(labelText: 'العملة'),
                      items: ['ر.ي', 'SAR', 'USD', 'EGP', 'AED']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => _currency = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'جدول الدوام'),
              const SizedBox(height: 8),
              const _ScheduleLink(),
              const SizedBox(height: 32),
              AppButton(
                label: 'حفظ كافة الإعدادات',
                icon: Icons.save_rounded,
                isLoading: profileState is AsyncLoading,
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await ref
                        .read(profileControllerProvider.notifier)
                        .saveProfile(_buildProfile(profile!));
                    if (company != null) {
                      await ref
                          .read(companyControllerProvider.notifier)
                          .save(_buildCompany(company));
                    }
                    if (mounted) {
                      final state = ref.read(profileControllerProvider);
                      if (state is! AsyncError) {
                        UIHelpers.showSuccessSnackBar(context, 'تم تحديث الملف الشخصي بنجاح');
                      } else {
                        UIHelpers.showErrorSnackBar(context, 'خطأ: ${state.error}');
                      }
                    }
                  }
                },
              ),
              const SizedBox(height: 32),
              const SectionHeader(title: 'النظام'),
              const SizedBox(height: 8),
              const _SystemLinks(),
              const SizedBox(height: 40),
            ],
          ),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(children: [Skeleton(height: 72), Skeleton(height: 72), Skeleton(height: 140)]),
        ),
        error: (e, _) => Center(child: Text('تعذّر التحميل: $e')),
      ),
    );
  }


}

/// روابط الشاشات التي لا تملك تبويباً في الشريط السفلي.
class _SystemLinks extends StatelessWidget {
  const _SystemLinks();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LinkTile(
          icon: Icons.business_outlined,
          title: 'جهات العمل',
          subtitle: 'أضف جهة أو بدّل بينها',
          route: AppRoutes.companies,
        ),
        _LinkTile(
          icon: Icons.event_note_rounded,
          title: 'جدول الدوام',
          subtitle: 'أيام العمل وأوقات الورديات',
          route: '/work-schedule',
        ),
        _LinkTile(
          icon: Icons.insights_rounded,
          title: 'التقارير والتحليلات',
          subtitle: 'رسوم بيانية وتصدير PDF و CSV',
          route: '/analytics',
        ),
        _LinkTile(
          icon: Icons.notifications_active_outlined,
          title: 'التذكيرات الذكية',
          subtitle: 'تذكيرات الدوام والديون والتنبيهات المالية',
          route: '/reminders',
        ),
        _LinkTile(
          icon: Icons.savings_outlined,
          title: 'حدود الميزانية',
          subtitle: 'حد شهري لكل فئة إنفاق',
          route: '/budget-limits',
        ),
        _LinkTile(
          icon: Icons.history_rounded,
          title: 'سجل التنبيهات',
          subtitle: 'كل ما أرسله التطبيق سابقاً',
          route: '/notification-history',
        ),
      ],
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }
}

/// مدخل شاشة الجدول — التحرير الكامل صار له شاشته الخاصة.
class _ScheduleLink extends StatelessWidget {
  const _ScheduleLink();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        contentPadding:
            const EdgeInsetsDirectional.fromSTEB(16, 6, 12, 6),
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          child: Icon(Icons.event_note_rounded,
              color: theme.colorScheme.primary),
        ),
        title: const Text('تخصيص أيام وأوقات الدوام'),
        subtitle: Text('قوالب جاهزة، نوافذ ورديات، وورديات ليلية',
            style: theme.textTheme.bodySmall),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
        onTap: () => Navigator.pushNamed(context, '/work-schedule'),
      ),
    );
  }
}
