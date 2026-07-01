import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart'; 

class ChatService {
  // اضافه کردن userType و تغییر نام پارامتر به userId برای هماهنگی با بک‌اند
  static Future<List<Map<String, dynamic>>> getChatHistory(String userId, String userType) async {
    // فراخوانی متد با دو پارامتر
    final url = Uri.parse(ApiConstants.chatHistory(userType, userId)); 
    
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // تبدیل پاسخ دریافتی که UTF-8 است (برای پشتیبانی از حروف فارسی)
        List data = jsonDecode(utf8.decode(response.bodyBytes));
        return data.map((msg) => {
          "sender": msg['sender_type'],
          "text": msg['content'],
          "timestamp": msg['created_at'],
          "status": "sent", // یا read/delivered
          "is_read": msg['is_read'] ?? false,
        }).toList();
      } else {
        print('Failed to load chat history: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching chat history: $e');
      return [];
    }
  }
}
 