import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../core/storage/secure_storage.dart';

enum AppLanguage { indonesian, english }

class PreferencesDetails {
  const PreferencesDetails({
    this.themeMode = ThemeMode.system,
    this.language = AppLanguage.indonesian,
    this.dailyReminder = false,
    this.wellbeingTips = true,
  });

  final ThemeMode themeMode;
  final AppLanguage language;
  final bool dailyReminder;
  final bool wellbeingTips;

  PreferencesDetails copyWith({
    ThemeMode? themeMode,
    AppLanguage? language,
    bool? dailyReminder,
    bool? wellbeingTips,
  }) {
    return PreferencesDetails(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      dailyReminder: dailyReminder ?? this.dailyReminder,
      wellbeingTips: wellbeingTips ?? this.wellbeingTips,
    );
  }
}

/// Controller untuk mengelola preferensi tampilan, bahasa, dan notifikasi
/// dengan dukungan penyimpanan lokal (offline-first) dan Cloud Firestore
class PreferencesController extends Notifier<PreferencesDetails> {
  static const _keyTheme = 'pref_theme_mode';
  static const _keyLanguage = 'pref_language';
  static const _keyDailyReminder = 'pref_daily_reminder';
  static const _keyWellbeingTips = 'pref_wellbeing_tips';

  @override
  PreferencesDetails build() {
    Future.microtask(_loadPreferences);
    return const PreferencesDetails();
  }

  /// Memuat preferensi dari SharedPreferences terlebih dahulu,
  /// lalu menyinkronkan dengan data di Cloud Firestore jika user telah login
  Future<void> _loadPreferences() async {
    try {
      // 1. Muat dari SharedPreferences lokal (instan tanpa delay network)
      final prefs = await SharedPreferences.getInstance();
      final themeStr = prefs.getString(_keyTheme);
      final langStr = prefs.getString(_keyLanguage);
      final dailyReminder = prefs.getBool(_keyDailyReminder) ?? false;
      final wellbeingTips = prefs.getBool(_keyWellbeingTips) ?? true;

      ThemeMode mode = ThemeMode.system;
      if (themeStr == 'dark') mode = ThemeMode.dark;
      if (themeStr == 'light') mode = ThemeMode.light;

      AppLanguage lang = AppLanguage.indonesian;
      if (langStr == 'english') lang = AppLanguage.english;

      state = PreferencesDetails(
        themeMode: mode,
        language: lang,
        dailyReminder: dailyReminder,
        wellbeingTips: wellbeingTips,
      );

      // 2. Sinkronisasi dari Firestore jika user sedang login
      await syncFromCloud();
    } catch (e) {
      debugPrint('PreferencesController _loadPreferences error: $e');
    }
  }

  /// Sinkronisasi preferensi dari Cloud Firestore
  Future<void> syncFromCloud([String? explicitUserId]) async {
    try {
      final cached = await SecureTokenStorage.instance.getCachedUser();
      final userId = explicitUserId ??
          cached?['id'] as String? ??
          FirebaseAuth.instance.currentUser?.uid;

      if (userId == null || userId.isEmpty) return;

      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final cloudPref = doc.data()!['preferences'] as Map<String, dynamic>?;
        if (cloudPref != null) {
          ThemeMode mode = state.themeMode;
          AppLanguage lang = state.language;

          final cloudTheme = cloudPref['theme_mode'] as String?;
          final cloudLang = cloudPref['language'] as String?;
          final cloudReminder = cloudPref['daily_reminder'] as bool?;
          final cloudTips = cloudPref['wellbeing_tips'] as bool?;

          if (cloudTheme != null) {
            if (cloudTheme == 'dark') mode = ThemeMode.dark;
            else if (cloudTheme == 'light') mode = ThemeMode.light;
            else mode = ThemeMode.system;
          }
          if (cloudLang != null) {
            lang = cloudLang == 'english' ? AppLanguage.english : AppLanguage.indonesian;
          }

          state = PreferencesDetails(
            themeMode: mode,
            language: lang,
            dailyReminder: cloudReminder ?? state.dailyReminder,
            wellbeingTips: cloudTips ?? state.wellbeingTips,
          );

          await _saveToLocal(state);
          debugPrint('PreferencesController: Sukses memuat preferensi dari Cloud Firestore.');
        }
      }
    } catch (e) {
      debugPrint('PreferencesController syncFromCloud warning: $e');
    }
  }

  /// Menyimpan preferensi ke SharedPreferences lokal
  Future<void> _saveToLocal(PreferencesDetails details) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyTheme, details.themeMode.name);
      await prefs.setString(_keyLanguage, details.language.name);
      await prefs.setBool(_keyDailyReminder, details.dailyReminder);
      await prefs.setBool(_keyWellbeingTips, details.wellbeingTips);
    } catch (e) {
      debugPrint('PreferencesController _saveToLocal error: $e');
    }
  }

  /// Menyimpan preferensi ke dokumen Firestore 'users/{userId}'
  Future<void> _syncToFirestore(PreferencesDetails details) async {
    try {
      final cached = await SecureTokenStorage.instance.getCachedUser();
      final userId = cached?['id'] as String? ??
          FirebaseAuth.instance.currentUser?.uid;

      if (userId == null || userId.isEmpty) return;

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'preferences': {
          'theme_mode': details.themeMode.name,
          'language': details.language.name,
          'daily_reminder': details.dailyReminder,
          'wellbeing_tips': details.wellbeingTips,
          'updated_at': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));
      debugPrint('PreferencesController: Preferensi tersimpan di Firestore (user: $userId)');
    } catch (e) {
      debugPrint('PreferencesController _syncToFirestore warning: $e');
    }
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _saveToLocal(state);
    _syncToFirestore(state);
  }

  void setLanguage(AppLanguage language) {
    state = state.copyWith(language: language);
    _saveToLocal(state);
    _syncToFirestore(state);
  }

  Future<void> setDailyReminder(bool enabled) async {
    state = state.copyWith(dailyReminder: enabled);
    await _saveToLocal(state);
    await _syncToFirestore(state);

    final notificationService = ref.read(notificationServiceProvider);
    if (enabled) {
      await notificationService.scheduleDailyReminder(hour: 9, minute: 0);
    } else {
      await notificationService.cancelDailyReminder();
    }
  }

  Future<void> setWellbeingTips(bool enabled) async {
    state = state.copyWith(wellbeingTips: enabled);
    await _saveToLocal(state);
    await _syncToFirestore(state);

    final notificationService = ref.read(notificationServiceProvider);
    if (enabled) {
      await notificationService.scheduleDailyMotivation(hour: 14, minute: 0);
    } else {
      await notificationService.cancelDailyMotivation();
    }
  }

  /// Trigger langsung untuk pengujian notifikasi Pengingat Harian
  Future<void> testSendDailyReminder() async {
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.showImmediateReminder();
  }

  /// Trigger langsung untuk pengujian notifikasi Motivasi Sederhana
  Future<void> testSendMotivation() async {
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.showImmediateMotivation();
  }
}

final preferencesControllerProvider =
    NotifierProvider<PreferencesController, PreferencesDetails>(
      PreferencesController.new,
    );
