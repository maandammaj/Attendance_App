import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/budget_limit_entity.dart';
import '../../providers/profile_provider.dart';
import '../../providers/reminder_provider.dart';

class BudgetLimitsScreen extends ConsumerWidget {
  const BudgetLimitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final statusAsync =
        ref.watch(budgetStatusProvider(year: now.year, month: now.month));
    final currency = ref.watch(profileProvider).valueOrNull?.currency ??
        AppConstants.defaultCurrency;

    return Scaffold(
      appBar: AppBar(title: const Text('حدود الميزانية'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_budget_limit',
        onPressed: () => _openEditor(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('حد جديد'),
      ),
      body: statusAsync.when(
        data: (statuses) => statuses.isEmpty
            ? const _EmptyState()
            : ListView.builder(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 90),
                itemCount: statuses.length,
                itemBuilder: (context, index) => _BudgetLimitCard(
                  status: statuses[index],
                  currency: currency,
                  onEdit: () => _openEditor(context, ref, status: statuses[index]),
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('تعذّر التحميل: $error')),
      ),
    );
  }

  Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref, {
    BudgetStatusEntity? status,
  }) async {
    final nameController = TextEditingController(text: status?.categoryName);
    final limitController =
        TextEditingController(text: status?.limit.toStringAsFixed(0));

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(status == null ? 'حد ميزانية جديد' : 'تعديل الحد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              enabled: status == null,
              decoration: const InputDecoration(
                labelText: 'اسم الفئة',
                hintText: 'مثال: مواصلات',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: limitController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'الحد الشهري'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );

    final name = nameController.text.trim();
    final limit = double.tryParse(limitController.text.trim());
    nameController.dispose();
    limitController.dispose();

    if (saved != true || name.isEmpty || limit == null || limit <= 0) return;

    await ref.read(reminderControllerProvider.notifier).saveBudgetLimit(
          categoryName: name,
          monthlyLimit: limit,
        );
    if (context.mounted) {
      UIHelpers.showSuccessSnackBar(context, 'تم حفظ حد "$name"');
    }
  }
}

class _BudgetLimitCard extends StatelessWidget {
  const _BudgetLimitCard({
    required this.status,
    required this.currency,
    required this.onEdit,
  });

  final BudgetStatusEntity status;
  final String currency;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = status.ratio.clamp(0.0, 1.0);
    final color = status.isOverrun
        ? theme.colorScheme.error
        : (status.ratio >= 0.8 ? Colors.orange : theme.colorScheme.primary);

    return Card(
      elevation: 0,
      margin: const EdgeInsetsDirectional.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withValues(alpha: 0.35)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(status.categoryName,
                        style: theme.textTheme.titleMedium),
                  ),
                  Text(
                    '${(status.ratio * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.titleMedium?.copyWith(color: color),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 8,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.15),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                status.isOverrun
                    ? 'تجاوزت بـ ${(status.spent - status.limit).toStringAsFixed(0)} $currency'
                    : 'المتبقي ${status.remaining.toStringAsFixed(0)} $currency',
                style: theme.textTheme.bodySmall?.copyWith(color: color),
              ),
              Text(
                '${status.spent.toStringAsFixed(0)} من ${status.limit.toStringAsFixed(0)} $currency',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.savings_outlined,
                size: 64, color: Theme.of(context).disabledColor),
            const SizedBox(height: 16),
            Text(
              'لم تحدد حدوداً بعد',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'أضف حداً شهرياً لكل فئة، وسينبهك التطبيق قبل أن تتجاوزه.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
