// lib/screens/support_chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    
    // وقتی صفحه چت باز می‌شود، اگر پیام‌های جدیدی وجود دارد، آن‌ها را خوانده شده علامت می‌زنیم
    chatController.markAsRead();
    
    ever(chatController.messages, (_) {
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    });
    
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
        0.0, 
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
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        return Column(
          children: [
            _buildConnectionIndicator(),
            
            Expanded(
              child: chatController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      reverse: true, 
                      itemCount: chatController.messages.length,
                      itemBuilder: (context, index) {
                        final msg = chatController.messages[chatController.messages.length - 1 - index];
                        return _buildMessageItem(msg);
                      },
                    ),
            ),
            _buildMessageInput(),
          ],
        );
      }),
    );
  }

  Widget _buildConnectionIndicator() {
    return Obx(() {
      if (chatController.isConnected.value) {
        return Container(
          width: double.infinity,
          color: Colors.green.shade400,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: const Text(
            'متصل به سرور',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Vazirmatn'),
          ),
        );
      } else {
        return Container(
          width: double.infinity,
          color: Colors.orange.shade400, 
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: const Text(
            'آفلاین - پیام‌ها در صف ارسال قرار می‌گیرند',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Vazirmatn'),
          ),
        );
      }
    });
  }

  Widget _buildMessageItem(Map<String, dynamic> msg) {
    return GestureDetector(
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
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(28.0),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'پیام خود را بنویسید...',
                    hintStyle: TextStyle(fontFamily: 'Vazirmatn', fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sendMessage,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue.shade800,
                child: const Icon(
                  Icons.send, 
                  color: Colors.white, 
                  size: 20
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
