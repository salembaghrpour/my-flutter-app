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
  
  final RxBool showScrollToBottomFab = false.obs;

  @override
  void initState() {
    super.initState();
    chatController.isChatScreenOpen.value = true;
    chatController.markAsRead();
    
    _scrollController.addListener(() {
      if (_scrollController.offset > 200) {
        if (!showScrollToBottomFab.value) showScrollToBottomFab.value = true;
      } else {
        if (showScrollToBottomFab.value) showScrollToBottomFab.value = false;
      }

      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50) {
        chatController.loadMoreMessages();
      }
    });

    ever(chatController.messages, (_) {
      if (_scrollController.hasClients && _scrollController.offset < 100) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
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
    _scrollToBottom();
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                          reverse: true,
                          itemCount: chatController.messages.length + (chatController.isLoadingMore.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == chatController.messages.length) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: SizedBox(
                                    width: 24, 
                                    height: 24, 
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.amber)
                                  )
                                ),
                              );
                            }
                            final msg = chatController.messages[chatController.messages.length - 1 - index];
                            return _buildMessageItem(msg);
                          },
                        ),
                  // دکمه بازگشت به پایین در موقعیت جدید (بالای کادر ارسال، مرکز)
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Obx(() => showScrollToBottomFab.value
                          ? FloatingActionButton(
                              mini: true,
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
          color: Colors.green.shade500,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: const Text(
            'متصل به سرور',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold),
          ),
        );
      } else {
        return Container(
          width: double.infinity,
          color: Colors.orange.shade500, 
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: const Text(
            'آفلاین - پیام‌ها در صف ارسال قرار می‌گیرند',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), 
            blurRadius: 10, 
            offset: const Offset(0, -2)
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30.0), 
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.amber, 
                child: const Icon(
                  Icons.send_rounded, 
                  color: Colors.black87, 
                  size: 22
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 