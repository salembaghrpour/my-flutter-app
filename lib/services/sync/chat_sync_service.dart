import 'package:get/get.dart';
import '../local_db/chat_local_repository.dart';
import '../connectivity_service.dart';
import '../chat_service.dart'; 

class ChatSyncService extends GetxService {
  final ChatLocalRepository _localRepo = ChatLocalRepository();
  final ChatService _chatService = Get.find<ChatService>();
  final ConnectivityService _connectivity = Get.find<ConnectivityService>();

  @override
  void onInit() {
    super.onInit();
    ever(_connectivity.isConnected, (bool isConnected) {
      if (isConnected) {
        syncPendingMessages();
      }
    });
  }

  Future<void> syncPendingMessages() async {
    if (!_connectivity.isConnected.value) return;

    final unsyncedMessages = await _localRepo.getUnsyncedMessages();
    if (unsyncedMessages.isEmpty) return;

    print("تعداد ${unsyncedMessages.length} پیام برای همگام‌سازی...");

    for (var message in unsyncedMessages) {
      // اضافه شدن try-catch برای جلوگیری از توقف حلقه در صورت خطای شبکه
      try {
        final response = await _chatService.sendMessageToServer(message);
        
        if (response != null && response['success'] == true) {
          await _localRepo.markAsSynced(message.localId!, response['server_id']);
          print("پیام با موفقیت همگام‌سازی شد: ${message.localId}");
        }
      } catch (e) {
        print("خطا در همگام‌سازی پیام ${message.localId} (احتمال قطعی موقت): $e");
      }
      
      // وقفه کوتاه برای مدیریت بهتر ترافیک شبکه
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }
}
