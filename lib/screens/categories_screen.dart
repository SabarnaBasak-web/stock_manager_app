import 'package:flutter/material.dart';

import '../core/stock_colors.dart';
import '../database/app_database.dart';
import '../models/product_item.dart';
import '../widgets/categories/add_category_sheet.dart';
import '../widgets/categories/category_group_card.dart';
import '../widgets/categories/category_metric_card.dart';
import '../widgets/categories/empty_categories.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({required this.database, super.key});

  final AppDatabase database;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _expandedCategoryIds = <int>{};

  Future<void> _showAddCategorySheet() async {
    final result = await showAddCategorySheet(context);

    if (result == null) return;

    try {
      await widget.database.addCategory(
        name: result.name,
        icon: result.icon,
        colorHex: result.colorHex,
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not add category. Please try again.')),
      );
      return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${result.name} category added.')),
    );
  }

  Future<void> _deleteCategory(Category category) async {
    final wasDeleted = await widget.database.deleteCategory(category.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasDeleted
              ? '${category.name} category deleted.'
              : 'Remove products from ${category.name} before deleting it.',
        ),
      ),
    );
  }

  Future<void> _deleteProduct(ProductItem product) async {
    await widget.database.deleteProduct(product.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.name} deleted.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: StreamBuilder<List<CategoryWithProducts>>(
          stream: widget.database.watchCategoriesWithProducts(),
          builder: (context, snapshot) {
            final categoryGroups =
                snapshot.data ?? const <CategoryWithProducts>[];
            final totalProducts = categoryGroups.fold<int>(
              0,
              (total, categoryGroup) => total + categoryGroup.totalProducts,
            );
            final totalInStock = categoryGroups.fold<int>(
              0,
              (total, categoryGroup) => total + categoryGroup.inStockProducts,
            );

            return Column(
              children: [
                _CategoriesHeader(
                  categoryCount: categoryGroups.length,
                  productCount: totalProducts,
                  inStockCount: totalInStock,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
                    children: [
                      _AddCategoryButton(onTap: _showAddCategorySheet),
                      const SizedBox(height: 14),
                      if (categoryGroups.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 36),
                          child: EmptyCategories(),
                        )
                      else
                        for (final categoryGroup in categoryGroups) ...[
                          CategoryGroupCard(
                            categoryGroup: categoryGroup,
                            isExpanded: _expandedCategoryIds.contains(
                              categoryGroup.category.id,
                            ),
                            onToggle: () {
                              final categoryId = categoryGroup.category.id;

                              setState(() {
                                if (_expandedCategoryIds.contains(categoryId)) {
                                  _expandedCategoryIds.remove(categoryId);
                                } else {
                                  _expandedCategoryIds.add(categoryId);
                                }
                              });
                            },
                            onDelete: () =>
                                _deleteCategory(categoryGroup.category),
                            onDeleteProduct: _deleteProduct,
                          ),
                          const SizedBox(height: 12),
                        ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CategoriesHeader extends StatelessWidget {
  const _CategoriesHeader({
    required this.categoryCount,
    required this.productCount,
    required this.inStockCount,
  });

  final int categoryCount;
  final int productCount;
  final int inStockCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 34, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [StockColors.primary, StockColors.primaryLight],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BROWSE',
            style: TextStyle(
              color: Color(0xFFBFC9FF),
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Categories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: CategoryMetricCard(
                  value: categoryCount.toString(),
                  label: 'Categories',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CategoryMetricCard(
                  value: productCount.toString(),
                  label: 'Products',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CategoryMetricCard(
                  value: inStockCount.toString(),
                  label: 'In Stock',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddCategoryButton extends StatelessWidget {
  const _AddCategoryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: CustomPaint(
          foregroundPainter: _DashedRoundedRectPainter(
            color: const Color(0xFFBFC9E8),
            radius: 18,
          ),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFFE6E8F8),
                  child: Icon(
                    Icons.add_rounded,
                    color: StockColors.primary,
                    size: 18,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Add New Category',
                  style: TextStyle(
                    color: StockColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedRoundedRectPainter extends CustomPainter {
  const _DashedRoundedRectPainter({
    required this.color,
    required this.radius,
  });

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rect);
    final dashedPath = Path();

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dashWidth = 7.0;
      const dashSpace = 5.0;

      while (distance < metric.length) {
        dashedPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedRectPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
