// D:\accounting_Arya\mobile_app\customer_app\lib\services\update_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UpdateService {
  // آدرس فایل JSON شامل اطلاعات نسخه جدید
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

        // اگر نسخه سرور از نسخه نصب شده جدیدتر بود
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
      barrierDismissible: false, // کاربر نتواند با کلیک در بیرون دیالوگ آن را ببندد
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('نسخه جدید در دسترس است ($version)', style: const TextStyle(fontFamily: 'Vazirmatn')),
          content: Text('تغییرات:\n$notes', style: const TextStyle(fontFamily: 'Vazirmatn')),
          actions: [
            TextButton(
              child: const Text('بعداً', style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: const Text('دانلود و نصب', style: TextStyle(fontFamily: 'Vazirmatn', color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop(); // بستن دیالوگ
                
                if (kIsWeb) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('برای دریافت نسخه جدید، صفحه را رفرش کنید (F5).', style: TextStyle(fontFamily: 'Vazirmatn')),
                      duration: Duration(seconds: 5),
                    ),
                  );
                } else {
                  _launchURL(downloadUrl);
                }
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        debugPrint('امکان باز کردن لینک وجود ندارد: $url');
      }
    } catch (e) {
      debugPrint('خطا در باز کردن لینک مرورگر: $e');
    }
  }
}
