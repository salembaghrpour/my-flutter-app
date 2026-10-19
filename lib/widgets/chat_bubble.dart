import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/api_constants.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String? timestamp;
  final String? status;
  final bool isRead;
  final String messageType;
  final String? fileUrl;
  final Map<String, dynamic>? repliedMessage;

  const ChatBubble({
    Key? key,
    required this.text,
    required this.isMe,
    this.timestamp,
    this.status,
    this.isRead = false,
    this.messageType = 'text',
    this.fileUrl,
    this.repliedMessage,
  }) : super(key: key);

  String _formatTime() {
    if (timestamp == null || timestamp!.isEmpty) return '';
    try {
      final date = DateTime.parse(timestamp!).toLocal();
      final now = DateTime.now();
      final sameDay = date.year == now.year && date.month == now.month && date.day == now.day;
      return DateFormat(sameDay ? 'HH:mm' : 'yyyy/MM/dd HH:mm').format(date);
    } catch (_) {
      return '';
    }
  }

  String _absoluteUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    final base = ApiConstants.baseUrl.endsWith('/')
        ? ApiConstants.baseUrl.substring(0, ApiConstants.baseUrl.length - 1)
        : ApiConstants.baseUrl;
    return url.startsWith('/') ? '$base$url' : '$base/$url';
  }

  Future<void> _openFile(BuildContext context) async {
    final raw = fileUrl;
    if (raw == null || raw.isEmpty) return;
    final uri = Uri.tryParse(_absoluteUrl(raw));
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فایل باز نشد', style: TextStyle(fontFamily: 'Vazirmatn')),
        ),
      );
    }
  }

  Widget _buildStatusIcon() {
    if (!isMe) return const SizedBox.shrink();
    if (status == 'sending') return const Icon(Icons.access_time, size: 14, color: Colors.black45);
    if (status == 'failed' || status == 'error') return Icon(Icons.cloud_off, size: 14, color: Colors.red.shade700);
    if (isRead || status == 'read') return Icon(Icons.done_all, size: 15, color: Colors.blue.shade700);
    return const Icon(Icons.check, size: 15, color: Colors.black54);
  }

  Widget _buildRepliedMessagePreview() {
    final message = repliedMessage;
    if (message == null) return const SizedBox.shrink();
    final type = (message['message_type'] ?? 'text').toString();
    final replyText = type == 'image'
        ? 'تصویر'
        : type == 'file'
            ? ((message['text'] ?? '').toString().trim().isEmpty ? 'فایل' : message['text'].toString())
            : (message['text'] ?? '').toString();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border(right: BorderSide(color: Colors.amber.shade700, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message['sender'] == 'customer' ? 'شما' : 'پشتیبانی',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade800,
              fontFamily: 'Vazirmatn',
            ),
          ),
          const SizedBox(height: 2),
          Text(
            replyText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: Colors.black87, fontFamily: 'Vazirmatn'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = messageType == 'image' && fileUrl != null && fileUrl!.isNotEmpty;
    final hasFile = messageType == 'file' && fileUrl != null && fileUrl!.isNotEmpty;
    final fileName = text.trim().isEmpty ? 'فایل' : text.trim();

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Colors.amber.shade200 : Colors.blue.shade50,
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
            _buildRepliedMessagePreview(),
            if (hasImage)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _absoluteUrl(fileUrl!),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            if (hasFile)
              InkWell(
                onTap: () => _openFile(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.insert_drive_file_outlined),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          fileName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13),
                        ),
                      ),
                      const Icon(Icons.open_in_new, size: 18),
                    ],
                  ),
                ),
              ),
            if (text.isNotEmpty && messageType != 'file')
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
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
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
