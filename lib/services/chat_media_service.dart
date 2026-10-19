import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../constants/api_constants.dart';

class UploadedChatFile {
  final String url;
  final String name;

  const UploadedChatFile({required this.url, required this.name});
}

class ChatMediaService {
  static const int _maxImageBytes = 5 * 1024 * 1024;
  static const int _maxFileBytes = 20 * 1024 * 1024;
  static const Set<String> _allowedExtensions = {
    'pdf', 'zip', 'rar', '7z', 'doc', 'docx',
    'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'csv',
  };
  static const Set<String> _blockedExtensions = {
    'exe', 'bat', 'cmd', 'com', 'msi', 'scr', 'ps1',
    'vbs', 'js', 'jar', 'dll', 'apk', 'hta',
  };

  final ImagePicker _picker = ImagePicker();

  Future<String?> pickAndUpload() => pickAndUploadImage();

  Future<String?> pickAndUploadImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 2048, imageQuality: 85);
    if (picked == null) return null;
    if (await picked.length() > _maxImageBytes) {
      throw Exception('حجم تصویر بیشتر از ۵ مگابایت است.');
    }
    final bytes = await picked.readAsBytes();
    final uploaded = await _upload(bytes, picked.name.isEmpty ? 'image.jpg' : picked.name);
    return uploaded.url;
  }

  Future<UploadedChatFile?> pickAndUploadFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true, type: FileType.custom, allowedExtensions: _allowedExtensions.toList());
    if (result == null || result.files.isEmpty) return null;

    final file = result.files.single;
    final name = file.name.trim().isEmpty ? 'file.bin' : file.name.trim();
    final extension = name.contains('.') ? name.split('.').last.toLowerCase() : '';
    if (_blockedExtensions.contains(extension) || !_allowedExtensions.contains(extension)) {
      throw Exception('این نوع فایل مجاز نیست.');
    }

    final bytes = file.bytes;
    if (bytes == null) throw Exception('خواندن فایل ممکن نشد.');
    if (bytes.length > _maxFileBytes) throw Exception('حجم فایل بیشتر از ۲۰ مگابایت است.');
    return _upload(bytes, name);
  }

  Future<UploadedChatFile> _upload(List<int> bytes, String filename) async {
    final base = ApiConstants.baseUrl.endsWith('/') ? ApiConstants.baseUrl.substring(0, ApiConstants.baseUrl.length - 1) : ApiConstants.baseUrl;
    final request = http.MultipartRequest('POST', Uri.parse('$base/api/chat/media/upload'));
    request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));

    final streamed = await request.send().timeout(const Duration(seconds: 60));
    final body = await streamed.stream.bytesToString();
    if (streamed.statusCode != 200) {
      throw Exception('خطا در آپلود: ${streamed.statusCode} $body');
    }

    final data = jsonDecode(body);
    if (data is! Map<String, dynamic>) throw Exception('پاسخ آپلود نامعتبر است.');
    final url = data['file_url']?.toString() ?? '';
    if (url.isEmpty) throw Exception('پاسخ آپلود فاقد آدرس فایل است.');
    return UploadedChatFile(url: url, name: data['file_name']?.toString().trim().isNotEmpty == true ? data['file_name'].toString() : filename);
  }
}
