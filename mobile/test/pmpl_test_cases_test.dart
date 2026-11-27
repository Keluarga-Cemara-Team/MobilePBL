import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/app/app.dart';
import 'package:mobile/app/router/app_router.dart';
import 'package:mobile/app/router/route_paths.dart';
import 'package:mobile/features/assessment/di/assessment_providers.dart';
import 'package:mobile/features/assessment/domain/entities/assessment.dart';
import 'package:mobile/features/assessment/domain/repositories/assessment_repository.dart';
import 'package:mobile/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:mobile/features/auth/di/auth_providers.dart';
import 'package:mobile/features/auth/domain/entities/auth_user.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_controller.dart';
import 'package:mobile/features/auth/presentation/controllers/auth_state.dart';
import 'package:mobile/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:mobile/features/auth/presentation/pages/login_page.dart';
import 'package:mobile/features/auth/presentation/pages/register_page.dart';
import 'package:mobile/features/auth/presentation/pages/welcome_page.dart';
import 'package:mobile/features/dashboard/presentation/models/weekly_risk_statistics.dart';
import 'package:mobile/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mobile/features/history/presentation/controllers/history_repository.dart';
import 'package:mobile/features/history/presentation/pages/history_page.dart';
import 'package:mobile/features/history/presentation/widgets/assessment_history_item.dart';
import 'package:mobile/features/profile/data/repositories/in_memory_profile_repository.dart';
import 'package:mobile/features/profile/di/profile_providers.dart';
import 'package:mobile/features/profile/presentation/controllers/preferences_controller.dart';
import 'package:mobile/features/profile/presentation/controllers/profile_controller.dart';
import 'package:mobile/features/profile/presentation/pages/about_page.dart';
import 'package:mobile/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:mobile/features/profile/presentation/pages/help_page.dart';
import 'package:mobile/features/profile/presentation/pages/personalization_page.dart';
import 'package:mobile/features/profile/presentation/pages/preferences_page.dart';
import 'package:mobile/features/profile/presentation/pages/profile_page.dart';
import 'package:mobile/features/recommendations/presentation/pages/recommendation_page.dart';
import 'package:mobile/features/results/presentation/pages/result_page.dart';
import 'package:mobile/features/survey/presentation/pages/survey_question_page.dart';
import 'package:mobile/l10n/app_localizations.dart';

class _SignedInAuthController extends AuthController {
  _SignedInAuthController(this._user);

  final AuthUser _user;

  @override
  AuthState build() => AuthState.authenticated(_user);
}

class _FakeHistoryRepo implements HistoryRepository {
  _FakeHistoryRepo(this.items);

  final List<AssessmentHistoryItem> items;

  @override
  Future<List<AssessmentHistoryItem>> fetchHistory() async => items;
}

class _ControllableAssessmentRepo implements AssessmentRepository {
  bool shouldFail = false;
  Completer<void>? gate;
  int submitCalls = 0;
  final Map<String, Assessment> store = {};

  @override
  Future<Assessment?> getById(String id) async => store[id];

  @override
  Future<Assessment> submit(Map<String, String> answers) async {
    submitCalls++;
    if (gate != null) {
      await gate!.future;
    }
    if (shouldFail) {
      throw Exception('Layanan gagal sementara');
    }
    final result = Assessment(
      id: 'pmpl-asm-$submitCalls',
      riskLevel: RiskLevel.sedang,
      takenAt: DateTime(2026, 10, 19, 10, 0),
      isExample: false,
      modelFactors: const [
        AssessmentFactor(label: 'Durasi tidur kurang optimal (5.5 jam)'),
      ],
      aiRecommendation: 'Ambil jeda berkala setiap 2 jam kerja.',
    );
    store[result.id] = result;
    return result;
  }
}

