import 'package:flutter/material.dart';

import '../../core/stock_colors.dart';
import '../../database/app_database.dart';
import '../../helper/date_helper.dart';
import 'stock_metric_card.dart';

class StockHeader extends StatelessWidget {
  const StockHeader({
    required this.stockMetricsStream,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onSearchCleared,
    required this.onProductsMetricTap,
    required this.onOutOfStockMetricTap,
    required this.onExpiringSoonMetricTap,
    super.key,
  });

  final Stream<StockMetrics> stockMetricsStream;
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchCleared;
  final VoidCallback onProductsMetricTap;
  final VoidCallback onOutOfStockMetricTap;
  final VoidCallback onExpiringSoonMetricTap;

  @override
  Widget build(BuildContext context) {
    final greetings = getGreetings();

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greetings,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'My Stock',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.13),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_rounded,
                      color: Color(0xFFCFD7FF),
                      size: 21,
                    ),
                  ),
                  Positioned(
                    right: 7,
                    top: 6,
                    child: Container(
                      height: 7,
                      width: 7,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC928),
                        shape: BoxShape.circle,
                        border: Border.all(color: StockColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          StreamBuilder<StockMetrics>(
            stream: stockMetricsStream,
            builder: (context, snapshot) {
              final metrics =
                  snapshot.data ??
                  const StockMetrics(
                    totalProducts: 0,
                    outOfStockProducts: 0,
                    expiringSoonProducts: 0,
                  );

              return Row(
                children: [
                  Expanded(
                    child: StockMetricCard(
                      icon: Icons.inventory_2_outlined,
                      value: metrics.totalProducts.toString(),
                      label: 'Products',
                      onTap: onProductsMetricTap,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StockMetricCard(
                      icon: Icons.remove_shopping_cart_outlined,
                      value: metrics.outOfStockProducts.toString(),
                      label: 'Out of Stock',
                      iconColor: const Color(0xFFFFA0A0),
                      onTap: onOutOfStockMetricTap,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StockMetricCard(
                      icon: Icons.schedule_rounded,
                      value: metrics.expiringSoonProducts.toString(),
                      label: 'Exp. Soon',
                      iconColor: const Color(0xFFFFD15B),
                      onTap: onExpiringSoonMetricTap,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: Color(0xFFCAD3FF),
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: TextStyle(
                        color: Color(0xFFCAD3FF),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                if (searchQuery.isNotEmpty)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      height: 30,
                      width: 30,
                    ),
                    tooltip: 'Clear search',
                    onPressed: onSearchCleared,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFFCAD3FF),
                      size: 19,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
