// lib/screens/support_chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // برای کپی کردن متن اضافه شد
import 'package:get/get.dart';
import '../widgets/chat_bubble.dart';
import '../controllers/chat_controller.dart';

class SupportChatScreen extends StatefulWidget {
  final String customerId;

  const SupportChatScreen({Key? key, required this.customerId}) : super(key: key);

  @override
  _SupportChatScreenState createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatController chatController = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    chatController.isChatScreenOpen.value = true;
    
    // وقتی پیام جدیدی اضافه می‌شود، اسکرول به پایین برود
    ever(chatController.messages, (_) => _scrollToBottom());
    
    // اسکرول اولیه در زمان باز شدن صفحه
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    chatController.isChatScreenOpen.value = false;
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100, // کمی فضای بیشتر
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    final text = _messageController.text.trim();
    chatController.sendMessage(text);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar داخلی حذف شد تا تایتل بار دوتا نشود
      body: Obx(() {
        if (chatController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final msg = chatController.messages[index];
                  return GestureDetector(
                    // قابلیت نگه داشتن انگشت روی حباب پیام و باز شدن منوی کپی
                    onLongPressStart: (LongPressStartDetails details) {
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(
                          details.globalPosition.dx,
                          details.globalPosition.dy,
                          details.globalPosition.dx,
                          details.globalPosition.dy,
                        ),
                        items: [
                          const PopupMenuItem(
                            value: 'copy',
                            child: Text('کپی متن پیام', style: TextStyle(fontFamily: 'Vazirmatn')),
                          ),
                        ],
                      ).then((value) {
                        if (value == 'copy' && msg['text'] != null) {
                          Clipboard.setData(ClipboardData(text: msg['text']));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('متن پیام کپی شد', style: TextStyle(fontFamily: 'Vazirmatn')),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      });
                    },
                    child: ChatBubble(
                      text: msg['text'] ?? '',
                      isMe: msg['sender'] == 'customer',
                      timestamp: msg['timestamp'],
                      status: msg['status'],
                    ),
                  );
                },
              ),
            ),
            _buildMessageInput(),
          ],
        );
      }),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -1))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'پیام خود را بنویسید...',
                hintStyle: const TextStyle(fontFamily: 'Vazirmatn'),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0), borderSide: BorderSide.none),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blue.shade800,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20), 
              onPressed: _sendMessage
            ),
          ),
        ],
      ),
    );
  }
}
