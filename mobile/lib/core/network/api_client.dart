import 'package:flutter/foundation.dart';
import '../storage/secure_storage.dart';
import 'api_client_stub.dart'
    if (dart.library.html) 'api_client_web.dart'
    if (dart.library.io) 'api_client_io.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  // URL backend default:
  // Untuk Android emulator: 10.0.2.2:5000
  // Untuk iOS simulator / Desktop / Web: 127.0.0.1:5000
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:5000';
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000';
    }
    return 'http://127.0.0.1:5000';
  }

  /// Mempersiapkan header HTTP lengkap dengan Access Token (Bearer) jika ada
  Future<Map<String, String>> _buildHeaders({Map<String, String>? customHeaders}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      ...?customHeaders,
    };

    final token = await SecureTokenStorage.instance.getAccessToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Mengirim data survei ke API backend WebPBL untuk evaluasi ML
  Future<Map<String, dynamic>?> predictBurnout(Map<String, dynamic> payload) async {
    final url = '$baseUrl/assessment/api/predict';

    try {
      final headers = await _buildHeaders();
      final result = await postJsonPlatform(url, payload, headers: headers);
      if (result != null) {
        debugPrint('ApiClient: Berhasil menerima respons dari API ML: $result');
      }
      return result;
    } catch (e) {
      debugPrint('ApiClient: Backend API ($url) tidak terjangkau ($e). Menggunakan evaluasi lokal.');
      return null;
    }
  }

  /// Refresh token jika access token kadaluarsa (HTTP 401)
  Future<bool> refreshAccessToken() async {
    final refreshToken = await SecureTokenStorage.instance.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    final url = '$baseUrl/auth/api/refresh';
    try {
      final res = await postJsonPlatform(url, {'refresh_token': refreshToken});
      if (res != null && res['access_token'] != null) {
        final newAccessToken = res['access_token'] as String;
        final newRefreshToken = (res['refresh_token'] as String?) ?? refreshToken;
        await SecureTokenStorage.instance.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
        return true;
      }
    } catch (e) {
      debugPrint('ApiClient refreshAccessToken error: $e');
    }
    return false;
  }
}
