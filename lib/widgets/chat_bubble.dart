// lib/widgets/chat_bubble.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String? timestamp;
  final String? status; // 'sent', 'read', etc.
  final bool isRead; // فیلد جدید برای راحتی در بررسی تیک دوم

  const ChatBubble({
    Key? key,
    required this.text,
    required this.isMe,
    this.timestamp,
    this.status,
    this.isRead = false, // پیش‌فرض خوانده نشده
  }) : super(key: key);

  String _formatTime() {
    if (timestamp == null) return '';
    try {
      final dt = DateTime.parse(timestamp!).toLocal();
      final now = DateTime.now();
      
      // اگر پیام برای امروز است فقط ساعت، در غیر این صورت تاریخ و ساعت
      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        return DateFormat('HH:mm').format(dt);
      } else {
        return DateFormat('yyyy/MM/dd HH:mm').format(dt);
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // ترکیب دو حالت برای اطمینان از نمایش درست تیک
    final bool showDoubleTick = isRead || status == 'read';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 14),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(),
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    showDoubleTick ? Icons.done_all : Icons.check,
                    size: 15,
                    color: showDoubleTick ? Colors.blue.shade700 : Colors.grey.shade600,
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
