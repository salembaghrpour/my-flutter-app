// D:\accounting_Arya\mobile_app\customer_app\lib\services\chat_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/local/chat_message_local.dart';

class ChatService {
  
  // ==========================================
  // متدهای ارتباط با API
  // ==========================================
  
  // اضافه شدن پارامترهای limit و offset
  Future<List<Map<String, dynamic>>> getChatHistory(String userId, String userType, {int limit = 20, int offset = 0}) async {
    String baseUrlString = ApiConstants.chatHistory(userType, userId);
    
    // تشخیص اینکه آیا URL از قبل دارای Query Parameter هست یا نه تا علامت ? یا & قرار دهیم
    String connector = baseUrlString.contains('?') ? '&' : '?';
    final url = Uri.parse('$baseUrlString${connector}limit=$limit&offset=$offset'); 
    
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      
      if (response.statusCode == 200) {
        List data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((msg) => {
          "id": msg['id'], 
          "client_temp_id": msg['client_temp_id'], 
          "original_client_id": msg['original_client_id'], 
          "sender_type": msg['sender_type'],
          "content": msg['content'],
          "created_at": msg['created_at'],
          "is_read": msg['is_read'] ?? true,
          // --- دریافت فیلدهای جدید از سرور ---
          "message_type": msg['message_type'] ?? 'text',
          "file_url": msg['file_url'],
          "reply_to_id": msg['reply_to_id'],
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
      
      // شناسه یکتای ساخته شده در کنترلر
      final String uniqueId = message.clientTempId ?? message.localId!.toString();
      
      final response = await http.post(
        Uri.parse(url), 
        body: jsonEncode({
          'content': message.content,
          'user_id': message.conversationId, 
          'user_type': 'customer',
          'sender_type': 'customer',
          'client_temp_id': uniqueId, 
          'original_client_id': uniqueId, 
          // --- ارسال فیلدهای جدید به سمت سرور بک‌اند ---
          'message_type': message.messageType,
          'file_url': message.fileUrl,
          'reply_to_id': message.replyToId,
        }),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 15)); 
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'success': true, 
          'server_id': data['id'],
          'created_at': data['created_at'],
          'original_client_id': data['original_client_id'],
        };
      } else {
        print('HTTP Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Sync Error: $e');
    }
    return {'success': false};
  }

  Future<int> getUnreadCount(String userId, String userType) async {
    final url = Uri.parse(ApiConstants.chatUnread(userType, userId));
    final response = await http.get(url).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }
    final data = jsonDecode(utf8.decode(response.bodyBytes));
    return int.tryParse('${data['unread_count']}') ?? 0;
  }

}
