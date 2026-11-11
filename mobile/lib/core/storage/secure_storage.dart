import 'package:flutter/foundation.dart';

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

/// Layanan penyimpanan aman token otentikasi
class SecureTokenStorage {
  SecureTokenStorage._();
  static final SecureTokenStorage instance = SecureTokenStorage._();

  AuthTokens? _cachedTokens;

  /// Mengambil token aktif
  Future<AuthTokens?> getTokens() async {
    return _cachedTokens;
  }

  /// Mengambil access token saat ini
  Future<String?> getAccessToken() async {
    return _cachedTokens?.accessToken;
  }

  /// Mengambil refresh token
  Future<String?> getRefreshToken() async {
    return _cachedTokens?.refreshToken;
  }

  /// Menyimpan token baru (setelah login / refresh)
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    DateTime? expiresAt,
  }) async {
    _cachedTokens = AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiresAt ?? DateTime.now().add(const Duration(hours: 1)),
    );
    debugPrint('SecureTokenStorage: Token otentikasi berhasil disimpan.');
  }

  /// Menghapus seluruh token (saat logout)
  Future<void> clearTokens() async {
    _cachedTokens = null;
    debugPrint('SecureTokenStorage: Token otentikasi telah dihapus.');
  }
}

