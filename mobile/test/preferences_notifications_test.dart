import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/services/notification_service.dart';
import 'package:mobile/features/profile/presentation/controllers/preferences_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationService Constants & Quotes Tests', () {
    test('Notification channels and IDs are properly configured', () {
      expect(NotificationService.reminderNotificationId, 1001);
      expect(NotificationService.motivationNotificationId, 1002);
      expect(NotificationService.reminderChannelId, isNotEmpty);
      expect(NotificationService.motivationChannelId, isNotEmpty);
    });

    test('Motivational quotes catalog is populated', () {
      expect(NotificationService.motivationalQuotes.isNotEmpty, isTrue);
      expect(NotificationService.motivationalQuotes.length, greaterThanOrEqualTo(5));
      for (final quote in NotificationService.motivationalQuotes) {
        expect(quote.trim().isNotEmpty, isTrue);
      }
    });
  });

  group('PreferencesController Notification State Tests', () {
    test('Default notification preferences match expected defaults', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(preferencesControllerProvider);
      expect(state.dailyReminder, isFalse);
      expect(state.wellbeingTips, isTrue);
    });

    test('Updating daily reminder updates preferences state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(preferencesControllerProvider.notifier);
      controller.setDailyReminder(true);

      final state = container.read(preferencesControllerProvider);
      expect(state.dailyReminder, isTrue);
    });

    test('Updating wellbeing tips (motivation) updates preferences state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(preferencesControllerProvider.notifier);
      controller.setWellbeingTips(false);

      final state = container.read(preferencesControllerProvider);
      expect(state.wellbeingTips, isFalse);
    });
  });
}

