// lib/services/connectivity_service.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'order_sync_service.dart'; // اضافه شد

class ConnectivityService extends GetxService {
  var isConnected = true.obs;
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    checkConnection();
    
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      _updateConnectionStatus(result);
    });
  }

  Future<void> checkConnection() async {
    try {
      final List<ConnectivityResult> connectivityResult = await _connectivity.checkConnectivity();
      _updateConnectionStatus(connectivityResult);
    } catch (e) {
      print("خطا در بررسی وضعیت اولیه شبکه: $e");
      isConnected.value = false; 
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    bool connected = !results.contains(ConnectivityResult.none);
    
    if (isConnected.value != connected) {
      isConnected.value = connected;
      
      if (connected) {
        print("اتصال برقرار شد - در حال ارسال سفارشات معلق...");
        // فراخوانی سرویس برای ارسال سفارشات آفلاین
        if (Get.isRegistered<OrderSyncService>()) {
          Get.find<OrderSyncService>().syncOfflineOrders();
        }
      } else {
        print("اتصال قطع شد - اپلیکیشن در حالت آفلاین قرار گرفت.");
      }
    }
  }
}
