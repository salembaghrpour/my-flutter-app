// lib/services/product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:drift/drift.dart' as drift;

import '../models/catalog/product_summary.dart';
import '../models/catalog/category.dart';
import '../constants/api_constants.dart';
import '../core/local/db/app_database.dart';
import 'connectivity_service.dart';

String? _nullIfEmpty(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return value;
}

List<dynamic> _asProductList(dynamic decoded) {
  if (decoded is List) return decoded;
  if (decoded is Map) {
    final raw = decoded['data'] ??
        decoded['items'] ??
        decoded['products'] ??
        decoded['results'];
    if (raw is List) return raw;
  }
  return const [];
}

List<dynamic> _asCategoryList(dynamic decoded) {
  if (decoded is List) return decoded;
  if (decoded is Map) {
    for (final key in ['data', 'items', 'categories', 'results']) {
      final raw = decoded[key];
      if (raw is List) return raw;
      if (raw is Map) {
        final nested = _asCategoryList(raw);
        if (nested.isNotEmpty) return nested;
      }
    }
  }
  return const [];
}

dynamic _firstRawValue(Map<String, dynamic> raw, List<String> keys) {
  for (final key in keys) {
    if (!raw.containsKey(key)) continue;
    final value = raw[key];
    if (value != null) return value;
  }
  return null;
}

Map<String, dynamic> _normalizeProductMap(Map<String, dynamic> raw) {
  final map = Map<String, dynamic>.from(raw);
  final description = _firstRawValue(map, [
    'description',
    'desc',
    'product_description',
    'productDescription',
    'details',
    'note',
    'notes',
  ]);
  if (description != null) map['description'] = description;

  var extra = _firstRawValue(map, [
    'extra_attributes',
    'extraAttributes',
    'attributes',
    'specs',
    'extra_attrs',
    'extraAttrs',
  ]);
  if (extra is String && extra.trim().isNotEmpty) {
    try {
      extra = json.decode(extra);
    } catch (_) {}
  }
  if (extra != null) map['extra_attributes'] = extra;

  return map;
}

Map<String, dynamic> _categoryToMap(ProductCategory cat) {
  return {
    'id': cat.id,
    'accountingId': cat.accountingId,
    'accounting_id': cat.accountingId,
    'name': cat.name,
    'description': cat.description,
    'parentId': cat.parentId,
    'parent_id': cat.parentId,
    'parentAccountingId': cat.parentAccountingId,
    'parent_accounting_id': cat.parentAccountingId,
    'sortOrder': cat.sortOrder,
    'sort_order': cat.sortOrder,
    'imagePath': cat.imagePath,
    'image_path': cat.imagePath,
    'isActive': cat.isActive,
    'is_active': cat.isActive,
    'children': cat.children.map(_categoryToMap).toList(),
  };
}

class ProductService {
  final AppDatabase _db = AppDatabase.instance;

  Future<List<ProductSummary>> fetchProducts() async {
    final connectivity = Get.find<ConnectivityService>();

    if (connectivity.isConnected.value) {
      try {
        final url = Uri.parse(ApiConstants.products);
        final response =
            await http.get(url).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final decoded = json.decode(utf8.decode(response.bodyBytes));
          final rawItems = _asProductList(decoded);

          final products = rawItems.whereType<Map>().map((item) {
            return ProductSummary.fromJson(
                _normalizeProductMap(Map<String, dynamic>.from(item)));
          }).toList();

          await _syncProductsToLocalDb(products);
          return products;
        }
      } catch (_) {}
    }

