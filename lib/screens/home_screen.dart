import 'package:flutter/material.dart';

import '../core/stock_colors.dart';
import '../database/app_database.dart';
import '../models/category_filter.dart';
import '../models/product_item.dart';
import '../widgets/home/category_filter_list.dart';
import '../widgets/home/product_card.dart';
import '../widgets/home/stock_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.database, super.key});

  final AppDatabase database;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            StockHeader(
              stockMetricsStream: widget.database.watchStockMetrics(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: StreamBuilder<List<Category>>(
                stream: widget.database.watchCategories(),
                builder: (context, snapshot) {
                  final categories = snapshot.data ?? const <Category>[];

                  return CategoryFilterList(
                    selectedCategoryId: _selectedCategoryId,
                    onCategorySelected: (categoryId) {
                      setState(() {
                        _selectedCategoryId = categoryId;
                      });
                    },
                    categories: [
                      const CategoryFilter(
                        id: null,
                        name: 'All',
                        icon: null,
                      ),
                      ...categories.map(
                        (category) => CategoryFilter(
                          id: category.id,
                          name: category.name,
                          icon: category.icon,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<List<ProductWithCategory>>(
                stream: widget.database.watchProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final productRows =
                      snapshot.data ?? const <ProductWithCategory>[];
                  final products = productRows
                      .where((productRow) {
                        final selectedCategoryId = _selectedCategoryId;

                        return selectedCategoryId == null ||
                            productRow.category.id == selectedCategoryId;
                      })
                      .map(ProductItem.fromDatabase)
                      .toList();

                  if (products.isEmpty) {
                    return _EmptyProducts(
                      hasCategoryFilter: _selectedCategoryId != null,
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ProductCard(product: products[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts({required this.hasCategoryFilter});

  final bool hasCategoryFilter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        hasCategoryFilter
            ? 'No products in this category yet.'
            : 'No products yet. Tap Add to create one.',
        style: const TextStyle(
          color: StockColors.muted,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
