// lib/widgets/chat_bubble.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String? timestamp;
  final String? status; 
  final bool isRead;

  const ChatBubble({
    Key? key,
    required this.text,
    required this.isMe,
    this.timestamp,
    this.status,
    this.isRead = false,
  }) : super(key: key);

  String _formatTime() {
    if (timestamp == null) return '';
    try {
      final dt = DateTime.parse(timestamp!).toLocal();
      final now = DateTime.now();
      
      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        return DateFormat('HH:mm').format(dt);
      } else {
        return DateFormat('yyyy/MM/dd HH:mm').format(dt);
      }
    } catch (e) {
      return '';
    }
  }

  Widget _buildStatusIcon() {
    if (!isMe) return const SizedBox.shrink();

    if (status == 'sending') {
      return const Icon(Icons.access_time, size: 14, color: Colors.black45);
    } else if (status == 'offline') {
      return Icon(Icons.cloud_off, size: 14, color: Colors.red.shade700);
    } else if (isRead || status == 'read') {
      return Icon(Icons.done_all, size: 15, color: Colors.blue.shade700);
    } else { 
      return const Icon(Icons.check, size: 15, color: Colors.black54);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
          // تغییر رنگ حباب دریافتی به آبی ملایم
          color: isMe ? Colors.amber.shade200 : Colors.blue.shade50, 
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            )
          ],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2.0),
              child: Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Vazirmatn', 
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(),
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  _buildStatusIcon(),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
