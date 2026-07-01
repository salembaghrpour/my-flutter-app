import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../constants/api_constants.dart'; // مسیر جدید وارد شد

class ProductService {
  Future<List<Product>> fetchProducts() async {
    final url = Uri.parse(ApiConstants.products); 
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // پشتیبانی از کاراکترهای فارسی با utf8
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      // تبدیل JSON به لیست محصولات
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('خطا در دریافت اطلاعات از سرور');
    }
  }
}
