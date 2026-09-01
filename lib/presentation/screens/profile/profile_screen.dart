import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../widgets/app_button.dart';
import '../../../domain/entities/profile_entity.dart';
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

  ProfileEntity _buildProfile(int id) {
    final now = DateTime.now();
    return ProfileEntity(
      id: id,
      fullName: _nameCtl.text.trim().isEmpty ? 'المستخدم' : _nameCtl.text.trim(),
      jobTitle: _jobCtl.text.trim().isEmpty ? 'المسمى الوظيفي' : _jobCtl.text.trim(),
      baseMonthlySalary: double.tryParse(_baseSalaryCtl.text) ?? 0.0,
      hourlyRate: double.tryParse(_hourlyCtl.text) ?? 0.0,
      overtimeRate: double.tryParse(_overtimeCtl.text) ?? 1.5,
      workSchedule: _schedule,
      adjustments: _adjustments,
      currency: _currency,
      updatedAt: now,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);
    final profileState = ref.watch(profileControllerProvider);

    profileAsync.whenData((profile) {
      if (!_inited) {
        _inited = true;
        if (profile != null) {
          _nameCtl.text = profile.fullName;
          _jobCtl.text = profile.jobTitle;
          _baseSalaryCtl.text = profile.baseMonthlySalary.toString();
          _hourlyCtl.text = profile.hourlyRate.toString();
          _overtimeCtl.text = profile.overtimeRate.toString();
          _currency = profile.currency ?? 'ر.ي';
          _schedule = profile.workSchedule;
          _adjustments = profile.adjustments;
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
              _buildSectionHeader('البيانات الأساسية'),
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
              _buildSectionHeader('إعدادات الورديات'),
              const Text('قم بضبط مواعيد العمل الرسمية لكل يوم بدقة', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              ..._schedule.map((day) => _buildDayTile(day)).toList(),
              const SizedBox(height: 32),
              AppButton(
                label: 'حفظ كافة الإعدادات',
                icon: Icons.save_rounded,
                isLoading: profileState is AsyncLoading,
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final newProfile = _buildProfile(profile?.id ?? 0);
                    await ref.read(profileControllerProvider.notifier).saveProfile(newProfile);
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
              const SizedBox(height: 40),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildDayTile(WorkDayConfigEntity day) {
    final dayNames = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    final name = dayNames[day.dayOfWeek - 1];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: ExpansionTile(
        title: Text(name, style: TextStyle(fontWeight: day.isWorkingDay ? FontWeight.bold : FontWeight.normal)),
        leading: Icon(day.isWorkingDay ? Icons.work_outline : Icons.weekend_outlined, 
                      color: day.isWorkingDay ? Colors.blue : Colors.grey),
        trailing: Switch(
          value: day.isWorkingDay,
          onChanged: (v) {
            setState(() {
              final idx = _schedule.indexOf(day);
              _schedule[idx] = WorkDayConfigEntity(
                dayOfWeek: day.dayOfWeek,
                isWorkingDay: v,
                requiredHours: day.requiredHours,
                requiredMinutes: day.requiredMinutes,
                isHoliday: !v,
                startTime: day.startTime,
                endTime: day.endTime,
              );
            });
          },
        ),
        children: [
          if (day.isWorkingDay)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTimePickerField(
                      label: 'بداية الوردية',
                      value: day.startTime ?? '08:00',
                      onTap: () async {
                        final time = await _selectTime(day.startTime ?? '08:00');
                        if (time != null) {
                          setState(() {
                            final idx = _schedule.indexOf(day);
                            _schedule[idx] = WorkDayConfigEntity(
                              dayOfWeek: day.dayOfWeek,
                              isWorkingDay: true,
                              requiredHours: day.requiredHours,
                              requiredMinutes: day.requiredMinutes,
                              isHoliday: false,
                              startTime: time,
                              endTime: day.endTime,
                            );
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTimePickerField(
                      label: 'نهاية الوردية',
                      value: day.endTime ?? '16:00',
                      onTap: () async {
                        final time = await _selectTime(day.endTime ?? '16:00');
                        if (time != null) {
                          setState(() {
                            final idx = _schedule.indexOf(day);
                            _schedule[idx] = WorkDayConfigEntity(
                              dayOfWeek: day.dayOfWeek,
                              isWorkingDay: true,
                              requiredHours: day.requiredHours,
                              requiredMinutes: day.requiredMinutes,
                              isHoliday: false,
                              startTime: day.startTime,
                              endTime: time,
                            );
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildTimePickerField({required String label, required String value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Future<String?> _selectTime(String initial) async {
    final parts = initial.split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
    );
    if (picked != null) {
      return '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
    return null;
  }
}
