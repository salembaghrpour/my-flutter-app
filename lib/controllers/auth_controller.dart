// D:\accounting_Arya\mobile_app\customer_app\lib\controllers\auth_controller.dart
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var token = ''.obs;
  var userId = ''.obs; 
  var profileId = ''.obs;
  var userName = ''.obs; 

  bool get isLoggedIn => token.value.isNotEmpty;

  final AuthService _authService = AuthService();
  // دریافت نمونه‌ی ساخته شده از StorageService
  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _loadUserDataFromStorage();
  }

  // بارگذاری داده‌ها از حافظه به متغیرهای کنترلر (در صورت لاگین بودن)
  void _loadUserDataFromStorage() {
    if (_storageService.isLoggedIn) {
      token.value = _storageService.token!;
      userId.value = _storageService.userId ?? '';
      profileId.value = _storageService.profileId ?? '';
      userName.value = _storageService.userName ?? '';
    }
  }

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('خطا', 'لطفاً نام کاربری و رمز عبور را وارد کنید.');
      return;
    }

    isLoading.value = true;
    try {
      final user = await _authService.login(username, password);
      
      if (user != null) {
        // ذخیره اصولی در حافظه گوشی توسط سرویس جدید
        await _storageService.saveAuthData(
          token: user.token,
          userId: user.id.toString(),
          profileId: user.profileId.toString(),
          userName: user.username,
        );
        
        // بروزرسانی متغیرهای حافظه در جریان اجرا
        token.value = user.token;
        userId.value = user.id.toString();
        profileId.value = user.profileId.toString();
        userName.value = user.username;

        // دریافت و ارسال توکن FCM به سرور
        try {
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            await _authService.updateFcmToken(user.id, fcmToken);
          }
        } catch (e) {
          print("Error getting/sending FCM token: $e");
        }

        // انتقال به صفحه اصلی
        Get.offAllNamed('/main');
        
        Get.snackbar(
          'ورود موفق',
          '${user.username} عزیز، خوش آمدید!',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar('خطای ورود', 'نام کاربری یا رمز عبور اشتباه است.');
      }
    } catch (e) {
      Get.snackbar('خطا', 'مشکلی در ارتباط با سرور پیش آمد.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    // پاک کردن اطلاعات از حافظه دستگاه
    await _storageService.clearAuthData();
    
    // پاک کردن اطلاعات متغیرها
    token.value = '';
    userId.value = '';
    profileId.value = '';
    userName.value = '';
    
    // بازگشت به صفحه لاگین
    Get.offAllNamed('/login');
  }
}