    try {
      final localProducts = await _db.select(_db.products).get();
      if (localProducts.isEmpty) return [];

      return localProducts.map((local) {
        final jsonMap = {
          'id': local.id,
          'name': local.name,
          // اضافه‌کردن کلید جایگزین 'price' تا fromJson جدید با اطمینان کامل دیتای دیتابیس را هم بخواند
          'displayPrice': local.sellingPrice,
          'price': local.sellingPrice, 
          'description': _nullIfEmpty(local.description),
          'imagePath': _nullIfEmpty(local.imagePath),
          'baseUnitName': _nullIfEmpty(local.baseUnitName),
          'hasMultiUnits': local.hasMultiUnits,
          'hasBatches': local.hasBatches,
          'hasLogistics': false,
        };
        return ProductSummary.fromJson(jsonMap);
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<ProductCategory>> fetchCategories() async {
    final connectivity = Get.find<ConnectivityService>();

    if (connectivity.isConnected.value) {
      try {
        final url = Uri.parse(ApiConstants.categories);
        final response =
            await http.get(url).timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final decoded = json.decode(utf8.decode(response.bodyBytes));
          final rawItems = _asCategoryList(decoded);
          final tree = ProductCategory.buildTree(rawItems);

          if (tree.isNotEmpty) {
            await _saveCategoriesToLocal(tree);
            return tree;
          }
        }
      } catch (_) {}
    }

    return await _getCategoriesFromLocal();
  }

  Future<void> _saveCategoriesToLocal(List<ProductCategory> categories) async {
    await _db.delete(_db.productCategories).go();
    for (final cat in categories) {
      await _insertCategoryRecursive(cat);
    }
  }

  Future<void> _insertCategoryRecursive(ProductCategory cat) async {
    final childrenJson = cat.children.isNotEmpty
        ? jsonEncode(cat.children.map(_categoryToMap).toList())
        : null;

    final companion = ProductCategoriesCompanion(
      id: drift.Value(cat.id),
      accountingId: drift.Value(cat.accountingId),
      name: drift.Value(cat.name),
      description: drift.Value(cat.description),
      parentId: drift.Value(cat.parentId),
      parentAccountingId: drift.Value(cat.parentAccountingId),
      sortOrder: drift.Value(cat.sortOrder),
      imagePath: drift.Value(cat.imagePath),
      isActive: drift.Value(cat.isActive),
      childrenJson: drift.Value(childrenJson),
    );

    await _db.into(_db.productCategories).insertOnConflictUpdate(companion);

    for (final child in cat.children) {
      await _insertCategoryRecursive(child);
    }
  }

  Future<List<ProductCategory>> _getCategoriesFromLocal() async {
    try {
      final rows = await _db.select(_db.productCategories).get();
      if (rows.isEmpty) return [];

      return rows
          .where((row) => row.parentId == null || row.parentId == 0)
          .map((row) => _rowToCategory(row, rows))
          .toList();
    } catch (_) {
      return [];
    }
  }

  ProductCategory _rowToCategory(
    LocalProductCategory row,
    List<LocalProductCategory> allRows,
  ) {
    var children = <ProductCategory>[];

    if (row.childrenJson != null && row.childrenJson!.isNotEmpty) {
      try {
        final list = jsonDecode(row.childrenJson!) as List;
        children = list
            .map((e) => ProductCategory.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } catch (_) {}
    }

    if (children.isEmpty) {
      children = allRows
          .where((item) => item.parentId == row.id)
          .map((item) => _rowToCategory(item, allRows))
          .toList();
    }

    return ProductCategory(
      id: row.id,
      accountingId: row.accountingId,
      name: row.name,
      description: row.description,
      parentId: row.parentId,
      parentAccountingId: row.parentAccountingId,
      sortOrder: row.sortOrder,
      imagePath: row.imagePath,
      isActive: row.isActive,
      children: children,
    );
  }

  Future<void> _syncProductsToLocalDb(List<ProductSummary> products) async {
    for (final prod in products) {
      final companion = ProductsCompanion(
        id: drift.Value(prod.id),
        name: drift.Value(prod.name),
        code: const drift.Value(''),
        barcode: const drift.Value(''),
        isActive: const drift.Value(true),
        baseUnitId: const drift.Value(0),
        sellingPrice: drift.Value(prod.displayPrice), // قیمت سالم در دیتابیس لوکال ذخیره می‌شود
        description: drift.Value(prod.description ?? ''),
        imagePath: drift.Value(prod.imagePath ?? ''),
        baseUnitName: drift.Value(prod.baseUnitName ?? ''),
        hasMultiUnits: drift.Value(prod.hasMultiUnits),
        hasBatches: drift.Value(prod.hasBatches),
      );
      await _db.into(_db.products).insertOnConflictUpdate(companion);
    }
  }
}
