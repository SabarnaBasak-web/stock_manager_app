import 'package:flutter/material.dart';

import '../../core/stock_colors.dart';

class StockBottomNavigationBar extends StatelessWidget {
  const StockBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.white,
          selectedItemColor: StockColors.primary,
          unselectedItemColor: const Color(0xFF97A0B8),
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
          onTap: onTap,
          items: [
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.home_rounded,
                isSelected: currentIndex == 0,
              ),
              label: 'Home',
            ),
            const BottomNavigationBarItem(icon: _AddNavIcon(), label: 'Add'),
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.category_outlined,
                isSelected: currentIndex == 2,
              ),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: _NavIcon(
                icon: Icons.settings_outlined,
                isSelected: currentIndex == 3,
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.icon, required this.isSelected});

  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFECEFFF) : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(icon),
    );
  }
}

class _AddNavIcon extends StatelessWidget {
  const _AddNavIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF1F49B7),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F49B7).withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
    );
  }
}
