import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

// TODO: مسیر صحیح فایل مدل چت خود را وارد کنید
// این فایل باید حاوی کلاس ChatMessageLocal و آداپتور آن باشد
import '../../../models/local/chat_message_local.dart';


part 'app_database.g.dart';

@DataClassName('LocalProduct')
class Products extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  TextColumn get barcode => text().nullable()();
  RealColumn get sellingPrice => real()();
  TextColumn get description => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  IntColumn get baseUnitId => integer().nullable()();
  TextColumn get baseUnitName => text().nullable()();
  BoolColumn get hasMultiUnits => boolean().withDefault(const Constant(false))();
  BoolColumn get hasBatches => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalProductCategory')
class ProductCategories extends Table {
  IntColumn get id => integer()();
  IntColumn get accountingId => integer().nullable()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get parentId => integer().nullable()();
  IntColumn get parentAccountingId => integer().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get imagePath => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  TextColumn get childrenJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OfflineOrder')
class OfflineOrders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profileId => text()();
  RealColumn get totalPrice => real()();
  TextColumn get paymentMethod => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

@DataClassName('OfflineOrderItem')
class OfflineOrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(OfflineOrders, #id)();
  IntColumn get productId => integer()();
  IntColumn get quantity => integer()();
  RealColumn get unitPrice => real()();
}

@DataClassName('LocalCurrencyConfig')
class CurrenciesConfig extends Table {
  IntColumn get id => integer()();
  IntColumn get accountingId => integer().nullable()();
  TextColumn get baseCurrencyName => text()();
  TextColumn get baseCurrencySymbol => text()();
  TextColumn get varCurrencyName => text().nullable()();
  TextColumn get varCurrencySymbol => text().nullable()();
  RealColumn get exchangeRate => real().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastUpdated => dateTime().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalBatchUnitPrice')
class BatchUnitPrices extends Table {
  IntColumn get id => integer()();
  IntColumn get batchId => integer()();
  IntColumn get unitId => integer()();
  RealColumn get sellingPrice => real()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalProductUnitPrice')
class ProductUnitPrices extends Table {
  IntColumn get id => integer()();
  IntColumn get productId => integer()();
  IntColumn get unitId => integer()();
  RealColumn get sellingPrice => real()();
  RealColumn get conversionToBase => real()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalProductBatch')
class ProductBatches extends Table {
  IntColumn get id => integer()();
  IntColumn get productId => integer()();
  TextColumn get batchNumber => text()();
  RealColumn get sellingPrice => real()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalLedgerEntry')
class LedgerEntries extends Table {
  IntColumn get id => integer()();
  TextColumn get operationType => text()();
  TextColumn get description => text().nullable()();
  RealColumn get debit => real()();
  RealColumn get credit => real()();
  RealColumn get balanceAfter => real()();
  TextColumn get documentNumber => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get sortIndex => integer().withDefault(const Constant(0))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Products,
    ProductCategories,
    OfflineOrders,
    OfflineOrderItems,
    CurrenciesConfig,
    BatchUnitPrices,
    ProductUnitPrices,
    ProductBatches,
    LedgerEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  factory AppDatabase() => instance;

  static AppDatabase? _instance;

  static AppDatabase get instance {
    _instance ??= AppDatabase._internal();
    return _instance!;
  }

  static Future<void> initializeLocalDatabases() async {
    try {
      await Hive.initFlutter();
      
      // ======================= FIX FOR CHAT =======================
      // آداپتور کلاس ChatMessageLocal را برای Hive ثبت می‌کند تا بتواند آن را ذخیره کند
      // مطمئن شوید typeId (اینجا 0 است) با quello که در مدل تعریف کرده‌اید یکسان باشد
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(ChatMessageLocalAdapter());
      }
      // ============================================================

    } catch (e, st) {
      debugPrint('Hive.initFlutter failed: $e\n$st');
    }
    _instance ??= AppDatabase._internal();
  }

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 3) {
            await customStatement(
              'ALTER TABLE products ADD COLUMN base_unit_id INTEGER NULL',
            );
            await customStatement(
              'ALTER TABLE products ADD COLUMN base_unit_name TEXT NULL',
            );
            await customStatement(
              'ALTER TABLE products ADD COLUMN has_multi_units INTEGER NOT NULL DEFAULT 0',
            );
            await customStatement(
              'ALTER TABLE products ADD COLUMN has_batches INTEGER NOT NULL DEFAULT 0',
            );
          }
          if (from < 5) {
            await m.createTable(currenciesConfig);
          }
          if (from < 6) {
            await m.createTable(batchUnitPrices);
          }
          if (from < 7) {
            await m.createTable(productUnitPrices);
            await m.createTable(productBatches);
          }
          if (from < 8) {
            await m.createTable(ledgerEntries);
          }
        },
      );

