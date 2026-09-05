import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/routes.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../core/constants/theme.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/company_entity.dart';
import '../../providers/company_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/state_switcher.dart';

class CompaniesScreen extends ConsumerWidget {
  const CompaniesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companies = ref.watch(companiesProvider);
    final activeId = ref.watch(activeCompanyProvider).value?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('جهات العمل')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_company',
        onPressed: () => Navigator.pushNamed(context, AppRoutes.companyEditor),
        icon: const Icon(Icons.add_rounded),
        label: const Text('جهة جديدة'),
      ),
      body: StateSwitcher<List<CompanyEntity>>(
        value: companies,
        onRetry: () => ref.invalidate(companiesProvider),
        builder: (list) => list.isEmpty
            ? const EmptyState(
                icon: Icons.business_outlined,
                title: 'لا جهات عمل',
                message: 'أضف جهة ليبدأ تسجيل دوامها وحساب راتبها.',
              )
            : ListView.builder(
                padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.screen, AppSpacing.screen, AppSpacing.lg, 96),
                itemCount: list.length,
                itemBuilder: (context, index) => _CompanyCard(
                  company: list[index],
                  isActive: list[index].id == activeId,
                  onActivate: () => ref
                      .read(companyControllerProvider.notifier)
                      .switchTo(list[index].id),
                  onEdit: () => Navigator.pushNamed(
                    context,
                    AppRoutes.companyEditor,
                    arguments: list[index],
                  ),
                  onDelete: () => _confirmDelete(context, ref, list[index]),
                ),
              ),
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, CompanyEntity company) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('حذف ${company.name}'),
        content: const Text(
          'سيُحذف كل سجل دوام لهذه الجهة نهائياً، ولا يمكن التراجع.\n'
          'إن كنت تريد الاحتفاظ بالتقارير فأرشِفها بدل حذفها.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('حذف نهائي'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await ref.read(companyControllerProvider.notifier).delete(company.id);
    if (context.mounted) {
      UIHelpers.showSuccessSnackBar(context, 'حُذفت ${company.name}');
    }
  }
}

class _CompanyCard extends StatelessWidget {
  const _CompanyCard({
    required this.company,
    required this.isActive,
    required this.onActivate,
    required this.onEdit,
    required this.onDelete,
  });

  final CompanyEntity company;
  final bool isActive;
  final VoidCallback onActivate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final color =
        palette.categorical[company.colorIndex % palette.categorical.length];

    return Card(
      margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.md),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(
          color: isActive ? palette.primary : palette.outline,
          width: isActive ? 1.6 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 34,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(company.name,
                            style: theme.textTheme.titleMedium),
                        Text(company.jobTitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                                color: palette.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  if (isActive)
                    Chip(
                      label: const Text('الحالية'),
                      visualDensity: VisualDensity.compact,
                      backgroundColor:
                          palette.primary.withValues(alpha: 0.12),
                    ),
                ],
              ),
              const Divider(height: AppSpacing.xl),
              Row(
                children: [
                  _Stat(
                    label: 'الراتب',
                    value:
                        '${company.baseMonthlySalary.toStringAsFixed(0)} ${company.currency ?? ''}',
                  ),
                  _Stat(
                    label: 'أسبوعياً',
                    value: '${company.weeklyHours.toStringAsFixed(0)} ساعة',
                  ),
                  _Stat(
                    label: 'الإضافي',
                    value: '×${company.overtimeRate}',
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  if (!isActive)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onActivate,
                        child: const Text('التبديل إليها'),
                      ),
                    ),
                  if (!isActive) const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    tooltip: 'حذف',
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded),
                    color: palette.negative,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: context.palette.onSurfaceVariant)),
          Text(value,
              style: theme.textTheme.titleSmall?.merge(tabularFigures)),
        ],
      ),
    );
  }
}
