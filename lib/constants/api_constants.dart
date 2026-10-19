// customer_app/lib/constants/api_constants.dart

class ApiConstants {
  static const String appName = 'آپ مشتری';

  static const String baseUrl = 'https://app.koraarya.ir';
  //static const String baseUrl = 'http://127.0.0.1:8000';

  static const String wsUrl = 'wss://app.koraarya.ir';
  //static const String wsUrl = 'ws://127.0.0.1:8000';

  static String? getImageUrl(String? path) {
    if (path == null || path.trim().isEmpty) return null;
    if (path.startsWith('http')) return path;
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$baseUrl/$cleanPath';
  }

  static const String login = '$baseUrl/api/login/';

  static const String products = '$baseUrl/api/products/';
  static const String orders = '$baseUrl/api/orders/';

  static const String categories = '$baseUrl/api/catalog/categories/';
  static const String currency = '$baseUrl/api/catalog/currency/';

  static const String catalogCategories = '$baseUrl/api/catalog/categories/';
  static const String catalogProducts = '$baseUrl/api/catalog/products/';
  static const String catalogCurrency = '$baseUrl/api/catalog/currency/';

  static String catalogProduct(int id) => '$baseUrl/api/catalog/products/$id/';

  static String chatHistory(String userType, String userId) =>
      '$baseUrl/api/chat/history/$userType/$userId/';

  static String chatUnread(String userType, String userId) =>
      '$baseUrl/api/chat/unread_count/$userType/$userId';

  static const String ledgerHistory = '$baseUrl/api/ledger/history/';

  static const String myOrders = '$baseUrl/api/customer/orders/';
  static String myOrderDetail(String orderId) =>
      '$baseUrl/api/customer/orders/$orderId/';
}