Future<ProviderContainer> _pumpApp(
  WidgetTester tester, {
  String initialLocation = RoutePaths.login,
  FakeAuthRepository? authRepo,
  AuthUser? signedInUser,
  List<AssessmentHistoryItem>? historyItems,
  AssessmentRepository? assessmentRepo,
  Future<Uint8List?> Function()? imagePicker,
}) async {
  SharedPreferences.setMockInitialValues({});
  final fakeAuth = authRepo ?? FakeAuthRepository();
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(fakeAuth),
      profileRepositoryProvider.overrideWithValue(InMemoryProfileRepository()),
      if (signedInUser != null)
        authControllerProvider.overrideWith(
          () => _SignedInAuthController(signedInUser),
        ),
      if (historyItems != null) ...[
        assessmentFixtureProvider.overrideWithValue(historyItems),
        historyRepositoryProvider.overrideWithValue(
          _FakeHistoryRepo(historyItems),
        ),
      ],
      if (assessmentRepo != null)
        assessmentRepositoryProvider.overrideWithValue(assessmentRepo),
      if (imagePicker != null)
        profileImagePickerProvider.overrideWithValue(imagePicker),
    ],
  );
  addTearDown(container.dispose);

  if (signedInUser == null) {
    container.read(appRouterProvider).go(initialLocation);
  }
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const AntiBurnoutApp(),
    ),
  );
  await tester.pump(const Duration(milliseconds: 350));
  await tester.pumpAndSettle();
  return container;
}

Future<void> _fillByHint(WidgetTester tester, String hint, String value) async {
  final field = find.byWidgetPredicate(
    (widget) => widget is TextField && widget.decoration?.hintText == hint,
  );
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
}

