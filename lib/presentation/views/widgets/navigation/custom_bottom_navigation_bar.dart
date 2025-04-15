
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../configurations/strings.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 1; //Home must be default

  final List<Map<String, dynamic>> navData = [
    {
      'icon': Icons.supervisor_account_outlined,
      'label': Strings.friends,
    },
    {
      'icon': Icons.home,
      'label': Strings.home,
    },
    {
      'icon': Icons.message_outlined,
      'label': Strings.chats,
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

  //On taped use router
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    GoRouter.of(context).goNamed(navData[index]['label']);
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