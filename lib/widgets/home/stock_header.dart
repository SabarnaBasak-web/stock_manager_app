import 'package:flutter/material.dart';

import '../../core/stock_colors.dart';
import '../../database/app_database.dart';
import '../../helper/date_helper.dart';
import 'stock_metric_card.dart';

class StockHeader extends StatelessWidget {
  const StockHeader({required this.stockMetricsStream, super.key});

  final Stream<StockMetrics> stockMetricsStream;

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
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StockMetricCard(
                      icon: Icons.remove_shopping_cart_outlined,
                      value: metrics.outOfStockProducts.toString(),
                      label: 'Out of Stock',
                      iconColor: const Color(0xFFFFA0A0),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StockMetricCard(
                      icon: Icons.schedule_rounded,
                      value: metrics.expiringSoonProducts.toString(),
                      label: 'Exp. Soon',
                      iconColor: const Color(0xFFFFD15B),
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
            child: const Row(
              children: [
                Icon(Icons.search_rounded, color: Color(0xFFCAD3FF), size: 22),
                SizedBox(width: 10),
                Text(
                  'Search products...',
                  style: TextStyle(
                    color: Color(0xFFCAD3FF),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
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
