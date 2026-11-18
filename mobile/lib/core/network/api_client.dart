import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../storage/secure_storage.dart';
import 'api_exception.dart';
import 'api_client_stub.dart'
    if (dart.library.html) 'api_client_web.dart'
    if (dart.library.io) 'api_client_io.dart';

export 'api_exception.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  /// Mendapatkan Base URL API backend dinamis dari AppConfig
  static String get baseUrl => AppConfig.apiBaseUrl;

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
  /// Dilengkapi penanganan 401 Unauthorized otomatis dengan refresh token & retry
  Future<Map<String, dynamic>?> predictBurnout(Map<String, dynamic> payload) async {
    final url = '$baseUrl/assessment/api/predict';

    try {
      final headers = await _buildHeaders();
      final result = await postJsonPlatform(url, payload, headers: headers);
      if (result != null) {
        debugPrint('ApiClient: Berhasil menerima respons dari API ML: $result');
      }
      return result;
    } on ApiException catch (e) {
      if (e.isUnauthorized) {
        debugPrint('ApiClient: Sesi API 401 Unauthorized, mencoba refresh token...');
        final refreshed = await refreshAccessToken();
        if (refreshed) {
          try {
            final retryHeaders = await _buildHeaders();
            final retryResult = await postJsonPlatform(url, payload, headers: retryHeaders);
            if (retryResult != null) {
              debugPrint('ApiClient: Sukses setelah refresh token!');
              return retryResult;
            }
          } catch (retryErr) {
            debugPrint('ApiClient: Retry setelah refresh gagal ($retryErr)');
          }
        }
      }
      debugPrint('ApiClient: ApiException status ${e.statusCode}: ${e.message}');
      return null;
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
