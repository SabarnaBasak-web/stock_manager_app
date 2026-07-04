import 'package:flutter/material.dart';

import '../../core/stock_colors.dart';
import '../../models/product_item.dart';

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
    final onDelete = this.onDelete;

    return Container(
      height: 98,
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
          Container(width: 4, color: StockColors.green),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 13, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProductIcon(icon: product.icon),
                      const SizedBox(width: 10),
                      Expanded(child: _ProductTitle(product: product)),
                      if (onIncrement != null) ...[
                        _RoundActionButton(
                          icon: Icons.add_rounded,
                          tooltip: 'Increase quantity',
                          backgroundColor: const Color(0xFFEFF8EF),
                          iconColor: StockColors.green,
                          onPressed: onIncrement,
                        ),
                        const SizedBox(width: 10),
                      ],
                      if (onDelete != null)
                        _RoundActionButton(
                          icon: Icons.delete_outline_rounded,
                          tooltip: 'Decrease quantity',
                          backgroundColor: const Color(0xFFFFF0F0),
                          iconColor: StockColors.red,
                          onPressed: onDelete,
                        ),
                    ],
                  ),
                  const Spacer(),
                  _ProductMetaRow(
                    product: product,
                    isOutOfStock: isOutOfStock,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductTitle extends StatelessWidget {
  const _ProductTitle({required this.product});

  final ProductItem product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          product.category,
          style: const TextStyle(
            color: StockColors.muted,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ProductMetaRow extends StatelessWidget {
  const _ProductMetaRow({
    required this.product,
    required this.isOutOfStock,
  });

  final ProductItem product;
  final bool isOutOfStock;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatusBadge(isOutOfStock: isOutOfStock),
        const _DividerLine(),
        const Icon(
          Icons.inventory_2_outlined,
          size: 13,
          color: StockColors.muted,
        ),
        const SizedBox(width: 5),
        Text(
          '${product.quantity} units',
          style: const TextStyle(
            color: Color(0xFF2C3456),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        const _DividerLine(),
        const Icon(
          Icons.calendar_today_outlined,
          size: 13,
          color: StockColors.muted,
        ),
        const SizedBox(width: 6),
        _ExpiryBadge(product: product),
      ],
    );
  }
}

class _ProductIcon extends StatelessWidget {
  const _ProductIcon({required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      width: 38,
      decoration: const BoxDecoration(
        color: Color(0xFFF0F7EF),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(icon, style: const TextStyle(fontSize: 18)),
    );
  }
}

class _RoundActionButton extends StatelessWidget {
  const _RoundActionButton({
    required this.icon,
    required this.tooltip,
    required this.backgroundColor,
    required this.iconColor,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkResponse(
          onTap: onPressed,
          radius: 18,
          customBorder: const CircleBorder(),
          child: Container(
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 19),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isOutOfStock});

  final bool isOutOfStock;

  @override
  Widget build(BuildContext context) {
    final color = isOutOfStock ? StockColors.red : StockColors.green;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 17,
          width: 17,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isOutOfStock ? Icons.close_rounded : Icons.check_rounded,
            color: color,
            size: 12,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          isOutOfStock ? 'Out of Stock' : 'In Stock',
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _ExpiryBadge extends StatelessWidget {
  const _ExpiryBadge({required this.product});

  final ProductItem product;

  @override
  Widget build(BuildContext context) {
    final colors = switch (product.expiryLevel) {
      ExpiryLevel.danger => (
        foreground: StockColors.red,
        background: const Color(0xFFFFF1F1),
        border: const Color(0xFFFFD2D2),
      ),
      ExpiryLevel.warning => (
        foreground: const Color(0xFFFF9800),
        background: const Color(0xFFFFF9E7),
        border: const Color(0xFFFFE3A4),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border),
      ),
      child: Text(
        product.expiryText,
        style: TextStyle(
          color: colors.foreground,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 9),
      color: const Color(0xFFD7DCEB),
    );
  }
}
