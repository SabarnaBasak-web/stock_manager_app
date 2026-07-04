import 'package:flutter/material.dart';

import '../core/stock_colors.dart';
import '../database/app_database.dart';
import '../widgets/categories/category_group_card.dart';
import '../widgets/categories/category_metric_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({required this.database, super.key});

  final AppDatabase database;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _expandedCategoryIds = <int>{};
  bool _hasToggledCategory = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StockColors.scaffold,
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
                  child: categoryGroups.isEmpty
                      ? const _EmptyCategories()
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
                          itemCount: categoryGroups.length,
                          separatorBuilder: (_, _) {
                            return const SizedBox(height: 12);
                          },
                          itemBuilder: (context, index) {
                            final categoryGroup = categoryGroups[index];
                            final categoryId = categoryGroup.category.id;
                            final isExpanded =
                                _expandedCategoryIds.contains(categoryId) ||
                                (!_hasToggledCategory && index == 0);

                            return CategoryGroupCard(
                              categoryGroup: categoryGroup,
                              isExpanded: isExpanded,
                              onToggle: () {
                                setState(() {
                                  _hasToggledCategory = true;

                                  if (isExpanded) {
                                    _expandedCategoryIds.remove(categoryId);
                                  } else {
                                    _expandedCategoryIds.add(categoryId);
                                  }
                                });
                              },
                            );
                          },
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

class _EmptyCategories extends StatelessWidget {
  const _EmptyCategories();

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
