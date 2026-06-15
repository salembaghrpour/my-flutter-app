// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var token = ''.obs;
  var userId = ''.obs; 
  var profileId = ''.obs;
  
  // متغیر برای نگهداری نام مشتری جهت نمایش در هدر
  var userName = ''.obs; 

  bool get isLoggedIn => token.value.isNotEmpty;

  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('token');
    final savedUserId = prefs.getString('userId');
    final savedProfileId = prefs.getString('profileId'); 
    final savedUserName = prefs.getString('userName');

    if (savedToken != null && savedToken.isNotEmpty) {
      token.value = savedToken;
      if (savedUserId != null) userId.value = savedUserId;
      if (savedProfileId != null) profileId.value = savedProfileId;
      if (savedUserName != null) userName.value = savedUserName;
      
      Get.offAllNamed('/main');
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
        final prefs = await SharedPreferences.getInstance();
        
        await prefs.setString('token', user.token);
        await prefs.setString('userId', user.id.toString()); 
        await prefs.setString('profileId', user.profileId.toString()); 
        await prefs.setString('userName', user.username); // ذخیره نام مشتری در حافظه
        
        token.value = user.token;
        userId.value = user.id.toString();
        profileId.value = user.profileId.toString();
        userName.value = user.username;

        Get.offAllNamed('/main');
        
        // نمایش پیام خوش‌آمدگویی پس از ورود
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('profileId');
    await prefs.remove('userName');
    
    token.value = '';
    userId.value = '';
    profileId.value = '';
    userName.value = '';
    
    Get.offAllNamed('/login');
  }
}
