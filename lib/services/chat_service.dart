// lib/services/chat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class ChatService {
  static Future<List<Map<String, dynamic>>> getChatHistory(String customerId) async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}/api/chat/history/$customerId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((msg) => {
          "sender": msg['sender_type'],
          "text": msg['content'],
          "timestamp": msg['created_at'],
          "status": "sent", // یا read/delivered
          "is_read": msg['is_read'] ?? false, // <--- این خط اضافه می‌شود
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching chat history: $e');
      return [];
    }
  }
}
