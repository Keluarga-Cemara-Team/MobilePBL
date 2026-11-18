import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class UsedApp {
  const UsedApp({required this.packageName, required this.name, required this.timeMs, this.iconBytes});

  final String packageName;
  final String name;
  final int timeMs;
  final Uint8List? iconBytes;

  factory UsedApp.fromMap(Map<Object?, Object?> map) => UsedApp(
    packageName: map['packageName'] as String? ?? '',
    name: map['label'] as String? ?? '',
    timeMs: (map['timeMs'] as num?)?.toInt() ?? 0,
    iconBytes: map['icon'] as Uint8List?,
  );
}

class AppUsageService {
  static const _channel = MethodChannel('com.example.mobile/app_usage');

  bool get supported => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<bool> hasAccess() async {
    if (!supported) return false;
    return await _channel.invokeMethod<bool>('hasUsageAccess') ?? false;
  }

  Future<void> openSettings() async {
    if (supported) await _channel.invokeMethod<bool>('openUsageSettings');
  }

  Future<List<UsedApp>> mostUsed({int days = 7}) async {
    if (!supported || !await hasAccess()) return const [];
    final rows = await _channel.invokeMethod<List<Object?>>('getMostUsedApps', {'days': days});
    return (rows ?? const []).whereType<Map<Object?, Object?>>().map(UsedApp.fromMap).toList();
  }
}
