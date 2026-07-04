import 'package:flutter/material.dart';

import '../../core/stock_colors.dart';

class EmptyProducts extends StatelessWidget {
  const EmptyProducts({
    required this.hasCategoryFilter,
    required this.hasSearchQuery,
    super.key,
  });

  final bool hasCategoryFilter;
  final bool hasSearchQuery;

  String get _message {
    if (hasSearchQuery) {
      return 'No products match your search.';
    }

    if (hasCategoryFilter) {
      return 'No products in this category yet.';
    }

    return 'No products yet. Tap Add to create one.';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _message,
        style: const TextStyle(
          color: StockColors.muted,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
