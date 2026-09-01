import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/profile_provider.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final transactions = ref.watch(monthlyTransactionsProvider(year: now.year, month: now.month));
    final currency = ref.watch(profileProvider).valueOrNull?.currency ?? 'ر.ي';

    return Scaffold(
      appBar: AppBar(title: const Text('سجل المصاريف والدخل'), centerTitle: true),
      body: transactions.when(
        data: (list) {
          if (list.isEmpty) return const Center(child: Text('لا توجد حركات مالية هذا هذا الشهر'));
          return ListView.builder(
            itemCount: list.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final trans = list[index];
              final isExpense = trans.type.name == 'expense';
              return Card(
                child: ListTile(
                  leading: Icon(isExpense ? Icons.remove_circle : Icons.add_circle, 
                      color: isExpense ? Colors.red : Colors.green),
                  title: Text(trans.categoryName),
                  subtitle: Text(DateFormat('yyyy/MM/dd HH:mm').format(trans.date)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${trans.amount.toStringAsFixed(2)} $currency', 
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
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
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
