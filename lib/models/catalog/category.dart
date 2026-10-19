// lib/models/catalog/category.dart

class ProductCategory {
  final int id;
  final int? accountingId;
  final String name;
  final String? description;
  final int? parentId;
  final int? parentAccountingId;
  final int sortOrder;
  final String? imagePath;
  final bool isActive;
  final List<ProductCategory> children;

  const ProductCategory({
    required this.id,
    this.accountingId,
    required this.name,
    this.description,
    this.parentId,
    this.parentAccountingId,
    this.sortOrder = 0,
    this.imagePath,
    this.isActive = true,
    this.children = const [],
  });

  bool get hasChildren => children.isNotEmpty;

  List<ProductCategory> get descendants {
    final result = <ProductCategory>[];
    for (final child in children) {
      result.add(child);
      result.addAll(child.descendants);
    }
    return result;
  }

  List<int> get selfAndDescendantIds => <int>[
        id,
        ...descendants.map((e) => e.id),
      ];

  List<int> get selfAndDescendantAccountingIds {
    final ids = <int>[];
    if (accountingId != null) ids.add(accountingId!);
    for (final item in descendants) {
      if (item.accountingId != null) ids.add(item.accountingId!);
    }
    return ids;
  }

  List<String> get selfAndDescendantNames => <String>[
        name,
        ...descendants.map((e) => e.name),
      ];

  ProductCategory copyWith({List<ProductCategory>? children}) {
    return ProductCategory(
      id: id,
      accountingId: accountingId,
      name: name,
      description: description,
      parentId: parentId,
      parentAccountingId: parentAccountingId,
      sortOrder: sortOrder,
      imagePath: imagePath,
      isActive: isActive,
      children: children ?? this.children,
    );
  }

  static int? parseInt(dynamic value) {
    if (value == null || value == '' || value == 'null') return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString().trim());
  }

  static bool parseBool(dynamic value, {bool fallback = true}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final text = value.toLowerCase().trim();
      if (text == 'true' || text == '1' || text == 'yes') return true;
      if (text == 'false' || text == '0' || text == 'no') return false;
    }
    return fallback;
  }

  static List<dynamic> asRawList(dynamic value) {
    if (value is List) return value;
    return const [];
  }

  static int? _parseParentId(Map<String, dynamic> json) {
    final direct = parseInt(
      json['parent_id'] ?? json['parentId'] ?? json['parent_accounting_id'],
    );
    if (direct != null) return direct;

    final parent = json['parent'];
    if (parent is Map) {
      return parseInt(parent['id'] ?? parent['accounting_id']);
    }
    return parseInt(parent);
  }

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    final rawChildren = json['children'] ??
        json['subcategories'] ??
        json['sub_categories'] ??
        json['subs'];

    final children = asRawList(rawChildren)
        .whereType<Map>()
        .map((item) => ProductCategory.fromJson(Map<String, dynamic>.from(item)))
        .toList()
      ..sort(_compareCategories);

    return ProductCategory(
      id: parseInt(json['id']) ?? 0,
      accountingId: parseInt(json['accounting_id'] ?? json['accountingId']),
      name: (json['name'] ?? json['title'] ?? json['label'] ?? '').toString(),
      description: json['description']?.toString(),
      parentId: _parseParentId(json),
      parentAccountingId:
          parseInt(json['parent_accounting_id'] ?? json['parentAccountingId']),
      sortOrder: parseInt(json['sort_order'] ?? json['sortOrder']) ?? 0,
      imagePath: (json['image_path'] ?? json['imagePath'])?.toString(),
      isActive: parseBool(json['is_active'] ?? json['isActive']),
      children: children,
    );
  }

  static int _compareCategories(ProductCategory a, ProductCategory b) {
    final bySort = a.sortOrder.compareTo(b.sortOrder);
    if (bySort != 0) return bySort;
    return a.id.compareTo(b.id);
  }

  /// لیست تخت جدول product_categories یا پاسخ تو در تو را به درخت ریشه تبدیل می‌کند.
  static List<ProductCategory> buildTree(List<dynamic> rawItems) {
    final flat = <int, Map<String, dynamic>>{};
    final accountingToId = <int, int>{};

    void collect(dynamic raw, int? inheritedParentId) {
      if (raw is! Map) return;
      final map = Map<String, dynamic>.from(raw);
      final id = parseInt(map['id']);
      if (id == null || id <= 0) return;

      final accountingId = parseInt(map['accounting_id'] ?? map['accountingId']);
      if (accountingId != null) {
        accountingToId[accountingId] = id;
      }

      final ownParent = _parseParentId(map);
      map['parentId'] = ownParent ?? inheritedParentId;
      map['parent_id'] = map['parentId'];

      final nested = map['children'] ??
          map['subcategories'] ??
          map['sub_categories'] ??
          map['subs'];

      map['children'] = <Map<String, dynamic>>[];
      flat[id] = map;

      for (final child in asRawList(nested)) {
        collect(child, id);
      }
    }

    for (final item in rawItems) {
      collect(item, null);
    }

    final roots = <Map<String, dynamic>>[];
    for (final item in flat.values) {
      final parentId = parseInt(item['parentId']);
      final isRoot = parentId == null || parentId == 0;
      if (isRoot) {
        roots.add(item);
        continue;
      }

      final parentKey =
          flat.containsKey(parentId) ? parentId : accountingToId[parentId];
      if (parentKey != null && flat.containsKey(parentKey)) {
        (flat[parentKey]!['children'] as List).add(item);
      } else {
        roots.add(item);
      }
    }

    return roots
        .map(ProductCategory.fromJson)
        .where((item) => item.isActive && item.id > 0 && item.name.trim().isNotEmpty)
        .toList()
      ..sort(_compareCategories);
  }
}
