// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تنظیمات',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'اعلان‌ها (Notifications)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.notifications_active, color: Colors.amber, size: 30),
              title: const Text('فعال‌سازی نوتیفیکیشن پیام‌ها'),
              subtitle: const Text('برای دریافت هشدار پیام جدید روی وب و آیفون، این گزینه را لمس کنید.'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await NotificationService.requestPermission();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('درخواست فعال‌سازی ارسال شد.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('فعال‌سازی'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
