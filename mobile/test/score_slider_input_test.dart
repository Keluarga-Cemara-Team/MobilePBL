import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/survey/presentation/widgets/score_slider_input.dart';
import 'package:mobile/l10n/app_localizations.dart';

void main() {
  group('MoodScoreTier.fromValue', () {
    test('maps thresholds correctly every 20-point milestone and at 100', () {
      expect(MoodScoreTier.fromValue(0), MoodScoreTier.severeFatigue);
      expect(MoodScoreTier.fromValue(10), MoodScoreTier.severeFatigue);
      expect(MoodScoreTier.fromValue(19.9), MoodScoreTier.severeFatigue);

      expect(MoodScoreTier.fromValue(20), MoodScoreTier.fatigued);
      expect(MoodScoreTier.fromValue(30), MoodScoreTier.fatigued);
      expect(MoodScoreTier.fromValue(39.9), MoodScoreTier.fatigued);

      expect(MoodScoreTier.fromValue(40), MoodScoreTier.neutral);
      expect(MoodScoreTier.fromValue(50), MoodScoreTier.neutral);
      expect(MoodScoreTier.fromValue(59.9), MoodScoreTier.neutral);

      expect(MoodScoreTier.fromValue(60), MoodScoreTier.refreshed);
      expect(MoodScoreTier.fromValue(65), MoodScoreTier.refreshed);
      expect(MoodScoreTier.fromValue(79.9), MoodScoreTier.refreshed);

      expect(MoodScoreTier.fromValue(80), MoodScoreTier.energetic);
      expect(MoodScoreTier.fromValue(90), MoodScoreTier.energetic);

      expect(MoodScoreTier.fromValue(95), MoodScoreTier.optimal);
      expect(MoodScoreTier.fromValue(100), MoodScoreTier.optimal);
    });

    test('clamps values below 0 or above 100', () {
      expect(MoodScoreTier.fromValue(-10), MoodScoreTier.severeFatigue);
      expect(MoodScoreTier.fromValue(150), MoodScoreTier.optimal);
    });

    test('has expected emoji mapping for all milestones', () {
      expect(MoodScoreTier.severeFatigue.emoji, '😫');
      expect(MoodScoreTier.fatigued.emoji, '🥱');
      expect(MoodScoreTier.neutral.emoji, '😐');
      expect(MoodScoreTier.refreshed.emoji, '🙂');
      expect(MoodScoreTier.energetic.emoji, '😄');
      expect(MoodScoreTier.optimal.emoji, '🥰');
    });
  });

  group('ScoreSliderInput widget', () {
    Widget createWidget({
      double value = 65.0,
      double maximum = 100.0,
      ValueChanged<double>? onChanged,
      Locale locale = const Locale('id'),
      ThemeData? theme,
    }) {
      return MaterialApp(
        theme: theme ?? AppTheme.light(),
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: ScoreSliderInput(
              value: value,
              maximum: maximum,
              onChanged: onChanged ?? (_) {},
            ),
          ),
        ),
      );
    }

    testWidgets('renders score 65 with 5 🙂 emojis, badge, and labels in Indonesian', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget(value: 65));
      await tester.pumpAndSettle();

      // Score number
      expect(find.text('65'), findsOneWidget);
      expect(find.text('dari 100'), findsOneWidget);

      // Mood badge for refreshed
      expect(find.text('Cukup segar'), findsOneWidget);

      // Slider endpoints
      expect(find.text('Sangat tidak nyaman'), findsOneWidget);
      expect(find.text('Sangat nyaman'), findsOneWidget);

      // Exactly 5 orbiting emojis surrounding the score
      expect(find.text('🙂'), findsNWidgets(5));
    });

    testWidgets('renders score 100 with 5 🥰 emojis and optimal badge', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget(value: 100));
      await tester.pumpAndSettle();

      expect(find.text('100'), findsOneWidget);
      expect(find.text('dari 100'), findsOneWidget);
      expect(find.text('Sangat nyaman'), findsNWidgets(2)); // Badge & right label

      // Exactly 5 🥰 emojis matching user mock image
      expect(find.text('🥰'), findsNWidgets(5));
    });

    testWidgets('renders score 0 with 5 😫 emojis and exhausted badge', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget(value: 0));
      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);
      expect(find.text('Sangat lelah'), findsOneWidget);
      expect(find.text('😫'), findsNWidgets(5));
    });

    testWidgets('supports English localization', (tester) async {
      await tester.pumpWidget(
        createWidget(value: 80, locale: const Locale('en')),
      );
      await tester.pumpAndSettle();

      expect(find.text('80'), findsOneWidget);
      expect(find.text('out of 100'), findsOneWidget);
      expect(find.text('Energetic'), findsOneWidget);
      expect(find.text('Very uncomfortable'), findsOneWidget);
      expect(find.text('Very comfortable'), findsOneWidget);
      expect(find.text('😄'), findsNWidgets(5));
    });

    testWidgets('works properly in dark theme', (tester) async {
      await tester.pumpWidget(
        createWidget(value: 40, theme: AppTheme.dark()),
      );
      await tester.pumpAndSettle();

      expect(find.text('40'), findsOneWidget);
      expect(find.text('Biasa saja'), findsOneWidget);
      expect(find.text('😐'), findsNWidgets(5));
    });

    testWidgets('reacts to slider drag and triggers onChanged', (tester) async {
      double? updatedValue;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            return MaterialApp(
              theme: AppTheme.light(),
              locale: const Locale('id'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: ScoreSliderInput(
                  value: updatedValue ?? 65.0,
                  maximum: 100.0,
                  onChanged: (val) {
                    setState(() => updatedValue = val);
                  },
                ),
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('65'), findsOneWidget);
      expect(find.text('🙂'), findsNWidgets(5));

      // Drag slider to the right
      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(200, 0));
      await tester.pumpAndSettle();

      expect(updatedValue, isNotNull);
      expect(updatedValue!, greaterThan(65));
    });
  });
}
