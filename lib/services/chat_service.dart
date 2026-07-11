// lib/services/chat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/local/chat_message_local.dart';

class ChatService {
  
  // ==========================================
  // متدهای ارتباط با API
  // ==========================================
  Future<List<Map<String, dynamic>>> getChatHistory(String userId, String userType) async {
    final url = Uri.parse(ApiConstants.chatHistory(userType, userId)); 
    
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      
      if (response.statusCode == 200) {
        List data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((msg) => {
          "server_id": msg['id'],
          "sender": msg['sender_type'],
          "text": msg['content'],
          "timestamp": msg['created_at'],
          "status": "read",
          "is_read": msg['is_read'] ?? true,
        }).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch from server: $e');
    }
  }

  Future<Map<String, dynamic>?> sendMessageToServer(ChatMessageLocal message) async {
    try {
      final url = '${ApiConstants.baseUrl}/api/chat/send';
      
      final response = await http.post(
        Uri.parse(url), 
        body: jsonEncode({
          'content': message.content,
          'user_id': message.conversationId, 
          'customer_id': message.conversationId,
          'user_type': 'customer',
          'sender_type': 'customer',
          'client_temp_id': message.localId?.toString(), 
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 15)); 
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return {'success': true, 'server_id': data['id']};
      } else {
        print('HTTP Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Sync Error: $e');
    }
    return {'success': false};
  }
}
