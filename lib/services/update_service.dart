import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart'; // اضافه کردن این پکیج
import 'package:flutter/foundation.dart' show kIsWeb; // برای تشخیص وب بودن

class UpdateService {
  static const String _versionUrl = 'https://koraarya.ir/downloads/version.json';

  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      int currentBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;

      final response = await http.get(Uri.parse(_versionUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        
        int latestBuildNumber = data['build_number'] ?? 0;
        String latestVersion = data['latest_version'] ?? '';
        String downloadUrl = data['download_url'] ?? '';
        String releaseNotes = data['release_notes'] ?? '';

        if (latestBuildNumber > currentBuildNumber) {
          if (context.mounted) {
            _showUpdateDialog(context, latestVersion, releaseNotes, downloadUrl);
          }
        }
      }
    } catch (e) {
      debugPrint('خطا در بررسی آپدیت: $e');
    }
  }

  static void _showUpdateDialog(BuildContext context, String version, String notes, String downloadUrl) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('نسخه جدید در دسترس است ($version)'),
          content: Text('تغییرات:\n$notes'),
          actions: [
            TextButton(
              child: const Text('بعداً'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('دانلود و نصب'),
              onPressed: () {
                Navigator.of(context).pop();
                
                if (kIsWeb) {
                  // اگر برنامه تحت وب (مثل آیفون) است، فقط به کاربر می‌گوییم صفحه را رفرش کند
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('برای دریافت نسخه جدید، لطفاً برنامه را ببندید و دوباره باز کنید یا صفحه را رفرش کنید.')),
                  );
                } else {
                  // اگر اندروید است، لینک دانلود را در مرورگر باز می‌کنیم
                  _launchURL(downloadUrl);
                }
              },
            ),
          ],
        );
      },
    );
  }

  // متد جدید جایگزین ota_update
  static Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('امکان باز کردن لینک وجود ندارد: $url');
    }
  }
}
