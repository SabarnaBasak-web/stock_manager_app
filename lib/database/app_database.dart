import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Categories extends Table {
  @override
  String get tableName => 'category';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  TextColumn get colorHex => text().withDefault(const Constant('#2E7D32'))();
}

class Products extends Table {
  @override
  String get tableName => 'product';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get quantity => integer()();
  DateTimeColumn get expiryDate => dateTime()();
}

@DriftDatabase(tables: [Categories, Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'stock_manager'));

  static const _defaultCategories = [
    (name: 'Vegetables', icon: '🥦', colorHex: '#2E7D32'),
    (name: 'Groceries', icon: '🛒', colorHex: '#EF6C00'),
    (name: 'Makeup Essentials', icon: '💄', colorHex: '#AD1457'),
    (name: 'Household Essentials', icon: '🏠', colorHex: '#4527A0'),
    (name: 'Bath Essentials', icon: '🛀', colorHex: '#00695C'),
    (name: 'Clothes', icon: '👗', colorHex: '#1565C0'),
    (name: 'Others', icon: '📦', colorHex: '#607D8B'),
  ];

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(categories, categories.colorHex);
      }
    },
  );

  Stream<List<Category>> watchCategories() {
    return (select(
      categories,
    )..orderBy([(category) => OrderingTerm.asc(category.name)])).watch();
  }

  Future<int> addCategory({
    required String name,
    required String icon,
    required String colorHex,
  }) {
    return into(categories).insert(
      CategoriesCompanion(
        name: Value(name),
        icon: Value(icon),
        colorHex: Value(colorHex),
      ),
    );
  }

  Future<int> addProduct(ProductsCompanion product) {
    return into(products).insert(product);
  }

  Future<void> updateProductQuantity({
    required int productId,
    required int quantity,
  }) {
    return (update(products)..where((product) => product.id.equals(productId)))
        .write(ProductsCompanion(quantity: Value(quantity)));
  }

  Future<void> deleteProduct(int productId) {
    return (delete(products)..where((product) => product.id.equals(productId)))
        .go();
  }

  Future<bool> deleteCategory(int categoryId) async {
    final existingProducts =
        await (select(
          products,
        )..where((product) => product.categoryId.equals(categoryId))).get();

    if (existingProducts.isNotEmpty) {
      return false;
    }

    await (delete(
      categories,
    )..where((category) => category.id.equals(categoryId))).go();
    return true;
  }

  Stream<List<ProductWithCategory>> watchProducts() {
    final query = select(products).join([
      innerJoin(categories, categories.id.equalsExp(products.categoryId)),
    ])
      ..orderBy([OrderingTerm.desc(products.id)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return ProductWithCategory(
          product: row.readTable(products),
          category: row.readTable(categories),
        );
      }).toList();
    });
  }

  Stream<StockMetrics> watchStockMetrics() {
    return select(products).watch().map((productList) {
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final expirySoonEnd = todayStart.add(const Duration(days: 4));

      final expiringSoonCount = productList.where((product) {
        final expiryDate = product.expiryDate;
        final expiryDay = DateTime(
          expiryDate.year,
          expiryDate.month,
          expiryDate.day,
        );

        return expiryDate.year != 9999 &&
            !expiryDay.isBefore(todayStart) &&
            expiryDay.isBefore(expirySoonEnd);
      }).length;

      return StockMetrics(
        totalProducts: productList.length,
        outOfStockProducts: productList
            .where((product) => product.quantity == 0)
            .length,
        expiringSoonProducts: expiringSoonCount,
      );
    });
  }

  Stream<List<CategoryWithProducts>> watchCategoriesWithProducts() {
    final query = select(categories).join([
      leftOuterJoin(products, products.categoryId.equalsExp(categories.id)),
    ])
      ..orderBy([
        OrderingTerm.asc(categories.name),
        OrderingTerm.desc(products.id),
      ]);

    return query.watch().map((rows) {
      final categoriesById = <int, CategoryWithProducts>{};

      for (final row in rows) {
        final category = row.readTable(categories);
        final product = row.readTableOrNull(products);
        final existingCategory = categoriesById[category.id];

        if (existingCategory == null) {
          categoriesById[category.id] = CategoryWithProducts(
            category: category,
            products: [
              if (product != null)
                ProductWithCategory(product: product, category: category),
            ],
          );
          continue;
        }

        if (product != null) {
          existingCategory.products.add(
            ProductWithCategory(product: product, category: category),
          );
        }
      }

      return categoriesById.values.toList();
    });
  }

  Future<void> seedDefaultCategories() async {
    await transaction(() async {
      final existingCategories = await select(categories).get();
      final categoriesByName = {
        for (final category in existingCategories) category.name: category,
      };

      for (final category in _defaultCategories) {
        final existingCategory = categoriesByName[category.name];

        if (existingCategory == null) {
          await into(categories).insert(
            CategoriesCompanion(
              name: Value(category.name),
              icon: Value(category.icon),
              colorHex: Value(category.colorHex),
            ),
          );
          continue;
        }

        if (existingCategory.icon != category.icon ||
            existingCategory.colorHex != category.colorHex) {
          await (update(categories)
                ..where((table) => table.id.equals(existingCategory.id)))
              .write(
                CategoriesCompanion(
                  icon: Value(category.icon),
                  colorHex: Value(category.colorHex),
                ),
              );
        }
      }
    });
  }
}

class ProductWithCategory {
  const ProductWithCategory({
    required this.product,
    required this.category,
  });

  final Product product;
  final Category category;
}

class StockMetrics {
  const StockMetrics({
    required this.totalProducts,
    required this.outOfStockProducts,
    required this.expiringSoonProducts,
  });

  final int totalProducts;
  final int outOfStockProducts;
  final int expiringSoonProducts;
}

class CategoryWithProducts {
  CategoryWithProducts({
    required this.category,
    required this.products,
  });

  final Category category;
  final List<ProductWithCategory> products;

  int get totalProducts => products.length;

  int get inStockProducts {
    return products
        .where((productRow) => productRow.product.quantity > 0)
        .length;
  }
}
