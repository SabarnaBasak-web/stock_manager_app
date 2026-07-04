import 'package:flutter/material.dart';

import '../../core/stock_colors.dart';
import '../../models/category_filter.dart';

class CategoryFilterList extends StatelessWidget {
  const CategoryFilterList({
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    super.key,
  });

  final List<CategoryFilter> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.id == selectedCategoryId;

          return GestureDetector(
            onTap: () => onCategorySelected(category.id),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected ? StockColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? StockColors.primary
                      : const Color(0xFFE3E7F2),
                ),
                boxShadow: [
                  if (!isSelected)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  if (category.icon != null) ...[
                    Text(category.icon!, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    category.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : StockColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
