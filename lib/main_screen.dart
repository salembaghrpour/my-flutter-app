// lib/main_screen.dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import 'screens/product_list_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/support_chat_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/ledger/ledger_screen.dart';
import 'screens/my_orders/my_orders_screen.dart';
import 'controllers/cart_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/chat/chat_controller.dart';
import 'controllers/ui_controller.dart';
import 'controllers/currency_controller.dart';
import 'constants/api_constants.dart';
import 'services/update_service.dart';
import 'widgets/premium_message_box.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Timer? _unreadTimer;
  Worker? _profileWorker;

  final CartController cartController = Get.put(CartController());
  final AuthController authController = Get.find<AuthController>();
  final ChatController chatController = Get.put(ChatController());
  final UIController uiController = Get.put(UIController());
  final CurrencyController currencyController = Get.put(CurrencyController());

  static const List<String> _pageTitles = [
    'کاتالوگ محصولات',
    'سبد خرید',
    'سفارشات',
    'صورتحساب',
    'پشتیبانی آنلاین',
  ];

  @override
  void initState() {
    super.initState();
    chatController.isChatScreenOpen.value = false;

    _profileWorker = ever(authController.profileId, (_) {
      _ensureChatConnected();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateService.checkForUpdate(context);
      _ensureChatConnected();
    });

    _unreadTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      _refreshUnread();
    });
  }

  @override
  void dispose() {
    _unreadTimer?.cancel();
    _profileWorker?.dispose();
    super.dispose();
  }

  String _httpBase() {
    var raw = ApiConstants.wsUrl.trim();
    if (raw.endsWith('/')) raw = raw.substring(0, raw.length - 1);
    if (raw.startsWith('wss://')) {
      raw = 'https://${raw.substring(6)}';
    } else if (raw.startsWith('ws://')) {
      raw = 'http://${raw.substring(5)}';
    }
    const suffix = '/api/chat';
    if (raw.endsWith(suffix)) {
      raw = raw.substring(0, raw.length - suffix.length);
    }
    return raw;
  }

  void _ensureChatConnected() {
    final id = authController.profileId.value.trim();
    if (id.isEmpty) return;

    chatController.ensureSession(id);
    chatController.isChatScreenOpen.value = _selectedIndex == 4;
    _refreshUnread();
  }
  
  Future<void> _refreshUnread() async {
    if (authController.profileId.value.trim().isEmpty ||
        chatController.isChatScreenOpen.value) {
      return;
    }

    final before = chatController.unreadCount.value;
    await chatController.refreshUnreadCount();

    if (chatController.unreadCount.value < before) {
      chatController.unreadCount.value = before;
    }
    print('Unread kept -> ${chatController.unreadCount.value}');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    final isChatTab = index == 4;
    chatController.isChatScreenOpen.value = isChatTab;

    final id = authController.profileId.value.trim();
    if (id.isNotEmpty) {
      chatController.ensureSession(id);
    }

    if (isChatTab) {
      chatController.unreadCount.value = 0;
      chatController.markAsRead();
    } else {
      _refreshUnread();
    }
  }

  void _showVersionDialog() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('درباره اپلیکیشن', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('نسخه: ${packageInfo.version}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('بیلد: ${packageInfo.buildNumber}', style: const TextStyle(fontSize: 16)),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('بستن'),
          ),
        ],
      ),
    );
  }

  Widget _pageAt(int index) {
    switch (index) {
      case 0:
        return const ProductListScreen();
      case 1:
        return const CartScreen();
      case 2:
        return const MyOrdersScreen();
      case 3:
        return const LedgerScreen();
      case 4:
        return Obx(() {
          final id = authController.profileId.value.trim();
          if (id.isEmpty) {
            return const Center(
              child: Text(
                'شناسه مشتری هنوز آماده نیست',
                style: TextStyle(fontFamily: 'Vazirmatn'),
              ),
            );
          }
          return SupportChatScreen(
            key: ValueKey('support-$id'),
            customerId: id,
          );
        });
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _chatTabIcon(int count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.support_agent_outlined),
        if (count > 0)
          Positioned(
            right: -8,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                count > 99 ? '99+' : '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          _pageTitles[_selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32),
          child: Container(
            color: Colors.amber.shade400,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() {
                    final userName = authController.userName.value;
                    final currencyName = currencyController.baseName;
                    final catalogUpdated = currencyController.catalogUpdatedText;

                    return Row(
                      children: [
                        Flexible(
                          child: Text(
                            'سلام، $userName',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ),
                        if (currencyName.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(
                            'ارز پایه: $currencyName',
                            maxLines: 1,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
                          ),
                        ],
                        if (catalogUpdated.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              catalogUpdated,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black87),
                            ),
                          ),
                        ],
                      ],
                    );
                  }),
                ),
                if (_selectedIndex == 4)
                  Obx(() => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            chatController.socketConnected.value ? Icons.circle : Icons.circle_outlined,
                            color: chatController.socketConnected.value
                                ? Colors.green.shade800
                                : Colors.red.shade800,
                            size: 11,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            chatController.socketConnected.value ? 'آنلاین' : 'در حال اتصال...',
                            style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500),
                          ),
                        ],
                      )),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
            tooltip: 'تنظیمات',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black87),
            onPressed: _showVersionDialog,
            tooltip: 'نسخه اپلیکیشن',
          ),
          Obx(() => IconButton(
                icon: Icon(
                  uiController.showImages.value ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black87,
                ),
                onPressed: () => uiController.toggleImages(),
                tooltip: 'نمایش/مخفی کردن تصاویر کالا',
              )),
          Obx(() => Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart, color: Colors.black87),
                    onPressed: () => _onItemTapped(1),
                  ),
                  if (cartController.totalItemsCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          '${cartController.totalItemsCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              )),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black87),
            onPressed: () {
              PremiumMessageBox.show(
                context: context,
                title: 'خروج از حساب',
                message: 'آیا مطمئن هستید که می‌خواهید از حساب کاربری خود خارج شوید؟',
                confirmText: 'بله، خروج',
                cancelText: 'خیر',
                onConfirm: () => authController.logout(),
              );
            },
          ),
        ],
      ),
      body: _pageAt(_selectedIndex),
      bottomNavigationBar: Obx(() {
        final unread = chatController.unreadCount.value;
        return BottomNavigationBar(
          key: ValueKey('nav-$unread'),
          backgroundColor: Colors.amber,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black87,
          unselectedItemColor: Colors.black54,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              label: 'محصولات',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'سبد خرید',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              label: 'سفارشات',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'صورتحساب',
            ),
            BottomNavigationBarItem(
              icon: _chatTabIcon(unread),
              label: unread > 0 ? 'چت ($unread)' : 'صفحه چت',

            ),
          ],
        );
      }),
    );
  }
}
