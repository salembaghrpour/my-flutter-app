import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/chat/chat_controller.dart';
import '../services/chat_media_service.dart';
import '../widgets/chat_bubble.dart';

class SupportChatScreen extends StatefulWidget {
  final String customerId;

  const SupportChatScreen({Key? key, required this.customerId}) : super(key: key);

  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatController chatController = Get.find<ChatController>();
  final ChatMediaService _mediaService = ChatMediaService();
  final RxBool showScrollToBottomFab = false.obs;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    chatController.isChatScreenOpen.value = true;
    chatController.ensureSession(widget.customerId);
    chatController.markAsRead();

    _scrollController.addListener(() {
      final showButton = _scrollController.offset > 200;
      if (showScrollToBottomFab.value != showButton) {
        showScrollToBottomFab.value = showButton;
      }
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        chatController.loadMoreMessages();
      }
    });

    ever(chatController.messages, (_) {
      if (_scrollController.hasClients && _scrollController.offset < 100) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    chatController.isChatScreenOpen.value = false;
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    _messageController.clear();
    chatController.sendMessage(text);
    _scrollToBottom();
  }

  String _previewText(Map<String, dynamic> message) {
    final type = (message['message_type'] ?? 'text').toString();
    if (type == 'image') return 'تصویر';
    if (type == 'file') {
      return (message['text'] ?? '').toString().trim().isEmpty
          ? 'فایل'
          : message['text'].toString();
    }
    return (message['text'] ?? '').toString();
  }

  Future<void> _pickImage() async {
    final url = await _mediaService.pickAndUploadImage();
    if (url == null) return;
    await chatController.sendMessage('', messageType: 'image', fileUrl: url);
    _scrollToBottom();
  }

  Future<void> _pickFile() async {
    final result = await _mediaService.pickAndUploadFile();
    if (result == null) return;
    await chatController.sendMessage(result.name, messageType: 'file', fileUrl: result.url);
    _scrollToBottom();
  }

  Future<void> _showAttachMenu() async {
    if (_uploading) return;
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: const Text('تصویر', style: TextStyle(fontFamily: 'Vazirmatn')),
              onTap: () => Navigator.pop(context, 'image'),
            ),
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text('فایل', style: TextStyle(fontFamily: 'Vazirmatn')),
              subtitle: const Text(
                'PDF، ZIP، Office و متن؛ حداکثر ۲۰ مگابایت',
                style: TextStyle(fontFamily: 'Vazirmatn'),
              ),
              onTap: () => Navigator.pop(context, 'file'),
            ),
          ],
        ),
      ),
    );
    if (choice == null) return;

    setState(() => _uploading = true);
    try {
      if (choice == 'image') {
        await _pickImage();
      } else {
        await _pickFile();
      }
    } catch (error) {
      Get.snackbar(
        'خطا',
        error.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      body: Obx(() {
        return Column(
          children: [
            _buildConnectionIndicator(),
            Expanded(
              child: Stack(
                children: [
                  chatController.isLoading.value
                      ? const Center(child: CircularProgressIndicator(color: Colors.amber))
                      : ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          itemCount: chatController.messages.length +
                              (chatController.isLoadingMore.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == chatController.messages.length) {
                              return const Padding(
                                padding: EdgeInsets.all(8),
                                child: Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                              );
                            }
                            final message = chatController
                                .messages[chatController.messages.length - 1 - index];
                            return _buildMessageItem(message);
                          },
                        ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Obx(() => showScrollToBottomFab.value
                          ? FloatingActionButton.small(
                              backgroundColor: Colors.white,
                              onPressed: _scrollToBottom,
                              child: const Icon(Icons.keyboard_arrow_down, color: Colors.blue),
                            )
                          : const SizedBox.shrink()),
                    ),
                  ),
                ],
              ),
            ),
            _buildReplyPreview(),
            _buildMessageInput(),
          ],
        );
      }),
    );
  }

  Widget _buildConnectionIndicator() {
    return Obx(() {
      final socket = chatController.socketConnected.value;
      final network = chatController.isConnected.value;
      final Color color = socket
          ? Colors.green.shade500
          : network
              ? Colors.amber.shade700
              : Colors.orange.shade500;
      final String text = socket
          ? 'متصل به سرور'
          : network
              ? 'در حال اتصال به چت...'
              : 'آفلاین - پیام‌ها در صف ارسال قرار می‌گیرند';

      return Container(
        width: double.infinity,
        color: color,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    return GestureDetector(
      onLongPressStart: (details) async {
        final value = await showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            details.globalPosition.dx,
            details.globalPosition.dy,
          ),
          items: const [
            PopupMenuItem(value: 'reply', child: Text('پاسخ دادن', style: TextStyle(fontFamily: 'Vazirmatn'))),
            PopupMenuItem(value: 'copy', child: Text('کپی متن', style: TextStyle(fontFamily: 'Vazirmatn'))),
          ],
        );
        if (value == 'reply') {
          chatController.setReplyMessage(message);
        } else if (value == 'copy') {
          final text = _previewText(message);
          if (text.isEmpty) return;
          await Clipboard.setData(ClipboardData(text: text));
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('کپی شد', style: TextStyle(fontFamily: 'Vazirmatn')),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: ChatBubble(
        text: message['text'] ?? '',
        isMe: message['sender'] == 'customer',
        timestamp: message['timestamp'],
        status: message['status'],
        messageType: message['message_type'] ?? 'text',
        fileUrl: message['file_url'],
        repliedMessage: chatController.getMessageById(message['reply_to_id']),
      ),
    );
  }

  Widget _buildReplyPreview() {
    final message = chatController.replyToMessage.value;
    if (message == null) return const SizedBox.shrink();
    final type = (message['message_type'] ?? 'text').toString();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Icon(
            type == 'image'
                ? Icons.image
                : type == 'file'
                    ? Icons.attach_file
                    : Icons.reply,
            color: Colors.amber.shade700,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['sender'] == 'customer' ? 'در حال پاسخ به خودتان' : 'در حال پاسخ به پشتیبانی',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: 'Vazirmatn',
                    color: Colors.amber,
                  ),
                ),
                Text(
                  _previewText(message),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontFamily: 'Vazirmatn'),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: chatController.cancelReply,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              onPressed: _uploading ? null : _showAttachMenu,
              icon: _uploading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.attach_file, color: Colors.grey, size: 28),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300, width: 0.5),
                ),
                child: TextField(
                  controller: _messageController,
                  minLines: 1,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'پیام خود را بنویسید...',
                    hintStyle: TextStyle(fontFamily: 'Vazirmatn', fontSize: 14, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.amber,
                child: Icon(Icons.send_rounded, color: Colors.black87, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
