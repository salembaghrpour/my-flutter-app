// lib/models/catalog/product_summary.dart
class ProductSummary {
  final int id;
  final String name;
  final String? description;
  final String? imagePath;
  final String? categoryName;
  final String? baseUnitName;
  final double displayPrice;
  final String priceLabel;
  final bool hasMultiUnits;
  final bool hasBatches;
  final bool hasLogistics;
  final Map<String, dynamic>? extraAttributes;

  const ProductSummary({
    required this.id,
    required this.name,
    this.description,
    required this.displayPrice,
    required this.priceLabel,
    this.imagePath,
    this.categoryName,
    this.baseUnitName,
    this.hasMultiUnits = false,
    this.hasBatches = false,
    this.hasLogistics = false,
    this.extraAttributes,
  });

  factory ProductSummary.fromJson(Map<String, dynamic> json) {
    // ۱. بررسی تمام کلیدهای احتمالی که API ممکن است برای قیمت بفرستد
    final rawPrice = json['display_price'] ??
        json['displayPrice'] ??
        json['selling_price'] ??
        json['sellingPrice'] ??
        json['price'] ??
        json['regular_price'] ??
        json['sale_price'] ??
        json['unit_price'] ??
        json['unitPrice'] ??
        0;

    // ۲. پارس کردن امن قیمت (جلوگیری از خطای رشته‌های حاوی کاما مثل "150,000")
    double parsedPrice = 0.0;
    if (rawPrice is num) {
      parsedPrice = rawPrice.toDouble();
    } else {
      // حذف کاما و فاصله‌های اضافی قبل از تبدیل به عدد
      final cleanPrice = rawPrice.toString().replaceAll(',', '').replaceAll('،', '').trim();
      parsedPrice = double.tryParse(cleanPrice) ?? 0.0;
    }

    final extra = json['extra_attributes'] ?? json['extraAttributes'];

    return ProductSummary(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: (json['name']?.toString().trim().isNotEmpty ?? false)
          ? json['name'].toString()
          : 'بدون نام',
      description: json['description']?.toString(),
      imagePath: (json['image_path'] ?? json['imagePath'])?.toString(),
      categoryName: (json['category_name'] ?? json['categoryName'])?.toString(),
      baseUnitName: (json['base_unit_name'] ?? json['baseUnitName'])?.toString(),
      displayPrice: parsedPrice, // استفاده از قیمت پردازش شده و ایمن
      priceLabel: (json['price_label'] ?? json['priceLabel'] ?? '').toString(),
      // رفع مشکل باگ احتمالی در تبدیل نوع‌های boolean و string از API
      hasMultiUnits: json['has_multi_units'] == true || json['hasMultiUnits'] == true || json['has_multi_units'] == '1',
      hasBatches: json['has_batches'] == true || json['hasBatches'] == true || json['has_batches'] == '1',
      hasLogistics: json['has_logistics'] == true || json['hasLogistics'] == true || json['has_logistics'] == '1',
      extraAttributes: extra is Map ? Map<String, dynamic>.from(extra) : null,
    );
  }

  // اضافه شدن متد toJson برای رفع خطای ارسال به سبد خرید
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'categoryName': categoryName,
      'baseUnitName': baseUnitName,
      'displayPrice': displayPrice,
      'priceLabel': priceLabel,
      'hasMultiUnits': hasMultiUnits,
      'hasBatches': hasBatches,
      'hasLogistics': hasLogistics,
      'extraAttributes': extraAttributes,
      // ایجاد متغیر needsOptions برای سازگاری با کنترلر سبد خرید شما
      'needsOptions': hasMultiUnits || hasBatches, 
    };
  }

  List<String> get customAttributes {
    final attrs = extraAttributes;
    if (attrs == null) return const [];

    final items = <String>[];

    void add(String label, dynamic value) {
      if (value == null) return;
      final text = value.toString().trim();
      if (text.isEmpty) return;
      items.add('$label: $text');
    }

    add('برند', attrs['brand']);
    add('رنگ', attrs['color']);
    add('مدل', attrs['model']);

    final custom = attrs['custom_attributes'];
    if (custom is Map) {
      for (final entry in custom.entries) {
        add(entry.key.toString(), entry.value);
      }
    }

    return items;
  }
}
