import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../widgets/home/stock_bottom_navigation_bar.dart';
import 'add_product_screen.dart';
import 'categories_screen.dart';
import 'home_screen.dart';

class StockShell extends StatefulWidget {
  const StockShell({required this.database, super.key});

  final AppDatabase database;

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
          const _ComingSoonScreen(title: 'Settings'),
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

class _ComingSoonScreen extends StatelessWidget {
  const _ComingSoonScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            '$title screen coming soon',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
