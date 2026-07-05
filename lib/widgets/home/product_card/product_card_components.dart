import 'package:flutter/material.dart';

import '../../../core/stock_colors.dart';
import '../../../models/product_item.dart';

class ProductTitleSection extends StatelessWidget {
  const ProductTitleSection({
    required this.product,
    required this.isOutOfStock,
    super.key,
  });

  final ProductItem product;
  final bool isOutOfStock;

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

class ProductMetaRow extends StatelessWidget {
  const ProductMetaRow({
    required this.product,
    required this.isOutOfStock,
    super.key,
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

class ProductIconAvatar extends StatelessWidget {
  const ProductIconAvatar({required this.icon, super.key});

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

class RoundActionButton extends StatelessWidget {
  const RoundActionButton({
    required this.icon,
    required this.tooltip,
    required this.backgroundColor,
    required this.iconColor,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final resolvedBackgroundColor = isEnabled
        ? backgroundColor
        : backgroundColor.withValues(alpha: 0.45);
    final resolvedIconColor = isEnabled
        ? iconColor
        : iconColor.withValues(alpha: 0.45);

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
              color: resolvedBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: resolvedIconColor, size: 19),
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
