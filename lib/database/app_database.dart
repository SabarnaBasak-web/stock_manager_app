import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Categories extends Table {
  @override
  String get tableName => 'category';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get icon => text()();
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
    (name: 'Vegetables', icon: '🥦'),
    (name: 'Groceries', icon: '🛒'),
    (name: 'Makeup Essentials', icon: '💄'),
    (name: 'Household Essentials', icon: '🏠'),
    (name: 'Bath Essentials', icon: '🛀'),
    (name: 'Clothes', icon: '👗'),
    (name: 'Others', icon: '📦'),
  ];

  @override
  int get schemaVersion => 1;

  Stream<List<Category>> watchCategories() {
    return (select(
      categories,
    )..orderBy([(category) => OrderingTerm.asc(category.name)])).watch();
  }

  Future<int> addProduct(ProductsCompanion product) {
    return into(products).insert(product);
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
            CategoriesCompanion.insert(
              name: category.name,
              icon: category.icon,
            ),
          );
          continue;
        }

        if (existingCategory.icon != category.icon) {
          await (update(categories)
                ..where((table) => table.id.equals(existingCategory.id)))
              .write(CategoriesCompanion(icon: Value(category.icon)));
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
