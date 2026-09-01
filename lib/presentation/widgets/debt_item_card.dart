import 'package:flutter/material.dart';
import '../../core/constants/design_tokens.dart';
import 'package:intl/intl.dart';

class DebtItemCard extends StatelessWidget {
  final String title;
  final double amount;
  final bool isDebt;
  final DateTime date;
  final String currency;

  const DebtItemCard({
    super.key,
    required this.title,
    required this.amount,
    required this.isDebt,
    required this.date,
    this.currency = 'ر.ي',
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isDebt ? palette.negative.withValues(alpha: 0.12) : palette.positive.withValues(alpha: 0.12),
          child: Icon(
            isDebt ? Icons.arrow_upward : Icons.arrow_downward,
            color: isDebt ? palette.negative : palette.positive,
          ),
        ),
        title: Text(title),
        subtitle: Text(DateFormat('yyyy/MM/dd').format(date)),
        trailing: Text(
          '${amount.toStringAsFixed(2)} $currency',
          style: TextStyle(
            color: isDebt ? palette.negative : palette.positive,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
