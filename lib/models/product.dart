// lib/models/product.dart

class Product {
  final int id;
  final String name;
  final String? code;
  final String? barcode;
  final double sellingPrice; 
  final String? description;
  final String? imagePath;
  final bool isActive;

  Product({
    required this.id,
    required this.name,
    this.code,
    this.barcode,
    required this.sellingPrice,
    this.description,
    this.imagePath,
    required this.isActive,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? 'بدون نام',
      code: json['code']?.toString(),
      barcode: json['barcode']?.toString(),
      // پشتیبانی از کلیدهای مختلف (price یا selling_price)
      sellingPrice: (json['selling_price'] ?? json['price'] ?? 0).toDouble(),
      description: json['description'],
      imagePath: json['image_path'],
      isActive: json['is_active'] ?? true,
    );
  }

  // جهت استفاده در سبد خرید (اگر کنترلر سبد خرید نیاز به Map دارد)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'selling_price': sellingPrice,
      'image_path': imagePath,
    };
  }
}
