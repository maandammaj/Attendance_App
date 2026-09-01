import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'الرئيسية'),
        NavigationDestination(icon: Icon(Icons.calendar_month), label: 'الحضور'),
        NavigationDestination(icon: Icon(Icons.wallet), label: 'الميزانية'),
        NavigationDestination(icon: Icon(Icons.account_balance), label: 'الحسابات'),
        NavigationDestination(icon: Icon(Icons.person), label: 'الملف'),
      ],
    );
  }
}