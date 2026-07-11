// lib/core/local/db/app_database.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:customer_app/models/local/chat_message_local.dart';

part 'app_database.g.dart';

// ۱. جدول محصولات (کپی محصولات سرور برای حالت آفلاین)
@DataClassName('LocalProduct')
class Products extends Table {
  IntColumn get id => integer()(); // آیدی سمت سرور (کلید اصلی ماست)
  TextColumn get name => text()();
  TextColumn get code => text().nullable()();
  TextColumn get barcode => text().nullable()();
  RealColumn get sellingPrice => real()();
  TextColumn get description => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id}; // برای آپدیت راحت با InsertMode.insertOrReplace
}

// ۲. جدول هدر سفارشات آفلاین
@DataClassName('OfflineOrder')
class OfflineOrders extends Table {
  IntColumn get id => integer().autoIncrement()(); // آیدی محلی
  TextColumn get profileId => text()();
  RealColumn get totalPrice => real()();
  TextColumn get paymentMethod => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
}

// ۳. جدول اقلام (جزئیات) سفارشات آفلاین
@DataClassName('OfflineOrderItem')
class OfflineOrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(OfflineOrders, #id)(); // کلید خارجی به هدر سفارش
  IntColumn get productId => integer()();
  IntColumn get quantity => integer()();
  RealColumn get unitPrice => real()();
}
 
@DriftDatabase(tables: [Products, OfflineOrders, OfflineOrderItems])
class AppDatabase extends _$AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  AppDatabase._init() : super(_openConnection());

  @override
  int get schemaVersion => 2; // ارتقا به نسخه ۲ به دلیل اضافه شدن جداول جدید

  // متد کمکی برای ذخیره سفارش آفلاین همراه با اقلام آن به صورت تراکنش یکپارچه
  Future<void> saveOfflineOrder(OfflineOrdersCompanion order, List<OfflineOrderItemsCompanion> items) async {
    await transaction(() async {
      // ذخیره هدر سفارش و دریافت آیدی محلی آن
      final orderId = await into(offlineOrders).insert(order);
      
      // ذخیره تک تک اقلام سبد خرید با آیدی سفارش تخصیص یافته
      for (var item in items) {
        await into(offlineOrderItems).insert(item.copyWith(orderId: Value(orderId)));
      }
    });
  }

  static Future<void> initializeLocalDatabases() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ChatMessageLocalAdapter());
    await Hive.openBox<ChatMessageLocal>('pending_chats_box');
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'koraarya_db',
    // پارامتر web برای پشتیبانی کامپایل فلاتر وب اضافه شد
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.dart.js'),
    ),
  );
}
