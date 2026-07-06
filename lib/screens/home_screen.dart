import 'dart:async';

import 'package:flutter/material.dart';

import '../database/app_database.dart';
import '../models/category_filter.dart';
import '../models/product_item.dart';
import '../widgets/home/category_filter_list.dart';
import '../widgets/home/empty_products.dart';
import '../widgets/home/edit_product_sheet.dart';
import '../widgets/home/product_card.dart';
import '../widgets/home/stock_header.dart';

enum _HomeMetricFilter { products, outOfStock, expiringSoon }

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.database, super.key});

  final AppDatabase database;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _searchDebounceDuration = Duration(milliseconds: 300);
  static const _expiringSoonDuration = Duration(days: 30);

  final _searchController = TextEditingController();
  Timer? _searchDebounce;

  int? _selectedCategoryId;
  String _searchQuery = '';
  _HomeMetricFilter _selectedMetricFilter = _HomeMetricFilter.products;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearchQuery(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDebounceDuration, () {
      if (!mounted) return;

      setState(() {
        _searchQuery = value;
      });
    });
  }

  void _clearSearchQuery() {
    _searchDebounce?.cancel();
    _searchController.clear();

    setState(() {
      _searchQuery = '';
    });
  }

  Future<void> _incrementProduct(ProductItem product) {
    return widget.database.updateProductQuantity(
      productId: product.id,
      quantity: product.quantity + 1,
    );
  }

  Future<void> _decrementProduct(ProductItem product) async {
    if (product.quantity == 0) return;

    await widget.database.updateProductQuantity(
      productId: product.id,
      quantity: product.quantity - 1,
    );
  }

  Future<void> _editProduct(ProductItem product) async {
    final wasUpdated = await showEditProductSheet(
      context: context,
      database: widget.database,
      product: product,
    );

    if (wasUpdated != true || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product updated.')),
    );
  }

  void _setMetricFilter(_HomeMetricFilter filter) {
    if (_selectedMetricFilter == filter) return;

    setState(() {
      _selectedMetricFilter = filter;
    });
  }

  bool _matchesSelectedMetricFilter(ProductWithCategory productRow) {
    return switch (_selectedMetricFilter) {
      _HomeMetricFilter.products => true,
      _HomeMetricFilter.outOfStock => productRow.product.quantity == 0,
      _HomeMetricFilter.expiringSoon => _isExpiringSoon(productRow.product),
    };
  }

  bool _isExpiringSoon(Product product) {
    if (product.expiryDate.year == 9999) {
      return false;
    }

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final expirySoonEnd = todayStart.add(_expiringSoonDuration);
    final expiryDate = product.expiryDate;
    final expiryDay = DateTime(
      expiryDate.year,
      expiryDate.month,
      expiryDate.day,
    );

    return !expiryDay.isBefore(todayStart) && expiryDay.isBefore(expirySoonEnd);
  }

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
              searchController: _searchController,
              searchQuery: _searchQuery,
              onSearchChanged: _updateSearchQuery,
              onSearchCleared: _clearSearchQuery,
              onProductsMetricTap: () =>
                  _setMetricFilter(_HomeMetricFilter.products),
              onOutOfStockMetricTap: () =>
                  _setMetricFilter(_HomeMetricFilter.outOfStock),
              onExpiringSoonMetricTap: () =>
                  _setMetricFilter(_HomeMetricFilter.expiringSoon),
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
                  final normalizedSearchQuery = _searchQuery
                      .trim()
                      .toLowerCase();
                  final products = productRows
                      .where((productRow) {
                        final selectedCategoryId = _selectedCategoryId;
                        final matchesCategory =
                            selectedCategoryId == null ||
                            productRow.category.id == selectedCategoryId;
                        final matchesSearch =
                            normalizedSearchQuery.isEmpty ||
                            productRow.product.name.toLowerCase().contains(
                              normalizedSearchQuery,
                            );
                        final matchesMetricFilter =
                            _matchesSelectedMetricFilter(productRow);

                        return matchesCategory &&
                            matchesSearch &&
                            matchesMetricFilter;
                      })
                      .map(ProductItem.fromDatabase)
                      .toList();

                  if (products.isEmpty) {
                    return EmptyProducts(
                      hasCategoryFilter: _selectedCategoryId != null,
                      hasSearchQuery: normalizedSearchQuery.isNotEmpty,
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ProductCard(
                          product: products[index],
                          onEdit: () => _editProduct(products[index]),
                          onIncrement: () => _incrementProduct(
                            products[index],
                          ),
                          onDelete: () => _decrementProduct(products[index]),
                        ),
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
