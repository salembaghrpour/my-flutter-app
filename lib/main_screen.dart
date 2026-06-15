// lib/main_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/product_list_screen.dart';
import 'screens/cart_screen.dart'; 
import 'screens/support_chat_screen.dart'; 
import 'controllers/cart_controller.dart'; 
import 'controllers/auth_controller.dart';
import 'controllers/chat_controller.dart';

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    if (index == 3) {
      chatController.markAsRead();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(_pageTitles[_selectedIndex], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(width: 8),
                Obx(() => Text(
                  'سلام، ${authController.userName.value}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.white70),
                )),
              ],
            ),
            if (_selectedIndex == 3)
              Obx(() => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    chatController.isConnected.value ? Icons.circle : Icons.circle_outlined, 
                    color: chatController.isConnected.value ? Colors.greenAccent : Colors.redAccent, 
                    size: 10
                  ),
                  const SizedBox(width: 4),
                  Text(
                    chatController.isConnected.value ? 'آنلاین' : 'درحال اتصال...', 
                    style: const TextStyle(fontSize: 11, color: Colors.white70)
                  ),
                ],
              )),
          ],
        ),
        actions: [
          Obx(() => IconButton(
            icon: Icon(
              uiController.showImages.value ? Icons.visibility : Icons.visibility_off,
              color: Theme.of(context).colorScheme.secondary, 
            ),
            onPressed: () => uiController.toggleImages(),
            tooltip: 'نمایش/مخفی کردن تصاویر کالا',
          )),
          Obx(() => Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
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
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${cartController.totalItemsCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          )),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary, 
        unselectedItemColor: Colors.grey,
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
