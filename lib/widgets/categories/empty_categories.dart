import 'package:flutter/material.dart';

import '../../core/stock_colors.dart';

class EmptyCategories extends StatelessWidget {
  const EmptyCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(
          Icons.category_outlined,
          size: 40,
          color: Color(0xFFA5B0CC),
        ),
        SizedBox(height: 12),
        Text(
          'No categories yet.',
          style: TextStyle(
            color: StockColors.muted,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Tap Add New Category to create your first one.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF8E98B3),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
