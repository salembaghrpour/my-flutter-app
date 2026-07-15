// lib/main_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'screens/product_list_screen.dart';
import 'screens/cart_screen.dart'; 
import 'screens/support_chat_screen.dart'; 
import 'screens/settings_screen.dart';
import 'controllers/cart_controller.dart'; 
import 'controllers/auth_controller.dart';
import 'controllers/chat_controller.dart';
import 'services/update_service.dart';

class UIController extends GetxController {
  var showImages = false.obs;
  void toggleImages() {
    showImages.value = !showImages.value;
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  final CartController cartController = Get.put(CartController());
  final AuthController authController = Get.find<AuthController>();
  final ChatController chatController = Get.put(ChatController());
  final UIController uiController = Get.put(UIController()); 

  List<String> get _pageTitles => [
    'کاتالوگ محصولات',
    'سبد خرید',
    'سفارشات',
    'پشتیبانی آنلاین',
  ];

  List<Widget> get _pages => [
    const ProductListScreen(),
    const CartScreen(), 
    const Center(child: Text('سفارشات من (به زودی)')),
    SupportChatScreen(customerId: authController.profileId.value), 
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateService.checkForUpdate(context);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    if (index == 3) {
      chatController.markAsRead();
    }
  }

  void _showVersionDialog() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('درباره اپلیکیشن', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min, // این خط برای جلوگیری از اشغال کل ارتفاع صفحه است
            children: [
              Text('نسخه: $version', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8), // فاصله بین دو خط
              Text('بیلد: $buildNumber', style: const TextStyle(fontSize: 16)),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('بستن'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber, 
        title: Text(
          _pageTitles[_selectedIndex], 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)
        ),
        // اضافه کردن بخش جدید در زیر AppBar برای جلوگیری از تداخل متن با دکمه‌ها
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Container(
            color: Colors.amber.shade400,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                  'سلام، ${authController.userName.value}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                )),
                if (_selectedIndex == 3)
                  Obx(() => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        chatController.isConnected.value ? Icons.circle : Icons.circle_outlined, 
                        color: chatController.isConnected.value ? Colors.green.shade800 : Colors.red.shade800, 
                        size: 10
                      ),
                      const SizedBox(width: 4),
                      Text(
                        chatController.isConnected.value ? 'آنلاین' : 'درحال اتصال...', 
                        style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500)
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
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
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1; 
                  });
                },
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
                )
            ],
          )),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black87),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber, // نوار دکمه‌های پایین به رنگ طلایی
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black87, // رنگ تیره برای آیتم انتخاب شده روی طلایی
        unselectedItemColor: Colors.black54, // رنگ خاکستری تیره برای آیتم‌های دیگر
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'محصولات',
          ),
          BottomNavigationBarItem(
            icon: Obx(() {
              return Badge(
                isLabelVisible: cartController.totalItemsCount > 0, 
                label: Text(
                  cartController.totalItemsCount.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                child: const Icon(Icons.shopping_cart_outlined),
              );
            }),
            label: 'سبد خرید',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'سفارشات',
          ),
          BottomNavigationBarItem(
            icon: Obx(() {
              return Badge(
                isLabelVisible: chatController.unreadCount.value > 0,
                label: Text(
                  chatController.unreadCount.value.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                child: const Icon(Icons.support_agent_outlined),
              );
            }),
            label: 'پشتیبانی',
          ),
        ],
      ),
    );
  }
}
