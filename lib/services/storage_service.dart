 // D:\accounting_Arya\mobile_app\customer_app\lib\services\storage_service.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  // این متد در ابتدای اجرای برنامه صدا زده می‌شود
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // ذخیره اطلاعات کاربر پس از لاگین
  Future<void> saveAuthData({
    required String token,
    required String userId,
    required String profileId,
    required String userName,
  }) async {
    await _prefs.setString('token', token);
    await _prefs.setString('userId', userId);
    await _prefs.setString('profileId', profileId);
    await _prefs.setString('userName', userName);
  }

  // پاک کردن اطلاعات کاربر برای خروج
  Future<void> clearAuthData() async {
    await _prefs.remove('token');
    await _prefs.remove('userId');
    await _prefs.remove('profileId');
    await _prefs.remove('userName');
  }

  // دریافت اطلاعات از حافظه
  String? get token => _prefs.getString('token');
  String? get userId => _prefs.getString('userId');
  String? get profileId => _prefs.getString('profileId');
  String? get userName => _prefs.getString('userName');

  // بررسی اینکه آیا کاربر لاگین است یا خیر
  bool get isLoggedIn => token != null && token!.isNotEmpty;
}
