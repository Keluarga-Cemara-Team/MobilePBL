import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/profile/presentation/controllers/preferences_controller.dart';

void main() {
  group('PreferencesController Language Setting Tests', () {
    test('bahasa default harus Bahasa Indonesia', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(preferencesControllerProvider);
      expect(state.language, AppLanguage.indonesian);
    });

    test('mengubah bahasa ke English berhasil memperbarui state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(preferencesControllerProvider.notifier);
      notifier.setLanguage(AppLanguage.english);

      final state = container.read(preferencesControllerProvider);
      expect(state.language, AppLanguage.english);
    });

    test('mengubah tema tidak mereset pilihan bahasa yang dipilih', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(preferencesControllerProvider.notifier);
      notifier.setLanguage(AppLanguage.english);
      notifier.setThemeMode(ThemeMode.dark);

      final state = container.read(preferencesControllerProvider);
      expect(state.language, AppLanguage.english);
      expect(state.themeMode, ThemeMode.dark);
    });
  });
}
