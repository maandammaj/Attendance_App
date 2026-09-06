import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../../core/constants/theme.dart';
import '../../../../domain/entities/account_entity.dart';
import '../../../widgets/common/amount_indicator.dart';

/// موقف الحسابات: ما لك، وما عليك، ثم الصافي.
///
/// الشاشة كانت قائمة بلا رأس — فيُفتح التبويب ولا يُعرف منه الموقف العام
/// إلا بجمع الأرصدة ذهنياً. نفس بنية ملخّص الديون قصداً.
class AccountsSummaryCard extends StatelessWidget {
  const AccountsSummaryCard({
    super.key,
    required this.accounts,
    required this.currency,
  });

  final List<AccountEntity> accounts;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    var receivable = 0.0;
    var payable = 0.0;
    for (final account in accounts) {
      if (account.totalBalance >= 0) {
        receivable += account.totalBalance;
      } else {
        payable += -account.totalBalance;
      }
    }
    final net = receivable - payable;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: palette.outline),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AmountIndicator(
                  label: 'لك',
                  amount: receivable,
                  color: palette.positive,
                  icon: Icons.south_west_rounded,
                  currency: currency,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AmountIndicator(
                  label: 'عليك',
                  amount: payable,
                  color: palette.negative,
                  icon: Icons.north_east_rounded,
                  currency: currency,
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: Text('الموقف الصافي', style: theme.textTheme.bodyMedium),
              ),
              Text(
                '${net.toStringAsFixed(0)} $currency',
                style: theme.textTheme.titleMedium
                    ?.copyWith(
                        color: net >= 0 ? palette.positive : palette.negative)
                    .merge(tabularFigures),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
