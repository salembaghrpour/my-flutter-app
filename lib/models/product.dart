// lib/models/product.dart
import '../core/local/db/app_database.dart'; // مسیر دیتابیس برای دسترسی به LocalProduct

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
      sellingPrice: (json['selling_price'] ?? json['price'] ?? 0).toDouble(),
      description: json['description'],
      imagePath: json['image_path'],
      isActive: json['is_active'] ?? true,
    );
  }

  // --- تبدیل اطلاعات دیتابیس محلی (Drift) به مدل اپلیکیشن ---
  factory Product.fromLocal(LocalProduct local) {
    return Product(
      id: local.id,
      name: local.name,
      code: local.code,
      barcode: local.barcode,
      sellingPrice: local.sellingPrice,
      description: local.description,
      imagePath: local.imagePath,
      isActive: local.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'selling_price': sellingPrice,
      'image_path': imagePath,
    };
  }
}
