import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/assessment/di/assessment_providers.dart';
import 'package:mobile/features/assessment/domain/entities/assessment.dart';
import 'package:mobile/features/assessment/domain/entities/risk_level.dart';
import 'package:mobile/features/recommendations/presentation/pages/recommendation_page.dart';
import 'package:mobile/l10n/app_localizations.dart';

void main() {
  final dummyAssessmentWithAi = Assessment(
    id: 'test-assessment-id-ai',
    riskLevel: RiskLevel.tinggi,
    takenAt: DateTime(2026, 11, 19),
    aiRecommendation:
        'Tingkat stres tinggi dan durasi tidur 5 jam. Disarankan mengambil jeda 10 menit setiap 2 jam.',
  );

  final dummyAssessmentWithoutAi = Assessment(
    id: 'test-assessment-id-no-ai',
    riskLevel: RiskLevel.tinggi,
    takenAt: DateTime(2026, 11, 19),
  );

  group('RecommendationPage dynamic AI tests', () {
    testWidgets('renders dynamic AI recommendation card in Indonesian', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assessmentByIdProvider('test-assessment-id-ai')
                .overrideWith((ref) async => dummyAssessmentWithAi),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('id'),
            home: RecommendationPage(assessmentId: 'test-assessment-id-ai'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Rekomendasi Personal AI'), findsOneWidget);
      expect(find.text('Analisis Cerdas AntiBurnout'), findsOneWidget);
      expect(
        find.text(
          'Tingkat stres tinggi dan durasi tidur 5 jam. Disarankan mengambil jeda 10 menit setiap 2 jam.',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Dipersonalisasi secara cerdas berdasarkan kondisi asesmen harianmu.'),
        findsOneWidget,
      );
    });

    testWidgets('renders dynamic AI recommendation card in English', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assessmentByIdProvider('test-assessment-id-ai')
                .overrideWith((ref) async => dummyAssessmentWithAi),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('en'),
            home: RecommendationPage(assessmentId: 'test-assessment-id-ai'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Personalized AI Recommendation'), findsOneWidget);
      expect(find.text('Smart AntiBurnout Analysis'), findsOneWidget);
      expect(
        find.text('Personalized intelligently based on your assessment conditions.'),
        findsOneWidget,
      );
    });

    testWidgets('falls back to general note when no AI recommendation', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assessmentByIdProvider('test-assessment-id-no-ai')
                .overrideWith((ref) async => dummyAssessmentWithoutAi),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('id'),
            home: RecommendationPage(assessmentId: 'test-assessment-id-no-ai'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Rekomendasi Personal AI'), findsNothing);
      expect(
        find.text('Panduan umum, belum dipersonalisasi berdasarkan hasil asesmen.'),
        findsOneWidget,
      );
    });
  });
}
