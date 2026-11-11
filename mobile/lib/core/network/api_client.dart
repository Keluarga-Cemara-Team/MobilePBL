import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  // URL backend default:
  // Untuk Android emulator: 10.0.2.2
  // Untuk iOS simulator / Desktop: 127.0.0.1
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:5000';
    if (Platform.isAndroid) return 'http://10.0.2.2:5000';
    return 'http://127.0.0.1:5000';
  }

  final HttpClient _httpClient = HttpClient()
    ..connectionTimeout = const Duration(seconds: 4);

  /// Mengirim data survei ke API backend WebPBL untuk evaluasi ML
  Future<Map<String, dynamic>?> predictBurnout(Map<String, dynamic> payload) async {
    final uri = Uri.parse('$baseUrl/assessment/api/predict');

    try {
      final request = await _httpClient.postUrl(uri);
      request.headers.contentType = ContentType.json;
      final bodyStr = jsonEncode(payload);
      request.write(bodyStr);

      final response = await request.close().timeout(const Duration(seconds: 4));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await response.transform(utf8.decoder).join();
        final json = jsonDecode(responseBody) as Map<String, dynamic>;
        debugPrint('ApiClient: Berhasil menerima respons dari API ML: $json');
        return json;
      } else {
        debugPrint('ApiClient: Server merespons dengan status ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ApiClient: Backend API ($uri) tidak terjangkau ($e). Menggunakan evaluasi lokal.');
    }
    return null;
  }
}

