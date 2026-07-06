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
    required this.onDelete,
    required this.onDeleteProduct,
    super.key,
  });

  final CategoryWithProducts categoryGroup;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final ValueChanged<ProductItem> onDeleteProduct;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final category = categoryGroup.category;
    final productCount = categoryGroup.totalProducts;
    final inStockCount = categoryGroup.inStockProducts;
    final accentColor = StockColors.fromHex(category.colorHex);
    final productItems = categoryGroup.products
        .map(ProductItem.fromDatabase)
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDarkTheme
              ? colorScheme.outlineVariant
              : const Color(0xFFDCE2F1),
        ),
        boxShadow: [
          if (!isDarkTheme)
            BoxShadow(
              color: const Color(0xFF1B2444).withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onToggle,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                    child: Row(
                      children: [
                        _CategoryIcon(
                          icon: category.icon,
                          accentColor: accentColor,
                        ),
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
                                  color: Color(0xFF101A42),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
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
                        const SizedBox(width: 10),
                        _StockProgress(
                          total: productCount,
                          inStock: inStockCount,
                          accentColor: accentColor,
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_down_rounded
                              : Icons.chevron_right_rounded,
                          color: const Color(0xFF6C78A0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 72,
                color: isDarkTheme
                    ? colorScheme.outlineVariant
                    : const Color(0xFFDCE2F1),
              ),
              SizedBox(
                width: 56,
                child: IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: StockColors.red,
                  ),
                ),
              ),
            ],
          ),
          if (isExpanded) ...[
            Divider(
              height: 1,
              color: isDarkTheme
                  ? colorScheme.outlineVariant
                  : const Color(0xFFE5E8F1),
            ),
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
                        child: ProductCard(
                          product: product,
                          onRemove: () => onDeleteProduct(product),
                        ),
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
  const _CategoryIcon({required this.icon, required this.accentColor});

  final String icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.10),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(icon, style: const TextStyle(fontSize: 20)),
    );
  }
}

class _StockProgress extends StatelessWidget {
  const _StockProgress({
    required this.total,
    required this.inStock,
    required this.accentColor,
  });

  final int total;
  final int inStock;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : inStock / total;

    return SizedBox(
      width: 48,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: LinearProgressIndicator(
          minHeight: 5,
          value: progress,
          backgroundColor: const Color(0xFFE2E6EF),
          valueColor: AlwaysStoppedAnimation<Color>(accentColor),
        ),
      ),
    );
  }
}
