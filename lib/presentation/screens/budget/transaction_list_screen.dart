import 'package:flutter/material.dart';
import '../../../core/constants/design_tokens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/common/empty_state.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final now = DateTime.now();
    final transactions = ref.watch(monthlyTransactionsProvider(year: now.year, month: now.month));
    final currency = ref.watch(profileProvider).value?.currency ?? 'ر.ي';

    return Scaffold(
      appBar: AppBar(title: const Text('سجل المصاريف والدخل'), centerTitle: true),
      body: transactions.when(
        data: (list) {
          if (list.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_rounded,
              title: 'لا حركات هذا الشهر',
              message: 'كل دخل أو مصروف تسجّله يظهر هنا مرتّباً بتاريخه.',
            );
          }
          return ListView.builder(
            itemCount: list.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final trans = list[index];
              final isExpense = trans.type.name == 'expense';
              return Card(
                child: ListTile(
                  leading: Icon(isExpense ? Icons.remove_circle : Icons.add_circle, 
                      color: isExpense ? palette.negative : palette.positive),
                  title: Text(trans.categoryName),
                  subtitle: Text(DateFormat('yyyy/MM/dd HH:mm').format(trans.date)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${trans.amount.toStringAsFixed(2)} $currency', 
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
              tooltip: 'حذف',
                        icon: Icon(Icons.delete, color: palette.onSurfaceVariant, size: 20),
                        onPressed: () => _confirmDelete(context, ref, trans.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('خطأ: $err')),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int id) {
  final palette = context.palette;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الحركة'),
        content: const Text('هل أنت متأكد من حذف هذه الحركة المالية؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          TextButton(
            onPressed: () async {
              await ref.read(transactionControllerProvider.notifier).deleteTransaction(id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text('حذف', style: TextStyle(color: palette.negative)),
          ),
        ],
      ),
    );
  }
}
