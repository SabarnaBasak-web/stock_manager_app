import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'database/app_database.dart';
import 'screens/stock_shell.dart';

void main() {
  runApp(const StockManagerApp());
}

class StockManagerApp extends StatefulWidget {
  const StockManagerApp({super.key});

  @override
  State<StockManagerApp> createState() => _StockManagerAppState();
}

class _StockManagerAppState extends State<StockManagerApp> {
  late final AppDatabase _database;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
  }

  @override
  void dispose() {
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF26379B)),
        textTheme: GoogleFonts.nunitoSansTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFF4F6FB),
      ),
      home: StockShell(database: _database),
    );
  }
}
