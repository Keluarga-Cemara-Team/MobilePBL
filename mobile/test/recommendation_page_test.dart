import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/assessment/di/assessment_providers.dart';
import 'package:mobile/features/assessment/domain/entities/assessment.dart';
import 'package:mobile/features/assessment/domain/entities/risk_level.dart';
import 'package:mobile/features/recommendations/presentation/pages/recommendation_page.dart';
import 'package:mobile/l10n/app_localizations.dart';

void main() {
  final dummyAssessment = Assessment(
    id: 'test-assessment-id',
    riskLevel: RiskLevel.tinggi,
    takenAt: DateTime(2026, 11, 19),
  );

  group('RecommendationPage i18n tests', () {
    testWidgets('renders in Indonesian correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assessmentByIdProvider('test-assessment-id')
                .overrideWith((ref) async => dummyAssessment),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('id'),
            home: RecommendationPage(assessmentId: 'test-assessment-id'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Rekomendasi untuk Kamu'), findsOneWidget);
      expect(find.text('Konsultasi Psikolog Profesional'), findsOneWidget);
      expect(find.text('Cari Psikolog Terdekat'), findsOneWidget);
      expect(find.text('Perbaiki Pola Tidur'), findsOneWidget);
      expect(find.text('Prioritaskan kesehatan mentalmu.'), findsOneWidget);
    });

    testWidgets('renders in English correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assessmentByIdProvider('test-assessment-id')
                .overrideWith((ref) async => dummyAssessment),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('en'),
            home: RecommendationPage(assessmentId: 'test-assessment-id'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Recommendations for You'), findsOneWidget);
      expect(find.text('Professional Psychologist Consultation'), findsOneWidget);
      expect(find.text('Find Nearest Psychologists'), findsOneWidget);
      expect(find.text('Improve Sleep Habits'), findsOneWidget);
      expect(find.text('Prioritize your mental health.'), findsOneWidget);
    });
  });
}
