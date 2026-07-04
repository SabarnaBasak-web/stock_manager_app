import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../widgets/home/stock_bottom_navigation_bar.dart';
import 'add_product_screen.dart';
import 'categories_screen.dart';
import 'home_screen.dart';
import 'settings_screen.dart';

class StockShell extends StatefulWidget {
  const StockShell({
    required this.database,
    required this.isDarkMode,
    required this.onDarkModeChanged,
    super.key,
  });

  final AppDatabase database;
  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  State<StockShell> createState() => _StockShellState();
}

class _StockShellState extends State<StockShell> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.database.seedDefaultCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(database: widget.database),
          AddProductScreen(database: widget.database),
          CategoriesScreen(database: widget.database),
          SettingsScreen(
            isDarkMode: widget.isDarkMode,
            onDarkModeChanged: widget.onDarkModeChanged,
          ),
        ],
      ),
      bottomNavigationBar: StockBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
