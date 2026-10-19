// lib/services/catalog/catalog_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/api_constants.dart';
import '../../models/catalog/catalog_detail.dart';

Map<String, dynamic> _normalizeProductMap(Map<String, dynamic> raw) {
  final map = Map<String, dynamic>.from(raw);
  final extra = map['extra_attributes'] ?? map['extraAttributes'];
  if (extra is String && extra.trim().isNotEmpty) {
    try {
      map['extra_attributes'] = json.decode(extra);
    } catch (_) {}
  }
  return map;
}

class CatalogApi {
  Future<CatalogDetail?> fetchProduct(int id) async {
    try {
      final response = await http
          .get(Uri.parse(ApiConstants.catalogProduct(id)))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;
      final body = json.decode(utf8.decode(response.bodyBytes));
      if (body is! Map) return null;
      return CatalogDetail.fromJson(
        _normalizeProductMap(Map<String, dynamic>.from(body)),
      );
    } catch (_) {
      return null;
    }
  }
}
