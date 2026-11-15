import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/theme/assessment_colors.dart';
import 'package:mobile/features/psychologists/data/repositories/firestore_psychologist_repository.dart';
import 'package:mobile/features/psychologists/domain/entities/psychologist.dart';
import 'package:mobile/features/psychologists/domain/utils/geo_calculator.dart';
import 'package:mobile/features/psychologists/presentation/controllers/psychologist_controller.dart';
import 'package:mobile/features/psychologists/presentation/pages/nearby_psychologists_page.dart';
import 'package:mobile/features/psychologists/presentation/widgets/psychologist_card.dart';
import 'package:mobile/features/results/presentation/widgets/risk_summary_card.dart';
import 'package:mobile/l10n/app_localizations.dart';

void main() {
  group('GeoCalculator tests', () {
    test('Calculates distance between Batam and Jakarta properly', () {
      // Batam: ~1.13, 104.05
      // Jakarta: ~-6.20, 106.81
      final distance = GeoCalculator.distanceBetweenKm(
        startLatitude: 1.1301,
        startLongitude: 104.0531,
        endLatitude: -6.2088,
        endLongitude: 106.8456,
      );

      // Distance Batam-Jakarta is around 850 - 950 km
      expect(distance, greaterThan(800));
      expect(distance, lessThan(1000));
    });

    test('Formats distance correctly', () {
      expect(GeoCalculator.formatDistance(0.45), '450 m');
      expect(GeoCalculator.formatDistance(2.34), '2.3 km');
    });
  });

  group('FirestorePsychologistRepository tests', () {
    test('Filters by city and sorts by distance', () async {
      final repo = FirestorePsychologistRepository();

      // Batam location
      final batamItems = await repo.getPsychologists(
        city: 'Batam',
        userLatitude: 1.1301,
        userLongitude: 104.0531,
      );

      expect(batamItems, isNotEmpty);
      expect(batamItems.every((item) => item.city == 'Batam'), isTrue);
      // Closest item should have distanceKm calculated
      expect(batamItems.first.distanceKm, isNotNull);

      // Malang location
      final malangItems = await repo.getPsychologists(city: 'Malang');
      expect(malangItems, isNotEmpty);
      expect(malangItems.every((item) => item.city == 'Malang'), isTrue);
      expect(malangItems.any((item) => item.name.contains('Saiful Anwar')), isTrue);
    });

    test('Filters by text query', () async {
      final repo = FirestorePsychologistRepository();

      final searchResults = await repo.getPsychologists(
        query: 'Embung Fatimah',
      );

      expect(searchResults.length, 1);
      expect(searchResults.first.clinicOrHospital.contains('Embung Fatimah'), isTrue);
    });
  });

  group('UI Integration tests', () {
    testWidgets('NearbyPsychologistsPage renders emergency card and psychologist list', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            positionResolverProvider.overrideWithValue(() async => null),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: NearbyPsychologistsPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check emergency hotline banner
      expect(find.text('Butuh Bantuan Krisis Cepat?'), findsOneWidget);
      expect(find.text('Hubungi Hotline 119 (Ext 8)'), findsOneWidget);

      // Check title and list
      expect(find.text('Psikolog & Klinik Terdekat'), findsOneWidget);
      expect(find.text('Semua'), findsOneWidget);
      expect(find.text('Batam'), findsOneWidget);
      expect(find.text('Malang'), findsOneWidget);

      // Tap Malang chip filter
      final malangChip = find.widgetWithText(ChoiceChip, 'Malang');
      await tester.ensureVisible(malangChip);
      await tester.tap(malangChip);
      await tester.pumpAndSettle();

      expect(find.textContaining('Malang'), findsWidgets);
      expect(find.byType(PsychologistCard), findsWidgets);
    });

    testWidgets('RiskSummaryCard displays high risk banner when isHighRisk is true', (
      tester,
    ) async {
      var findPsychologistClicked = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: RiskSummaryCard(
              title: 'Hasil Asesmen',
              level: 'Tinggi',
              levelColor: AssessmentColors.riskHigh,
              ringColor: AssessmentColors.riskHigh,
              description: 'Risiko burnout tergolong tinggi.',
              assessmentDate: '15 Nov 2026',
              disclaimer: 'Bukan diagnosis medis.',
              factors: const [],
              answerSummary: const [],
              isHighRisk: true,
              onFindPsychologistTap: () {
                findPsychologistClicked = true;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Perlu Perhatian Profesional'), findsOneWidget);
      expect(find.text('Cari Psikolog Terdekat'), findsNWidgets(2)); // Banner & bottom button

      // Tap the action button
      await tester.tap(find.text('Cari Psikolog Terdekat').first);
      expect(findPsychologistClicked, isTrue);
    });

    testWidgets('PsychologistCard renders without overflow on narrow screens',
        (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      const longItem = Psychologist(
        id: 'rsj-radjiman-malang',
        name: 'Instalasi Kesehatan Jiwa RSJ Dr. Radjiman Wediodiningrat',
        title: 'Pusat Rujukan Nasional Kesehatan Jiwa & Terapi Burnout',
        clinicOrHospital: 'RSJ Dr. Radjiman Wediodiningrat Malang',
        address: 'Jl. Ahmad Yani No. 1, Kalirejo, Lawang, Kab. Malang, Jawa Timur',
        city: 'Malang',
        latitude: -7.8385,
        longitude: 112.6974,
        phone: '0341426015',
        whatsapp: '628113426015',
        rating: 4.8,
        reviewCount: 120,
        openHours: 'Setiap Hari: 24 Jam (UGD Jiwa) / Poliklinik: 08:00 - 15:00 WIB',
        specialties: ['Penanganan Krisis Burnout', 'Terapi Kelelahan Akut', 'Konsultasi Psikiatri & Psikoterapi'],
        distanceKm: 15.3,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('id'),
          home: const Scaffold(
            body: SingleChildScrollView(
              child: PsychologistCard(psychologist: longItem),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Ensure no flutter overflow exceptions occurred and card is visible
      expect(tester.takeException(), isNull);
      expect(find.byType(PsychologistCard), findsOneWidget);
      expect(find.textContaining('RSJ Dr. Radjiman'), findsWidgets);
    });
  });
}
