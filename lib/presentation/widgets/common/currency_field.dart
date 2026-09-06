import 'package:flutter/material.dart';

import '../../../core/constants/currencies.dart';

/// منتقي العملة — المصدر الوحيد لقائمة العملات في كل الشاشات.
///
/// كانت ثلاث قوائم متباينة، فقيمة مختارة في شاشة لا يجدها منتقي شاشة أخرى
/// فيسقط بخطأ تأكيد. القيمة المتداولة هنا هي [AppCurrency.code] دائماً،
/// والمعروض هو الاسم الكامل بالعربية.
class CurrencyField extends StatelessWidget {
  const CurrencyField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'العملة',
  });

  /// أي كتابة مخزّنة — تُطبَّع إلى رمزها فلا تنكسر المطابقة مع العناصر.
  final String? value;
  final ValueChanged<String> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: AppCurrency.codeOf(value),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.payments_outlined),
      ),
      isExpanded: true,
      items: [
        for (final currency in AppCurrency.all)
          DropdownMenuItem(
            value: currency.code,
            child: Text(currency.fullName, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (code) {
        if (code != null) onChanged(code);
      },
    );
  }
}
