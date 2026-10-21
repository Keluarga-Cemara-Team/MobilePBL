import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  void setDailyReminder(bool enabled) {
    state = PreferencesDetails(
      themeMode: state.themeMode,
      language: state.language,
      dailyReminder: enabled,
      wellbeingTips: state.wellbeingTips,
    );
  }

  void setWellbeingTips(bool enabled) {
    state = PreferencesDetails(
      themeMode: state.themeMode,
      language: state.language,
      dailyReminder: state.dailyReminder,
      wellbeingTips: enabled,
    );
  }
}

final preferencesControllerProvider =
    NotifierProvider<PreferencesController, PreferencesDetails>(
      PreferencesController.new,
    );