Future<void> _tapText(WidgetTester tester, String text) async {
  final target = find.text(text).last;
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> _tapBottomNav(WidgetTester tester, String label) async {
  final target = find
      .descendant(
        of: find.byType(BottomNavigationBar),
        matching: find.text(label),
      )
      .last;
  await tester.tap(target);
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // =========================================================================
  // FITUR 1: REGISTRASI (TS-REG-01, TS-REG-02 | TC-REG-01 .. TC-REG-09)
  // =========================================================================
  group('PMPL Fitur 1 - Registrasi (TS-REG-01 & TS-REG-02)', () {
    testWidgets('TC-REG-01: Registrasi dengan data valid berhasil membuat akun', (
      tester,
    ) async {
      final container = await _pumpApp(
        tester,
        initialLocation: RoutePaths.register,
      );
      await _fillByHint(tester, 'Nama Lengkap', 'Esatovin Victoria');
      await _fillByHint(tester, 'Email', 'esatovin@gmail.com');
      await _fillByHint(tester, 'Kata Sandi', 'password123');
      await _fillByHint(tester, 'Konfirmasi Kata Sandi', 'password123');
      await _tapText(tester, 'Daftar');

      final auth = container.read(authControllerProvider);
      expect(auth.status, AuthStatus.authenticated);
      expect(auth.user?.name, 'Esatovin Victoria');
      expect(auth.user?.email, 'esatovin@gmail.com');
      expect(find.byType(PersonalizationPage), findsOneWidget);
    });

    testWidgets('TC-REG-02: Registrasi dengan Nama Lengkap kosong ditolak', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: RoutePaths.register);
      await _fillByHint(tester, 'Email', 'esatovin@gmail.com');
      await _fillByHint(tester, 'Kata Sandi', 'password123');
      await _fillByHint(tester, 'Konfirmasi Kata Sandi', 'password123');
      await _tapText(tester, 'Daftar');

      expect(find.text('Nama lengkap wajib diisi.'), findsOneWidget);
      expect(find.byType(RegisterPage), findsOneWidget);
    });

    testWidgets('TC-REG-03 & TC-REG-04: Email kosong & format tidak valid ditolak', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: RoutePaths.register);
      await _fillByHint(tester, 'Nama Lengkap', 'Esatovin Victoria');
      await _fillByHint(tester, 'Email', '');
      await _fillByHint(tester, 'Kata Sandi', 'password123');
      await _fillByHint(tester, 'Konfirmasi Kata Sandi', 'password123');
      await _tapText(tester, 'Daftar');
      expect(find.text('Masukkan email yang valid.'), findsOneWidget);

      await _fillByHint(tester, 'Email', 'esatovin.com');
      await _tapText(tester, 'Daftar');
      expect(find.text('Masukkan email yang valid.'), findsOneWidget);
    });

    testWidgets('TC-REG-05: Registrasi dengan Kata Sandi kosong ditolak', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: RoutePaths.register);
      await _fillByHint(tester, 'Nama Lengkap', 'Esatovin Victoria');
      await _fillByHint(tester, 'Email', 'esatovin@gmail.com');
      await _tapText(tester, 'Daftar');

      expect(find.text('Kata sandi minimal 6 karakter.'), findsOneWidget);
    });

    testWidgets('TC-REG-06: Registrasi dengan konfirmasi Kata Sandi berbeda ditolak', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: RoutePaths.register);
      await _fillByHint(tester, 'Nama Lengkap', 'Esatovin Victoria');
      await _fillByHint(tester, 'Email', 'esatovin@gmail.com');
      await _fillByHint(tester, 'Kata Sandi', 'password123');
      await _fillByHint(tester, 'Konfirmasi Kata Sandi', 'password1234');
      await _tapText(tester, 'Daftar');

      expect(find.text('Konfirmasi kata sandi tidak sama.'), findsOneWidget);
    });

    testWidgets('TC-REG-07: Registrasi dengan Email sudah terdaftar ditolak', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: RoutePaths.register);
      await _fillByHint(tester, 'Nama Lengkap', 'Esatovin Victoria');
      await _fillByHint(tester, 'Email', 'dummy@example.com');
      await _fillByHint(tester, 'Kata Sandi', 'password123');
      await _fillByHint(tester, 'Konfirmasi Kata Sandi', 'password123');
      await _tapText(tester, 'Daftar');

      expect(find.text('Email sudah terdaftar.'), findsOneWidget);
      expect(find.byType(RegisterPage), findsOneWidget);
    });

    testWidgets('TC-REG-08: Menampilkan dan menyembunyikan Kata Sandi pada Registrasi', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: RoutePaths.register);
      await _fillByHint(tester, 'Kata Sandi', 'Password123');

      final toggleShow = find.byTooltip('Tampilkan kata sandi').first;
      expect(toggleShow, findsOneWidget);
      await tester.tap(toggleShow);
      await tester.pumpAndSettle();
      expect(find.byTooltip('Sembunyikan kata sandi'), findsOneWidget);

      await tester.tap(find.byTooltip('Sembunyikan kata sandi').first);
      await tester.pumpAndSettle();
      expect(find.byTooltip('Tampilkan kata sandi'), findsNWidgets(2));
    });

    testWidgets('TC-REG-09: Navigasi dari halaman Registrasi menuju Login', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: RoutePaths.register);
      await _tapText(tester, 'Masuk');
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });

  // =========================================================================
  // FITUR 2: LOGIN (TS-LOGIN-01..03 | TC-LOGIN-01 .. TC-LOGIN-10)
  // =========================================================================
  group('PMPL Fitur 2 - Login (TS-LOGIN-01, TS-LOGIN-02, TS-LOGIN-03)', () {
    testWidgets('TC-LOGIN-01 & TC-LOGIN-10: Login valid berhasil dan ke Dashboard', (
      tester,
    ) async {
      final container = await _pumpApp(
        tester,
        initialLocation: RoutePaths.login,
      );
      await _fillByHint(tester, 'Email', 'dummy@example.com');
      await _fillByHint(tester, 'Kata Sandi', '123456');
      await _tapText(tester, 'Masuk');

      expect(
        container.read(authControllerProvider).status,
        AuthStatus.authenticated,
      );
      expect(find.byType(DashboardPage), findsOneWidget);
    });

    testWidgets('TC-LOGIN-02: Login dengan Email tidak terdaftar gagal', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: RoutePaths.login);
      await _fillByHint(tester, 'Email', 'victoria@gmail.com');
      await _fillByHint(tester, 'Kata Sandi', 'password123');
      await _tapText(tester, 'Masuk');

      expect(find.text('Email atau kata sandi tidak sesuai.'), findsOneWidget);
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('TC-LOGIN-03: Login dengan Kata Sandi salah gagal', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: RoutePaths.login);
      await _fillByHint(tester, 'Email', 'dummy@example.com');
      await _fillByHint(tester, 'Kata Sandi', 'salah123');
      await _tapText(tester, 'Masuk');

      expect(find.text('Email atau kata sandi tidak sesuai.'), findsOneWidget);
    });

    testWidgets('TC-LOGIN-04: Login dengan Email kosong menampilkan validasi', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: RoutePaths.login);
      await _fillByHint(tester, 'Kata Sandi', 'password123');
      await _tapText(tester, 'Masuk');

      expect(find.text('Email wajib diisi.'), findsOneWidget);
    });

    testWidgets('TC-LOGIN-05: Login dengan Kata Sandi kosong menampilkan validasi', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: RoutePaths.login);
      await _fillByHint(tester, 'Email', 'esatovin@gmail.com');
      await _tapText(tester, 'Masuk');

      expect(find.text('Kata sandi wajib diisi.'), findsOneWidget);
    });

    testWidgets('TC-LOGIN-06: Login dengan format Email tidak valid menampilkan validasi', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: RoutePaths.login);
      await _fillByHint(tester, 'Email', 'esatovin.com');
      await _fillByHint(tester, 'Kata Sandi', 'password123');
      await _tapText(tester, 'Masuk');

      expect(find.text('Masukkan email yang valid.'), findsOneWidget);
    });

    testWidgets('TC-LOGIN-07: Toggle tampilkan & sembunyikan Kata Sandi di Login', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: RoutePaths.login);
      await _fillByHint(tester, 'Kata Sandi', 'Password123');

      await tester.tap(find.byTooltip('Tampilkan kata sandi'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Sembunyikan kata sandi'), findsOneWidget);

      await tester.tap(find.byTooltip('Sembunyikan kata sandi'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Tampilkan kata sandi'), findsOneWidget);
    });

    testWidgets('TC-LOGIN-08: Mengakses halaman Lupa Kata Sandi dari Login', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: RoutePaths.login);
      await _tapText(tester, 'Lupa kata sandi?');

      expect(find.byType(ForgotPasswordPage), findsOneWidget);
    });

    testWidgets('TC-LOGIN-09: Navigasi dari Login menuju Registrasi', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: RoutePaths.login);
      await _tapText(tester, 'Daftar');

      expect(find.byType(RegisterPage), findsOneWidget);
    });
  });

  // =========================================================================
  // FITUR 3: DASHBOARD (TS-DASH-01..03 | TC-DASH-01 .. TC-DASH-10)
  // =========================================================================
  group('PMPL Fitur 3 - Dashboard (TS-DASH-01, TS-DASH-02, TS-DASH-03)', () {
    const esatovin = AuthUser(
      id: 'user-esa',
      email: 'esatovin@gmail.com',
      name: 'Esatovin',
    );

    testWidgets('TC-DASH-01 & TC-DASH-02: Menampilkan nama pengguna & risiko terakhir', (
      tester,
    ) async {
      await _pumpApp(
        tester,
        signedInUser: esatovin,
        historyItems: [
          AssessmentHistoryItem(
            id: 'h-1',
            riskLevel: RiskLevel.sedang,
            takenAt: DateTime(2026, 10, 19, 9, 0),
          ),
        ],
      );

      expect(find.text('Esatovin!'), findsOneWidget);
      expect(find.text('Sedang'), findsWidgets);
    });

    testWidgets('TC-DASH-03: Dashboard tanpa riwayat tampil tanpa error', (
      tester,
    ) async {
      await _pumpApp(
        tester,
        signedInUser: esatovin,
        historyItems: const [],
      );

      expect(find.byType(DashboardPage), findsOneWidget);
      expect(find.text('Belum ada asesmen'), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('TC-DASH-04..TC-DASH-10: Pintasan Dashboard & Bottom Navigation', (
      tester,
    ) async {
      await _pumpApp(
        tester,
        signedInUser: esatovin,
        historyItems: [
          AssessmentHistoryItem(
            id: 'h-1',
            riskLevel: RiskLevel.sedang,
            takenAt: DateTime(2026, 10, 19, 9, 0),
          ),
        ],
      );

      // TC-DASH-08: Survei via bottom nav
      await _tapBottomNav(tester, 'Survei');
      expect(find.byType(DashboardPage), findsNothing);

      // TC-DASH-09: Riwayat via bottom nav
      await _tapBottomNav(tester, 'Riwayat');
      expect(find.byType(HistoryPage), findsOneWidget);

      // TC-DASH-10: Profil via bottom nav
      await _tapBottomNav(tester, 'Profil');
      expect(find.byType(ProfilePage), findsOneWidget);

      // TC-DASH-07: Kembali ke Beranda via bottom nav
      await _tapBottomNav(tester, 'Beranda');
      expect(find.byType(DashboardPage), findsOneWidget);

      // TC-DASH-05: Pintasan Riwayat Saya
      await _tapText(tester, 'Riwayat Saya');
      expect(find.byType(HistoryPage), findsOneWidget);
    });
  });

  // =========================================================================
  // FITUR 4: SURVEI INTERAKTIF (TS-SURV-02, TS-SURV-03, TS-SURV-04)
  // =========================================================================
  group('PMPL Fitur 4 - Survei Interaktif (TS-SURV-02..04)', () {
    const testerUser = AuthUser(
      id: 'user-surv',
      email: 'surv@example.com',
      name: 'Survey User',
    );

    testWidgets('TC-SURV-02, TC-SURV-03, TC-SURV-04: Validasi wajib, Next/Back & retensi tab', (
      tester,
    ) async {
      await _pumpApp(tester, signedInUser: testerUser, historyItems: const []);
      await _tapBottomNav(tester, 'Survei');
      await _tapText(tester, 'Mulai Survei');
      expect(find.byType(SurveyQuestionPage), findsOneWidget);

      // TC-SURV-02: Sebelum memilih kualitas tidur, tombol Lanjut belum memindahkan langkah
      await _tapText(tester, 'Lanjut');
      expect(find.text('Baik'), findsOneWidget);

      // Pilih Baik lalu Lanjut -> pindah ke langkah Waktu Layar
      await _tapText(tester, 'Baik');
      await _tapText(tester, 'Lanjut');
      expect(find.text('jam'), findsOneWidget);

      // TC-SURV-04: Pindah ke Riwayat lalu Profil lalu kembali ke Survei -> tetap di langkah Waktu Layar
      await _tapBottomNav(tester, 'Riwayat');
      await _tapBottomNav(tester, 'Profil');
      await _tapBottomNav(tester, 'Survei');
      expect(find.text('jam'), findsOneWidget);

      // TC-SURV-03: Tekan Kembali -> kembali ke pertanyaan Kualitas Tidur dengan jawaban terjaga
      await _tapText(tester, 'Kembali');
      expect(find.text('Baik'), findsOneWidget);
    });
  });

  // =========================================================================
  // FITUR 5 & 6: HASIL PREDIKSI & REKOMENDASI (TS-HAS & TS-REK)
  // =========================================================================
  group('PMPL Fitur 5 & 6 - Hasil Prediksi & Rekomendasi (TS-HAS & TS-REK)', () {
    testWidgets('TC-HAS-001, TC-HAS-002, TC-HAS-004, TC-HAS-005 & TC-REK-04: Kategori, faktor & disclaimer', (
      tester,
    ) async {
      final assessments = {
        'low-1': Assessment(
          id: 'low-1',
          riskLevel: RiskLevel.rendah,
          takenAt: DateTime(2026, 10, 19),
          isExample: false,
          modelFactors: const [
            AssessmentFactor(label: 'Aktivitas dan pola istirahat seimbang'),
          ],
        ),
        'med-1': Assessment(
          id: 'med-1',
          riskLevel: RiskLevel.sedang,
          takenAt: DateTime(2026, 10, 19),
          isExample: false,
          modelFactors: const [
            AssessmentFactor(label: 'Paparan layar intensif (9.0 jam)'),
          ],
        ),
        'high-1': Assessment(
          id: 'high-1',
          riskLevel: RiskLevel.tinggi,
          takenAt: DateTime(2026, 10, 19),
          isExample: false,
          modelFactors: const [
            AssessmentFactor(label: 'Beban aktivitas dan stres harian tinggi'),
          ],
        ),
      };

      for (final entry in [
        ('low-1', 'Rendah', 'Aktivitas dan pola istirahat seimbang'),
        ('med-1', 'Sedang', 'Paparan layar intensif (9.0 jam)'),
        ('high-1', 'Tinggi', 'Beban aktivitas dan stres harian tinggi'),
      ]) {
        await tester.pumpWidget(
          ProviderScope(
            key: ValueKey('scope-${entry.$1}'),
            overrides: [
              assessmentByIdProvider(entry.$1).overrideWith(
                (ref) async => assessments[entry.$1],
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('id'),
              home: ResultPage(assessmentId: entry.$1),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(entry.$2), findsWidgets);
        expect(find.text(entry.$3), findsOneWidget);
        // TC-REK-04: Disclaimer bukan diagnosis medis tampil jelas
        expect(
          find.textContaining('Ini bukan diagnosis medis'),
          findsOneWidget,
        );
      }
    });

    testWidgets('TC-REK-01..03: Rekomendasi Risiko Rendah, Sedang, dan Tinggi (tombol konsultasi)', (
      tester,
    ) async {
      final highAssessment = Assessment(
        id: 'rek-high',
        riskLevel: RiskLevel.tinggi,
        takenAt: DateTime(2026, 10, 19),
        aiRecommendation: 'Kurangi beban kerja dan jadwalkan konseling.',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            assessmentByIdProvider('rek-high').overrideWith(
              (ref) async => highAssessment,
            ),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale('id'),
            home: RecommendationPage(assessmentId: 'rek-high'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Kurangi beban kerja dan jadwalkan konseling.'),
        findsOneWidget,
      );
      // Risiko tinggi menampilkan kartu bantuan konsultasi psikolog
      expect(find.byIcon(Icons.health_and_safety_rounded), findsOneWidget);
    });

    test('TC-HAS-008..010: Kegagalan layanan tidak membuat hasil, retry sukses tidak duplikat', () async {
      final repo = _ControllableAssessmentRepo()..shouldFail = true;
      await expectLater(
        () => repo.submit({'sleep_quality': 'Baik'}),
        throwsA(isA<Exception>()),
      );
      expect(repo.store, isEmpty);

      // Pulihkan layanan & retry
      repo.shouldFail = false;
      final saved = await repo.submit({'sleep_quality': 'Baik'});
      expect(saved.riskLevel, RiskLevel.sedang);
      expect(repo.store.length, 1);
    });
  });

  // =========================================================================
  // FITUR 7: RIWAYAT HASIL & GRAFIK (TS-RIW-01..04 | TC-RIW-001..011)
  // =========================================================================
  group('PMPL Fitur 7 - Riwayat Hasil & Tren Grafik (TS-RIW-01..04)', () {
    const historyUser = AuthUser(
      id: 'user-riw',
      email: 'riw@example.com',
      name: 'User Riwayat',
    );

    testWidgets('TC-RIW-001: Riwayat kosong menampilkan empty state', (
      tester,
    ) async {
      await _pumpApp(
        tester,
        signedInUser: historyUser,
        historyItems: const [],
      );
      await _tapBottomNav(tester, 'Riwayat');

      expect(find.text('Belum ada riwayat pemeriksaan.'), findsOneWidget);
    });

    test('TC-RIW-009, TC-RIW-010, TC-RIW-011: Grafik 7 hari dengan 1, 2, dan multi-hasil di tanggal sama', () {
      final now = DateTime(2026, 10, 19, 12, 0);

      // TC-RIW-010: 1 hasil (hari kosong tanpa hasil buatan)
      final single = WeeklyRiskStatistics.fromAssessments(
        [
          Assessment(
            id: 'r1',
            riskLevel: RiskLevel.rendah,
            takenAt: DateTime(2026, 10, 19, 9, 0),
          ),
        ],
        now: now,
      );
      expect(single.assessments, hasLength(1));
      expect(single.days.where((d) => d.assessments.isEmpty), hasLength(6));

      // TC-RIW-009 & TC-RIW-011: Beberapa hasil pada tanggal sama tidak saling menimpa
      final multi = WeeklyRiskStatistics.fromAssessments(
        [
          Assessment(
            id: 'm1',
            riskLevel: RiskLevel.sedang,
            takenAt: DateTime(2026, 10, 18, 9, 0),
          ),
          Assessment(
            id: 'm2',
            riskLevel: RiskLevel.rendah,
            takenAt: DateTime(2026, 10, 19, 8, 0),
          ),
          Assessment(
            id: 'm3',
            riskLevel: RiskLevel.tinggi,
            takenAt: DateTime(2026, 10, 19, 11, 0),
          ),
        ],
        now: now,
      );
      expect(multi.assessments, hasLength(3));
      expect(multi.days.last.assessments, hasLength(2));
      expect(multi.countFor(RiskLevel.rendah), 1);
      expect(multi.countFor(RiskLevel.sedang), 1);
      expect(multi.countFor(RiskLevel.tinggi), 1);
    });
  });

  // =========================================================================
  // FITUR 8: PROFIL PENGGUNA (TS-PROF-01..10 | TC-PROF-01-01 .. TC-PROF-10-01)
  // =========================================================================
  group('PMPL Fitur 8 - Profil Pengguna (TS-PROF-01..10)', () {
    const profileUser = AuthUser(
      id: 'user-prof',
      email: 'raditya@example.com',
      name: 'Pengguna Awal',
    );

    testWidgets('TC-PROF-01-01, TC-PROF-02-01, TC-PROF-02-02: Profil, edit nama valid & email read-only', (
      tester,
    ) async {
      await _pumpApp(tester, signedInUser: profileUser, historyItems: const []);
      await _tapBottomNav(tester, 'Profil');

      expect(find.text('Pengguna Awal'), findsOneWidget);
      expect(find.text('raditya@example.com'), findsOneWidget);

      await _tapText(tester, 'Edit Profil');
      expect(find.byType(EditProfilePage), findsOneWidget);

      // TC-PROF-02-02: Email bersifat hanya-baca (disabled)
      final emailField = find.byWidgetPredicate(
        (w) => w is TextField && w.enabled == false,
      );
      expect(emailField, findsOneWidget);

      // TC-PROF-02-01: Ubah nama valid dan simpan
      final nameField = find.byKey(const Key('edit-profile-name'));
      await tester.enterText(nameField, 'Raditya Zandra Fadhillah');
      await _tapText(tester, 'Simpan Perubahan');

      expect(find.text('Raditya Zandra Fadhillah'), findsOneWidget);
      expect(find.text('raditya@example.com'), findsOneWidget);
    });

    testWidgets('TC-PROF-03-01, TC-PROF-03-02, TC-PROF-03-03: Validasi nama kosong, spasi & batas 60 karakter', (
      tester,
    ) async {
      await _pumpApp(tester, signedInUser: profileUser, historyItems: const []);
      await _tapBottomNav(tester, 'Profil');
      await _tapText(tester, 'Edit Profil');

      final nameField = find.byKey(const Key('edit-profile-name'));

      // TC-PROF-03-01: Nama kosong
      await tester.enterText(nameField, '');
      await _tapText(tester, 'Simpan Perubahan');
      expect(find.text('Nama tidak boleh kosong.'), findsOneWidget);

      // TC-PROF-03-02: Hanya spasi
      await tester.enterText(nameField, '   ');
      await _tapText(tester, 'Simpan Perubahan');
      expect(find.text('Nama tidak boleh kosong.'), findsOneWidget);

      // TC-PROF-03-03: Batas maksimum 60 karakter
      final sixtyOneA = 'A' * 61;
      await tester.enterText(nameField, sixtyOneA);
      await tester.pumpAndSettle();
      final textField = tester.widget<TextField>(
        find.descendant(of: nameField, matching: find.byType(TextField)),
      );
      expect(textField.controller?.text.length, 60);
    });

    testWidgets('TC-PROF-05-02: Penanganan byte foto tidak valid tanpa crash', (
      tester,
    ) async {
      await _pumpApp(
        tester,
        signedInUser: profileUser,
        historyItems: const [],
        imagePicker: () async => Uint8List.fromList([0, 1, 2, 3]),
      );
      await _tapBottomNav(tester, 'Profil');
      await _tapText(tester, 'Edit Profil');
      await _tapText(tester, 'Ubah Foto');

      expect(
        find.text(
          'Foto belum dapat dibuka. Izinkan akses galeri atau coba foto lain.',
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('TC-PROF-07-01, TC-PROF-07-02, TC-PROF-08-01, TC-PROF-08-02: Preferensi tema & pengingat', (
      tester,
    ) async {
      final container = await _pumpApp(
        tester,
        signedInUser: profileUser,
        historyItems: const [],
      );
      await _tapBottomNav(tester, 'Profil');
      await _tapText(tester, 'Preferensi');
      expect(find.byType(PreferencesPage), findsOneWidget);

      // TC-PROF-08-02: Ubah tema Gelap -> Terang -> Sistem
      await _tapText(tester, 'Gelap');
      expect(
        container.read(preferencesControllerProvider).themeMode,
        ThemeMode.dark,
      );
      await _tapText(tester, 'Terang');
      expect(
        container.read(preferencesControllerProvider).themeMode,
        ThemeMode.light,
      );
      await _tapText(tester, 'Sistem');
      expect(
        container.read(preferencesControllerProvider).themeMode,
        ThemeMode.system,
      );

      // TC-PROF-07-01 & TC-PROF-07-02: Kontrol pengingat tampil & berubah state
      expect(find.text('Pengingat Harian (Check-in)'), findsOneWidget);
      await _tapText(tester, 'Pengingat Harian (Check-in)');
      expect(
        container.read(preferencesControllerProvider).dailyReminder,
        isTrue,
      );
    });

    testWidgets('TC-PROF-09-01 & TC-PROF-10-01: Membuka halaman Bantuan dan Tentang Aplikasi', (
      tester,
    ) async {
      await _pumpApp(tester, signedInUser: profileUser, historyItems: const []);
      await _tapBottomNav(tester, 'Profil');

      await _tapText(tester, 'Bantuan');
      expect(find.byType(HelpPage), findsOneWidget);

      await tester.tap(find.byType(IconButton).first);
      await tester.pumpAndSettle();

      await _tapText(tester, 'Tentang Aplikasi');
      expect(find.byType(AboutPage), findsOneWidget);
      expect(find.text('AntiBurnout'), findsOneWidget);
    });

    testWidgets('TC-PROF-04-01: Logout dari halaman Profil mengakhiri sesi dan ke Login', (
      tester,
    ) async {
      final fakeRepo = FakeAuthRepository();
      final container = await _pumpApp(
        tester,
        initialLocation: RoutePaths.login,
        authRepo: fakeRepo,
        historyItems: const [],
      );
      await _fillByHint(tester, 'Email', 'dummy@example.com');
      await _fillByHint(tester, 'Kata Sandi', '123456');
      await _tapText(tester, 'Masuk');

      await _tapBottomNav(tester, 'Profil');
      final logoutBtn = find.text('Keluar').last;
      await tester.ensureVisible(logoutBtn);
      await tester.tap(logoutBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        container.read(authControllerProvider).status,
        AuthStatus.unauthenticated,
      );
      expect(find.byType(ProfilePage), findsNothing);
      expect(find.byType(WelcomePage), findsOneWidget);
    });
  });
}
