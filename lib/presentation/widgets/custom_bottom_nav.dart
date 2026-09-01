import 'package:flutter/material.dart';

import '../../core/constants/design_tokens.dart';

/// شريط التنقل السفلي. يطفو فوق المحتوى بحوافّ دائرية بدل الالتصاق بالحافة.
class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _destinations = <_NavItem>[
    _NavItem(Icons.dashboard_outlined, Icons.dashboard_rounded, 'الرئيسية'),
    _NavItem(Icons.access_time_outlined, Icons.access_time_filled_rounded, 'الدوام'),
    _NavItem(Icons.handshake_outlined, Icons.handshake_rounded, 'الديون'),
    _NavItem(Icons.account_balance_outlined, Icons.account_balance_rounded, 'الحسابات'),
    _NavItem(Icons.person_outline_rounded, Icons.person_rounded, 'الملف'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    return Container(
      margin: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 12),
      // الارتفاع مُعلن بالظل وحده — حدّ تحت ظل عريض يصنع "بطاقة الشبح".
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppElevation.floating(palette),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onTap,
          backgroundColor: Colors.transparent,
          destinations: [
            for (final item in _destinations)
              NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.selectedIcon),
                label: item.label,
                tooltip: item.label,
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.selectedIcon, this.label);

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
