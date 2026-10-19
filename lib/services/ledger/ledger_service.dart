import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../constants/api_constants.dart';
import '../../models/ledger/ledger_entry.dart';

class LedgerService {
  static const Duration _timeout = Duration(seconds: 15);

  static Future<List<LedgerEntry>> fetchLedgerHistory(String token) async {
    try {
      var cleanedToken = token.trim();
      if (cleanedToken.toLowerCase().startsWith('bearer ')) {
        cleanedToken = cleanedToken.substring(7).trim();
      }

      final response = await http
          .get(
            Uri.parse(ApiConstants.ledgerHistory),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $cleanedToken',
            },
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final decoded = json.decode(utf8.decode(response.bodyBytes));
        if (decoded is! List) {
          throw Exception('فرمت پاسخ سرور نامعتبر است');
        }
        return decoded
            .map<LedgerEntry>(
              (item) => LedgerEntry.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList();
      }

      throw Exception(
        'خطا در دریافت صورتحساب: ${response.statusCode} ${utf8.decode(response.bodyBytes)}',
      );
    } catch (e) {
      throw Exception('خطای ارتباط با سرور: $e');
    }
  }
}
