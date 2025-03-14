import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../configurations/strings.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> navData = [
    {
      'icon': Icons.settings,
      'label': Strings.menu,
    },
    {
      'icon': Icons.home,
      'label': Strings.home,
    },
    {
      'icon': Icons.calendar_month_rounded,
      'label': Strings.calendar,
    },
  ];

  List<BottomNavigationBarItem> _generateNavItems(BuildContext context, ThemeData theme) {
    return navData.map((data) {
      return BottomNavigationBarItem(
        icon: Icon(data['icon'] as IconData, color: theme.iconTheme.color),
        label: data['label'] as String,
      );
    }).toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BottomNavigationBar(
      items: _generateNavItems(context, theme),
      currentIndex: _selectedIndex,
      selectedItemColor: theme.colorScheme.primary,
      selectedIconTheme: theme.iconTheme.copyWith(size: 35),
      selectedFontSize: theme.textTheme.bodySmall?.fontSize ?? 20,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      onTap: _onItemTapped,
    );
  }
}