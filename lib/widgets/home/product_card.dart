import 'package:flutter/material.dart';

import '../../core/stock_colors.dart';
import '../../models/product_item.dart';
import 'product_card/product_card_components.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    this.onIncrement,
    this.onDelete,
    super.key,
  });

  final ProductItem product;
  final VoidCallback? onIncrement;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final isOutOfStock = product.status == ProductStatus.outOfStock;
    final onIncrement = this.onIncrement;
    final showDecrementButton = this.onDelete != null;
    final onDelete = product.quantity > 0 ? this.onDelete : null;

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkTheme
              ? colorScheme.outlineVariant
              : const Color(0xFFE7EAF2),
        ),
        boxShadow: [
          if (!isDarkTheme)
            BoxShadow(
              color: const Color(0xFF1B2444).withValues(alpha: 0.10),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Container(
            width: 4,
            color: isOutOfStock ? StockColors.red : StockColors.green,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 13, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductIconAvatar(icon: product.icon),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ProductTitleSection(
                          product: product,
                          isOutOfStock: isOutOfStock,
                        ),
                      ),
                      if (onIncrement != null) ...[
                        RoundActionButton(
                          icon: Icons.add_rounded,
                          tooltip: 'Increase quantity',
                          backgroundColor: const Color(0xFFEFF8EF),
                          iconColor: StockColors.green,
                          onPressed: onIncrement,
                        ),
                        const SizedBox(width: 10),
                      ],
                      if (showDecrementButton)
                        RoundActionButton(
                          icon: Icons.delete_outline_rounded,
                          tooltip: product.quantity == 0
                              ? 'Quantity is already 0'
                              : 'Decrease quantity',
                          backgroundColor: const Color(0xFFFFF0F0),
                          iconColor: StockColors.red,
                          onPressed: onDelete,
                        ),
                    ],
                  ),
                  const Spacer(),
                  ProductMetaRow(product: product, isOutOfStock: isOutOfStock),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
