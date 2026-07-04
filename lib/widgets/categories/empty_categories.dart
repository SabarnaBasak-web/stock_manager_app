import 'package:flutter/material.dart';

import '../../core/stock_colors.dart';

class EmptyCategories extends StatelessWidget {
  const EmptyCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No categories yet.',
        style: TextStyle(
          color: StockColors.muted,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
