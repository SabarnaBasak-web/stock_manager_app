import 'package:flutter/material.dart';

import '../../core/stock_colors.dart';
import '../../database/app_database.dart';
import '../../models/product_item.dart';
import '../home/product_card.dart';

class CategoryGroupCard extends StatelessWidget {
  const CategoryGroupCard({
    required this.categoryGroup,
    required this.isExpanded,
    required this.onToggle,
    super.key,
  });

  final CategoryWithProducts categoryGroup;
  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final category = categoryGroup.category;
    final productCount = categoryGroup.totalProducts;
    final inStockCount = categoryGroup.inStockProducts;
    final productItems = categoryGroup.products
        .map(ProductItem.fromDatabase)
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E8F1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B2444).withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
              child: Row(
                children: [
                  _CategoryIcon(icon: category.icon),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF0E1630),
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$productCount products · $inStockCount in stock',
                          style: const TextStyle(
                            color: StockColors.muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _StockProgress(
                    total: productCount,
                    inStock: inStockCount,
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: StockColors.muted,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            const Divider(height: 1, color: Color(0xFFE5E8F1)),
            if (productItems.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No products in this category yet.',
                  style: TextStyle(
                    color: StockColors.muted,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Column(
                  children: [
                    for (final product in productItems)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ProductCard(product: product),
                      ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: const BoxDecoration(
        color: Color(0xFFF0F7EF),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(icon, style: const TextStyle(fontSize: 20)),
    );
  }
}

class _StockProgress extends StatelessWidget {
  const _StockProgress({required this.total, required this.inStock});

  final int total;
  final int inStock;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : inStock / total;

    return SizedBox(
      width: 56,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: LinearProgressIndicator(
          minHeight: 5,
          value: progress,
          backgroundColor: const Color(0xFFE2E6EF),
          valueColor: const AlwaysStoppedAnimation<Color>(StockColors.green),
        ),
      ),
    );
  }
}
