import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ota_update/ota_update.dart';

class UpdateService {
  // آدرس دقیق فایل version.json در هاست نت‌افراز شما
  static const String _versionUrl = 'https://koraarya.ir/downloads/version.json';

  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      // ۱. دریافت بیلد نامبر نسخه فعلی روی گوشی کاربر
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      int currentBuildNumber = int.tryParse(packageInfo.buildNumber) ?? 0;

      // ۲. دریافت اطلاعات از سرور شما
      final response = await http.get(Uri.parse(_versionUrl));
      
      if (response.statusCode == 200) {
        // مشکل حروف فارسی را هندل می‌کنیم
        final data = json.decode(utf8.decode(response.bodyBytes));
        
        int latestBuildNumber = data['build_number'] ?? 0;
        String latestVersion = data['latest_version'] ?? '';
        String downloadUrl = data['download_url'] ?? '';
        String releaseNotes = data['release_notes'] ?? '';

        // ۳. بررسی نیاز به آپدیت
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
      barrierDismissible: false, // کاربر نتواند با کلیک بیرون، آن را ببندد (اگر آپدیت اجباری است)
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
                _executeOtaUpdate(context, downloadUrl);
              },
            ),
          ],
        );
      },
    );
  }

  static void _executeOtaUpdate(BuildContext context, String downloadUrl) {
    // نمایش یک اسنک‌بار برای اطلاع به کاربر
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('در حال دانلود نسخه جدید. لطفاً منتظر بمانید...')),
    );

    try {
      OtaUpdate().execute(
        downloadUrl,
        destinationFilename: 'koraarya_update.apk',
      ).listen(
        (OtaEvent event) {
          if (event.status == OtaStatus.DOWNLOADING) {
            // می‌توانید در اینجا یک پروگرس‌بار آپدیت کنید
            debugPrint('درصد دانلود: ${event.value}');
          } else if (event.status == OtaStatus.INSTALLING) {
            debugPrint('در حال نصب...');
          } else if (event.status == OtaStatus.PERMISSION_NOT_GRANTED_ERROR) {
            debugPrint('خطای دسترسی نصب');
          }
        },
      );
    } catch (e) {
      debugPrint('خطا در دانلود آپدیت: $e');
    }
  }
}
