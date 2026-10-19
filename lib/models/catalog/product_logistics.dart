class ProductLogistics {
  final bool isNegligible;
  final double weightKg;
  final double lengthCm;
  final double widthCm;
  final double heightCm;
  final bool isFragile;
  final bool isRefrigerated;
  final String? loadingType;

  const ProductLogistics({
    this.isNegligible = false,
    this.weightKg = 0,
    this.lengthCm = 0,
    this.widthCm = 0,
    this.heightCm = 0,
    this.isFragile = false,
    this.isRefrigerated = false,
    this.loadingType,
  });

  factory ProductLogistics.fromJson(Map<String, dynamic> json) {
    return ProductLogistics(
      isNegligible: json['is_negligible'] == true,
      weightKg: (json['weight_kg'] as num?)?.toDouble() ?? 0,
      lengthCm: (json['length_cm'] as num?)?.toDouble() ?? 0,
      widthCm: (json['width_cm'] as num?)?.toDouble() ?? 0,
      heightCm: (json['height_cm'] as num?)?.toDouble() ?? 0,
      isFragile: json['is_fragile'] == true,
      isRefrigerated: json['is_refrigerated'] == true,
      loadingType: json['loading_type'] as String?,
    );
  }

  String get sizeLabel {
    if (isNegligible || (lengthCm + widthCm + heightCm) == 0) return '';
    return '${lengthCm.toStringAsFixed(0)}×${widthCm.toStringAsFixed(0)}×${heightCm.toStringAsFixed(0)} سانتی‌متر';
  }
}
