import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/dashboard/presentation/widgets/screen_time_stats_card.dart';
import 'package:mobile/l10n/app_localizations.dart';

void main() {
  Widget buildTestWidget({
    VoidCallback? onStartSurvey,
    int initialDays = 1,
    Locale locale = const Locale('id'),
    ThemeData? theme,
  }) {
    return MaterialApp(
      theme: theme ?? AppTheme.light(),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: ScreenTimeStatsCard(
            onStartSurvey: onStartSurvey,
            initialDays: initialDays,
          ),
        ),
      ),
    );
  }

  group('ScreenTimeStatsCard widget tests', () {
    testWidgets('renders screen time statistics card header and period tabs', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Title & Subtitle
      expect(find.text('Statistik Waktu Layar'), findsOneWidget);
      expect(
        find.text('Pantau durasi layar untuk mendeteksi potensi burnout'),
        findsOneWidget,
      );

      // Period Filter Tabs
      expect(find.text('Hari Ini'), findsOneWidget);
      expect(find.text('7 Hari'), findsOneWidget);
      expect(find.text('30 Hari'), findsOneWidget);

      // Hero Total Time Value
      expect(find.byKey(const ValueKey('screen-time-total-value')), findsOneWidget);

      // Healthy Limit label
      expect(find.text('Batas Sehat: 6 jam/hari'), findsOneWidget);

      // Tip box
      expect(find.text('Tips Bebas Burnout Digital'), findsOneWidget);
    });

    testWidgets('displays app distribution and legend in preview mode', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // App Distribution Title
      expect(find.text('Distribusi Pemakaian Layar'), findsOneWidget);

      // Top app legend items from demo apps
      expect(find.textContaining('WhatsApp'), findsOneWidget);
      expect(find.textContaining('Instagram'), findsOneWidget);
      expect(find.textContaining('YouTube'), findsOneWidget);
    });

    testWidgets('switching period tabs updates daily average display', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Tap 7 Hari
      await tester.tap(find.text('7 Hari'));
      await tester.pumpAndSettle();

      expect(find.text('Total Waktu Layar (7 Hari)'), findsOneWidget);
      expect(find.textContaining('jam/hari'), findsWidgets);

      // Tap 30 Hari
      await tester.tap(find.text('30 Hari'));
      await tester.pumpAndSettle();

      expect(find.text('Total Waktu Layar (30 Hari)'), findsOneWidget);
    });

    testWidgets('triggers onStartSurvey callback when button tapped', (
      tester,
    ) async {
      var surveyStarted = false;
      await tester.pumpWidget(
        buildTestWidget(
          onStartSurvey: () => surveyStarted = true,
        ),
      );
      await tester.pumpAndSettle();

      final surveyButton = find.text('Gunakan di Survei Burnout');
      expect(surveyButton, findsOneWidget);

      await tester.tap(surveyButton);
      await tester.pumpAndSettle();

      expect(surveyStarted, isTrue);
    });

    testWidgets('supports English localization properly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(locale: const Locale('en')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Screen Time Statistics'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('7 Days'), findsOneWidget);
      expect(find.text('30 Days'), findsOneWidget);
      expect(find.text('Healthy Limit: 6 hrs/day'), findsOneWidget);
      expect(find.text('Screen Time Distribution'), findsOneWidget);
      expect(find.text('Digital Well-being Tip'), findsOneWidget);
    });

    testWidgets('works properly in dark theme', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(theme: AppTheme.dark()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Statistik Waktu Layar'), findsOneWidget);
      expect(find.byKey(const ValueKey('screen-time-total-value')), findsOneWidget);
    });
  });
}
