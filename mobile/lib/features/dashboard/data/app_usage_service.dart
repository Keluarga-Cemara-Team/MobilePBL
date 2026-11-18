import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Model data representasi aplikasi yang digunakan di perangkat pengguna
class UsedApp {
  const UsedApp({
    required this.packageName,
    required this.name,
    required this.timeMs,
    this.iconBytes,
  });

  final String packageName;
  final String name;
  final int timeMs;
  final Uint8List? iconBytes;

  /// Durasi dalam menit
  int get minutes => (timeMs / 60000).round();

  /// Durasi dalam jam desimal (misal 1.5 jam)
  double get hours => double.parse((timeMs / 3600000.0).toStringAsFixed(1));

  factory UsedApp.fromMap(Map<Object?, Object?> map) => UsedApp(
        packageName: map['packageName'] as String? ?? '',
        name: map['label'] as String? ?? '',
        timeMs: (map['timeMs'] as num?)?.toInt() ?? 0,
        iconBytes: map['icon'] as Uint8List?,
      );
}

/// Service untuk membaca statistik penggunaan aplikasi lokal di perangkat Android
/// menggunakan Android UsageStatsManager via MethodChannel
class AppUsageService {
  static const _channel = MethodChannel('com.example.mobile/app_usage');

  /// Layanan ini hanya didukung pada platform native Android
  bool get supported => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Memeriksa apakah aplikasi sudah memiliki izin PACKAGE_USAGE_STATS
  Future<bool> hasAccess() async {
    if (!supported) return false;
    try {
      return await _channel.invokeMethod<bool>('hasUsageAccess') ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Membuka halaman pengaturan Android "Akses Penggunaan" (Usage Access Settings)
  Future<void> openSettings() async {
    if (supported) {
      try {
        await _channel.invokeMethod<bool>('openUsageSettings');
      } catch (_) {}
    }
  }

  /// Mengambil daftar aplikasi yang paling banyak digunakan beserta durasinya
  Future<List<UsedApp>> mostUsed({int days = 7}) async {
    if (!supported || !await hasAccess()) return const [];
    try {
      final rows = await _channel.invokeMethod<List<Object?>>(
        'getMostUsedApps',
        {'days': days},
      );
      return (rows ?? const [])
          .whereType<Map<Object?, Object?>>()
          .map(UsedApp.fromMap)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  /// Mengambil total durasi penggunaan layar (dalam milidetik) dari seluruh aplikasi lain
  Future<int> getTotalUsageTime({int days = 1}) async {
    if (!supported || !await hasAccess()) return 0;
    try {
      final total = await _channel.invokeMethod<int>(
        'getTotalUsageTime',
        {'days': days},
      );
      return total ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// Mengambil total durasi penggunaan layar hari ini dalam satuan jam desimal
  /// (Contoh: 5.5 jam) untuk sinkronisasi kuesioner pertanyaan screen_hours
  Future<double?> getTodayScreenTimeHours() async {
    if (!supported || !await hasAccess()) return null;
    try {
      final totalMs = await getTotalUsageTime(days: 1);
      if (totalMs <= 0) return null;
      return double.parse((totalMs / 3600000.0).toStringAsFixed(1));
    } catch (_) {
      return null;
    }
  }

  /// Helper untuk memformat durasi milidetik menjadi teks yang mudah dibaca (e.g. "3j 15m")
  String formatDuration(int timeMs) {
    final totalMinutes = (timeMs / 60000).round();
    final hours = totalMinutes ~/ 60;
    final mins = totalMinutes % 60;

    if (hours > 0 && mins > 0) {
      return '${hours}j ${mins}m';
    } else if (hours > 0) {
      return '${hours} jam';
    } else {
      return '$mins menit';
    }
  }
}

/// Provider Riverpod untuk AppUsageService
final appUsageServiceProvider = Provider<AppUsageService>((ref) {
  return AppUsageService();
});