  Future<List<LocalLedgerEntry>> getCachedLedgerEntries() {
    return (select(ledgerEntries)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
            (t) => OrderingTerm(
                  expression: t.sortIndex,
                  mode: OrderingMode.desc,
                ),
          ]))
        .get();
  }

  Future<DateTime?> getLedgerLastSyncedAt() async {
    final row = await (select(ledgerEntries)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.syncedAt,
                  mode: OrderingMode.desc,
                ),
          ])
          ..limit(1))
        .getSingleOrNull();
    return row?.syncedAt;
  }

  Future<void> replaceLedgerEntries(List<LedgerEntriesCompanion> rows) async {
    await transaction(() async {
      await delete(ledgerEntries).go();
      if (rows.isNotEmpty) {
        await batch((b) => b.insertAll(ledgerEntries, rows));
      }
    });
  }

  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(offlineOrderItems).go();
      await delete(offlineOrders).go();
      await delete(batchUnitPrices).go();
      await delete(productUnitPrices).go();
      await delete(productBatches).go();
      await delete(products).go();
      await delete(productCategories).go();
      await delete(currenciesConfig).go();
      await delete(ledgerEntries).go();
    });
  }

  Future<double> calculateOfflinePrice(
    int productId,
    int unitId, {
    int? batchId,
  }) async {
    final product = await (select(products)
          ..where((tbl) => tbl.id.equals(productId)))
        .getSingleOrNull();

    if (product == null) {
      throw Exception(
        'محصول با شناسه $productId در دیتابیس آفلاین یافت نشد.',
      );
    }

    final int? baseUnitId = product.baseUnitId;
    final double baseSellingPrice = product.sellingPrice;
    final bool isBaseUnit = unitId == baseUnitId;

    if (isBaseUnit && batchId != null) {
      final batch = await (select(productBatches)
            ..where(
              (tbl) => tbl.id.equals(batchId) & tbl.productId.equals(productId),
            ))
          .getSingleOrNull();
      return (batch != null && batch.sellingPrice > 0)
          ? batch.sellingPrice
          : baseSellingPrice;
    }

    if (isBaseUnit && batchId == null) {
      return baseSellingPrice;
    }

    if (!isBaseUnit && batchId == null) {
      final pup = await (select(productUnitPrices)
            ..where(
              (tbl) =>
                  tbl.productId.equals(productId) & tbl.unitId.equals(unitId),
            ))
          .getSingleOrNull();
      return pup != null ? pup.sellingPrice : baseSellingPrice;
    }

    if (!isBaseUnit && batchId != null) {
      final bup = await (select(batchUnitPrices)
            ..where(
              (tbl) => tbl.batchId.equals(batchId) & tbl.unitId.equals(unitId),
            ))
          .getSingleOrNull();

      if (bup != null && bup.sellingPrice > 0) {
        return bup.sellingPrice;
      }

      final batch = await (select(productBatches)
            ..where((tbl) => tbl.id.equals(batchId)))
          .getSingleOrNull();
      final double batchBasePrice =
          (batch != null) ? batch.sellingPrice : baseSellingPrice;

      final pup = await (select(productUnitPrices)
            ..where(
              (tbl) =>
                  tbl.productId.equals(productId) & tbl.unitId.equals(unitId),
            ))
          .getSingleOrNull();
      final double conversion = (pup != null) ? pup.conversionToBase : 1.0;

      return batchBasePrice * conversion;
    }

    return baseSellingPrice;
  }

  Future<void> saveOfflineOrder(
    OfflineOrdersCompanion order,
    List<OfflineOrderItemsCompanion> items,
  ) async {
    await transaction(() async {
      final orderId = await into(offlineOrders).insert(order);
      for (final item in items) {
        await into(offlineOrderItems).insert(
          item.copyWith(orderId: Value(orderId)),
        );
      }
    });
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'app_database',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
      onResult: (result) {
        if (result.missingFeatures.isNotEmpty) {
          debugPrint(
            'Drift Web: Using ${result.chosenImplementation} due to missing browser features: ${result.missingFeatures}',
          );
        }
      },
    ),
  );
}
