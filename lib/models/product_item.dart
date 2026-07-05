import '../database/app_database.dart';

class ProductItem {
  const ProductItem({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.category,
    required this.icon,
    required this.quantity,
    required this.expiryDate,
    required this.expiryText,
    required this.status,
    this.expiryLevel = ExpiryLevel.warning,
  });

  final int id;
  final String name;
  final int categoryId;
  final String category;
  final String icon;
  final int quantity;
  final DateTime expiryDate;
  final String expiryText;
  final ProductStatus status;
  final ExpiryLevel expiryLevel;

  bool get hasNoExpiryDate => expiryDate.year == 9999;

  factory ProductItem.fromDatabase(ProductWithCategory productWithCategory) {
    final product = productWithCategory.product;
    final category = productWithCategory.category;
    final daysUntilExpiry = product.expiryDate
        .difference(DateTime.now())
        .inDays;
    final hasNoExpiryDate = product.expiryDate.year == 9999;

    return ProductItem(
      id: product.id,
      name: product.name,
      categoryId: category.id,
      category: category.name,
      icon: category.icon,
      quantity: product.quantity,
      expiryDate: product.expiryDate,
      expiryText: hasNoExpiryDate
          ? 'No expiry'
          : _buildExpiryText(daysUntilExpiry),
      status: product.quantity == 0
          ? ProductStatus.outOfStock
          : ProductStatus.inStock,
      expiryLevel: !hasNoExpiryDate && daysUntilExpiry <= 3
          ? ExpiryLevel.danger
          : ExpiryLevel.warning,
    );
  }
}

enum ProductStatus { inStock, outOfStock }

enum ExpiryLevel { warning, danger }

String _buildExpiryText(int daysUntilExpiry) {
  if (daysUntilExpiry < 0) {
    return 'Expired';
  }

  if (daysUntilExpiry == 0) {
    return 'Exp. today';
  }

  return 'Exp. in ${daysUntilExpiry}d';
}
