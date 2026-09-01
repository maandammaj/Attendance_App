import 'package:flutter/material.dart';
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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isDebt ? Colors.red.shade100 : Colors.green.shade100,
          child: Icon(
            isDebt ? Icons.arrow_upward : Icons.arrow_downward,
            color: isDebt ? Colors.red : Colors.green,
          ),
        ),
        title: Text(title),
        subtitle: Text(DateFormat('yyyy/MM/dd').format(date)),
        trailing: Text(
          '${amount.toStringAsFixed(2)} $currency',
          style: TextStyle(
            color: isDebt ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
