import 'package:flutter/foundation.dart';

/// Konfigurasi Global & Environment untuk Aplikasi AntiBurnout Mobile
class AppConfig {
  AppConfig._();

  /// Runtime override URL (bisa diubah saat runtime untuk keperluan debug / testing)
  static String? _runtimeOverrideUrl;

  /// Mengatur override Base URL secara dinamis saat runtime
  static void setOverrideBaseUrl(String? url) {
    if (url != null && url.trim().isNotEmpty) {
      _runtimeOverrideUrl = url.trim().replaceAll(RegExp(r'/+$'), '');
    } else {
      _runtimeOverrideUrl = null;
    }
  }

  /// Menghapus runtime override
  static void clearOverrideBaseUrl() {
    _runtimeOverrideUrl = null;
  }

  /// Mendapatkan Base URL API backend (WebPBL)
  /// Prioritas resolusi URL:
  /// 1. Runtime override (jika disetel oleh developer/tester)
  /// 2. Compile-time `--dart-define=API_BASE_URL=...`
  /// 3. Fallback platform default (Web: 127.0.0.1:5000, Android Emulator: 10.0.2.2:5000)
  static String get apiBaseUrl {
    if (_runtimeOverrideUrl != null && _runtimeOverrideUrl!.isNotEmpty) {
      return _runtimeOverrideUrl!;
    }

    const definedUrl = String.fromEnvironment('API_BASE_URL');
    if (definedUrl.isNotEmpty) {
      return definedUrl.replaceAll(RegExp(r'/+$'), '');
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:5000';
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000';
    }

    return 'http://127.0.0.1:5000';
  }

  /// Mendapatkan Base URL ML Microservice langsung (opsional)
  static String get mlApiBaseUrl {
    const definedMlUrl = String.fromEnvironment('ML_API_BASE_URL');
    if (definedMlUrl.isNotEmpty) {
      return definedMlUrl.replaceAll(RegExp(r'/+$'), '');
    }

    if (kIsWeb) {
      return 'http://127.0.0.1:8000';
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000';
    }

    return 'http://127.0.0.1:8000';
  }

  /// Status environment Production
  static bool get isProduction =>
      const bool.fromEnvironment('IS_PRODUCTION', defaultValue: false);

  /// Batas waktu timeout koneksi HTTP
  static Duration get connectTimeout => const Duration(seconds: 6);
}
