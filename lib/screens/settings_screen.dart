import 'package:flutter/material.dart';

import '../core/stock_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.isDarkMode,
    required this.onDarkModeChanged,
    super.key,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _SettingsHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
                children: [
                  _AppearanceCard(
                    isDarkMode: isDarkMode,
                    onDarkModeChanged: onDarkModeChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 34, 20, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [StockColors.primary, StockColors.primaryLight],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PREFERENCES',
            style: TextStyle(
              color: Color(0xFFBFC9FF),
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppearanceCard extends StatelessWidget {
  const _AppearanceCard({
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkTheme
              ? colorScheme.outlineVariant
              : const Color(0xFFE5E8F1),
        ),
        boxShadow: [
          if (!isDarkTheme)
            BoxShadow(
              color: const Color(0xFF1B2444).withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'APPEARANCE',
            style: TextStyle(
              color: Color(0xFF667096),
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0ECFF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.dark_mode_outlined,
                  color: StockColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Switch interface theme',
                      style: TextStyle(
                        color: StockColors.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: isDarkMode,
                activeThumbColor: Colors.white,
                activeTrackColor: StockColors.primary,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFB7C1CA),
                onChanged: onDarkModeChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
