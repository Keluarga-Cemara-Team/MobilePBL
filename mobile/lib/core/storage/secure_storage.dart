import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Model representasi token otentikasi (Access Token & Refresh Token)
class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
    this.tokenType = 'Bearer',
  });

  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;
  final String tokenType;

  /// Mengecek apakah access token sudah kadaluarsa (dengan toleransi 30 detik)
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!.subtract(const Duration(seconds: 30)));
  }

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'expires_at': expiresAt?.toIso8601String(),
    'token_type': tokenType,
  };

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
      expiresAt: json['expires_at'] != null ? DateTime.tryParse(json['expires_at']) : null,
      tokenType: json['token_type'] as String? ?? 'Bearer',
    );
  }
}

/// Layanan penyimpanan aman token dan sesi otentikasi ke persistent storage
class SecureTokenStorage {
  SecureTokenStorage._();
  static final SecureTokenStorage instance = SecureTokenStorage._();

  static const _keyTokens = 'antiburnout_auth_tokens';
  static const _keyCachedUser = 'antiburnout_cached_user';

  AuthTokens? _cachedTokens;

  /// Mengambil token aktif dari memory atau persistent storage
  Future<AuthTokens?> getTokens() async {
    if (_cachedTokens != null) return _cachedTokens;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_keyTokens);
      if (raw != null && raw.isNotEmpty) {
        _cachedTokens = AuthTokens.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('SecureTokenStorage getTokens error: $e');
    }
    return _cachedTokens;
  }

  /// Mengambil access token saat ini
  Future<String?> getAccessToken() async {
    final tokens = await getTokens();
    return tokens?.accessToken;
  }

  /// Mengambil refresh token
  Future<String?> getRefreshToken() async {
    final tokens = await getTokens();
    return tokens?.refreshToken;
  }

  /// Menyimpan token baru (setelah login / refresh) ke persistent storage
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    DateTime? expiresAt,
  }) async {
    final tokens = AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt ?? DateTime.now().add(const Duration(hours: 1)),
    );
    _cachedTokens = tokens;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyTokens, jsonEncode(tokens.toJson()));
    } catch (e) {
      debugPrint('SecureTokenStorage saveTokens error: $e');
    }
    debugPrint('SecureTokenStorage: Token otentikasi berhasil disimpan ke persistent storage.');
  }

  /// Menyimpan data identitas user yang sedang aktif ke cache lokal
  Future<void> saveCachedUser(Map<String, dynamic> userJson) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyCachedUser, jsonEncode(userJson));
    } catch (e) {
      debugPrint('SecureTokenStorage saveCachedUser error: $e');
    }
  }

  /// Mengambil data identitas user aktif dari cache lokal
  Future<Map<String, dynamic>?> getCachedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_keyCachedUser);
      if (raw != null && raw.isNotEmpty) {
        return jsonDecode(raw) as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint('SecureTokenStorage getCachedUser error: $e');
    }
    return null;
  }

  /// Menghapus seluruh token dan sesi (saat logout)
  Future<void> clearTokens() async {
    _cachedTokens = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyTokens);
      await prefs.remove(_keyCachedUser);
    } catch (e) {
      debugPrint('SecureTokenStorage clearTokens error: $e');
    }
    debugPrint('SecureTokenStorage: Token dan sesi pengguna telah dihapus dari persistent storage.');
  }
}

