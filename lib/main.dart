import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'database/app_database.dart';
import 'screens/stock_shell.dart';
import 'services/theme_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isDarkMode = await ThemePreferences.loadDarkMode();

  runApp(StockManagerApp(initialDarkMode: isDarkMode));
}

class StockManagerApp extends StatefulWidget {
  const StockManagerApp({required this.initialDarkMode, super.key});

  final bool initialDarkMode;

  @override
  State<StockManagerApp> createState() => _StockManagerAppState();
}

class _StockManagerAppState extends State<StockManagerApp> {
  late final AppDatabase _database;
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _isDarkMode = widget.initialDarkMode;
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
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF26379B),
          brightness: Brightness.dark,
        ),
        textTheme: GoogleFonts.nunitoSansTextTheme(ThemeData.dark().textTheme),
        scaffoldBackgroundColor: const Color(0xFF111827),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: StockShell(
        database: _database,
        isDarkMode: _isDarkMode,
        onDarkModeChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
          unawaited(ThemePreferences.saveDarkMode(value));
        },
      ),
    );
  }
}
