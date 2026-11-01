import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/notification_service.dart';

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
}

/// Controller untuk mengelola preferensi tampilan, bahasa, dan notifikasi
class PreferencesController extends Notifier<PreferencesDetails> {
  @override
  PreferencesDetails build() => const PreferencesDetails();

  void setThemeMode(ThemeMode mode) {
    state = PreferencesDetails(
      themeMode: mode,
      language: state.language,
      dailyReminder: state.dailyReminder,
      wellbeingTips: state.wellbeingTips,
    );
  }

  void setLanguage(AppLanguage language) {
    state = PreferencesDetails(
      themeMode: state.themeMode,
      language: language,
      dailyReminder: state.dailyReminder,
      wellbeingTips: state.wellbeingTips,
    );
  }

  Future<void> setDailyReminder(bool enabled) async {
    state = PreferencesDetails(
      themeMode: state.themeMode,
      language: state.language,
      dailyReminder: enabled,
      wellbeingTips: state.wellbeingTips,
    );

    final notificationService = ref.read(notificationServiceProvider);
    if (enabled) {
      await notificationService.scheduleDailyReminder(hour: 9, minute: 0);
    } else {
      await notificationService.cancelDailyReminder();
    }
  }

  Future<void> setWellbeingTips(bool enabled) async {
    state = PreferencesDetails(
      themeMode: state.themeMode,
      language: state.language,
      dailyReminder: state.dailyReminder,
      wellbeingTips: enabled,
    );

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
