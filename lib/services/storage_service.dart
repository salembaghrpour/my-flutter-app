import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService {
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> saveAuthData({
    required String token,
    required String profileId,
    required String userName,
  }) async {
    await _prefs.setString('token', token);
    await _prefs.setString('profileId', profileId);
    await _prefs.setString('userName', userName);
  }

  Future<void> clearAuthData() async {
    await _prefs.remove('token');
    await _prefs.remove('userId');
    await _prefs.remove('profileId');
    await _prefs.remove('userName');
  }

  String? get token => _prefs.getString('token');
  String? get profileId => _prefs.getString('profileId');
  String? get userName => _prefs.getString('userName');

  bool get isLoggedIn {
    final value = token;
    if (value == null) return false;
    final raw = value.trim();
    if (raw.isEmpty || raw == 'null' || raw == 'undefined') return false;
    return raw.split('.').length == 3;
  }
}
