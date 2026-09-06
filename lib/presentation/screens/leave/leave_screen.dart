import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/leave_entity.dart';
import '../../providers/attendance_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/state_switcher.dart';

/// إجازات هذه الجهة وأرصدتها.
class LeaveScreen extends ConsumerWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = DateTime.now().year;
    final balancesAsync = ref.watch(leaveBalancesProvider(year: year));

    return Scaffold(
      appBar: AppBar(title: const Text('الإجازات'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_leave',
        onPressed: () => _addLeave(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: const Text('إجازة جديدة'),
      ),
      body: StateSwitcher(
        value: balancesAsync,
        skeletonHeight: 160,
        onRetry: () => ref.invalidate(leaveBalancesProvider),
        builder: (balances) {
          final declared =
              balances.where((b) => b.allowance > 0 || b.used > 0).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 96),
            children: [
              SectionHeader(
                title: 'الأرصدة',
                subtitle: 'سنة $year — لهذه الجهة وحدها',
              ),
              if (declared.isEmpty)
                const _NoBalances()
              else
                for (final balance in declared) _BalanceTile(balance: balance),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'الإجازات المسجّلة'),
              _LeaveList(year: year),
            ],
          );
        },
      ),
    );
  }

  Future<void> _addLeave(BuildContext context, WidgetRef ref) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 2),
    );
    if (range == null || !context.mounted) return;

    final type = await showModalBottomSheet<LeaveTypeEntity>(
      context: context,
      builder: (_) => const _TypeSheet(),
    );
    if (type == null || !context.mounted) return;

    try {
      await ref
          .read(leaveRepositoryProvider)
          .add(from: range.start, to: range.end, type: type);
      _refresh(ref);
      if (context.mounted) {
        UIHelpers.showSuccessSnackBar(context, 'سُجّلت الإجازة');
      }
    } catch (error) {
      if (context.mounted) {
        UIHelpers.showErrorSnackBar(context, 'تعذّر التسجيل: $error');
      }
    }
  }

  static void _refresh(WidgetRef ref) {
    ref.invalidate(leaveBalancesProvider);
    ref.invalidate(monthLeavesProvider);
    ref.invalidate(attendanceStatsProvider);
  }
}

class _NoBalances extends StatelessWidget {
  const _NoBalances();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Icon(Icons.info_outline_rounded,
                size: AppIconSize.md, color: palette.onSurfaceVariant),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'لم تُحدَّد أرصدة لهذه الجهة — تُضبط من «تعديل الجهة».',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceTile extends StatelessWidget {
  const _BalanceTile({required this.balance});

  final LeaveBalanceEntity balance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final ratio = balance.allowance <= 0
        ? 0.0
        : (balance.used / balance.allowance).clamp(0.0, 1.0);

    return Card(
      margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(balance.type.label,
                      style: theme.textTheme.titleSmall),
                ),
                Text(
                  balance.allowance > 0
                      ? '${balance.used} من ${balance.allowance}'
                      : '${balance.used} يوم',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: balance.isOverdrawn
                        ? palette.negative
                        : palette.onSurface,
                  ),
                ),
              ],
            ),
            if (balance.allowance > 0) ...[
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: LinearProgressIndicator(
                  value: ratio,
                  minHeight: 6,
                  backgroundColor: palette.outline,
                  color:
                      balance.isOverdrawn ? palette.negative : palette.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                balance.isOverdrawn
                    ? 'تجاوزت الرصيد بـ ${-balance.remaining} يوم'
                    : 'المتبقي ${balance.remaining} يوم',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: balance.isOverdrawn
                      ? palette.negative
                      : palette.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LeaveList extends ConsumerWidget {
  const _LeaveList({required this.year});

  final int year;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leavesAsync = ref.watch(allLeavesProvider(year: year));

    return StateSwitcher(
      value: leavesAsync,
      skeletonHeight: 120,
      onRetry: () => ref.invalidate(allLeavesProvider),
      builder: (leaves) {
        if (leaves.isEmpty) {
          return const EmptyState(
            icon: Icons.beach_access_rounded,
            title: 'لا إجازات مسجّلة',
            message: 'سجّل إجازتك لتُستثنى أيامها من الحضور والخصم.',
          );
        }
        return Column(
          children: [
            for (final leave in leaves)
              Card(
                margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.md),
                child: ListTile(
                  title: Text(leave.type.label),
                  subtitle: Text(
                    '${DateHelpers.formatShortDate(leave.from)} — '
                    '${DateHelpers.formatShortDate(leave.to)} '
                    '(${leave.days} يوم)',
                  ),
                  trailing: IconButton(
                    tooltip: 'حذف',
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => _delete(context, ref, leave),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _delete(
      BuildContext context, WidgetRef ref, LeaveEntity leave) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الإجازة'),
        content: Text('ستعود أيام ${leave.type.label} إلى الحساب العادي.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('حذف')),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(leaveRepositoryProvider).delete(leave.id);
      ref.invalidate(leaveBalancesProvider);
      ref.invalidate(allLeavesProvider);
      ref.invalidate(monthLeavesProvider);
      ref.invalidate(attendanceStatsProvider);
    } catch (error) {
      if (context.mounted) UIHelpers.showErrorSnackBar(context, '$error');
    }
  }
}

class _TypeSheet extends StatelessWidget {
  const _TypeSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final type in LeaveTypeEntity.values)
            ListTile(
              title: Text(type.label),
              subtitle: Text(type.isPaid ? 'مدفوعة' : 'تُخصم من الراتب'),
              onTap: () => Navigator.pop(context, type),
            ),
        ],
      ),
    );
  }
}
