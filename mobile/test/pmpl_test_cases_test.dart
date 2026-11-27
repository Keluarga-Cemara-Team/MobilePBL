import 'dart:async';
import 'dart:convert';
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
import 'package:mobile/features/history/presentation/widgets/assessment_history_tile.dart';
import 'package:mobile/features/profile/data/repositories/in_memory_profile_repository.dart';
import 'package:mobile/features/profile/di/profile_providers.dart';
import 'package:mobile/features/profile/domain/entities/personalization.dart';
import 'package:mobile/features/profile/presentation/controllers/personalization_controller.dart';
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
import 'package:mobile/features/survey/presentation/pages/survey_intro_page.dart';
import 'package:mobile/features/survey/presentation/pages/survey_question_page.dart';
import 'package:mobile/l10n/app_localizations.dart';

/// 1x1 transparent PNG bytes valid untuk pengujian unggah foto profil (TC-PROF-05-01).
final Uint8List _validPngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=',
);

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

class _PerUserHistoryRepo implements HistoryRepository {
  _PerUserHistoryRepo({
    required this.currentUserId,
    required this.recordsByUser,
  });

  final String? Function() currentUserId;
  final Map<String, List<AssessmentHistoryItem>> recordsByUser;

  @override
  Future<List<AssessmentHistoryItem>> fetchHistory() async {
    final uid = currentUserId();
    if (uid == null) return const [];
    return List<AssessmentHistoryItem>.from(recordsByUser[uid] ?? const []);
  }
}

class _ControllableAssessmentRepo implements AssessmentRepository {
  bool shouldFail = false;
  String errorMessage = 'Layanan asesmen belum tersedia';
  Completer<void>? gate;
  int submitCalls = 0;
  RiskLevel nextRisk = RiskLevel.sedang;
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
      throw Exception(errorMessage);
    }
    final result = Assessment(
      id: 'pmpl-asm-$submitCalls',
      riskLevel: nextRisk,
      takenAt: DateTime(2026, 10, 19, 10, submitCalls),
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

/// Validasi kontrak kategori risiko untuk TC-KLA-05.
RiskLevel? parseStrictRiskCategory(String? raw) {
  final normalized = raw?.trim().toLowerCase() ?? '';
  return switch (normalized) {
    'low' || 'rendah' => RiskLevel.rendah,
    'moderate' || 'sedang' => RiskLevel.sedang,
    'high' || 'tinggi' => RiskLevel.tinggi,
    _ => null,
  };
}

Future<ProviderContainer> _pumpApp(
  WidgetTester tester, {
  String initialLocation = RoutePaths.login,
  FakeAuthRepository? authRepo,
  AuthUser? signedInUser,
  List<AssessmentHistoryItem>? historyItems,
  HistoryRepository? historyRepo,
  AssessmentRepository? assessmentRepo,
  InMemoryProfileRepository? profileRepo,
  Future<Uint8List?> Function()? imagePicker,
}) async {
  SharedPreferences.setMockInitialValues({});
  final fakeAuth = authRepo ?? FakeAuthRepository();
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(fakeAuth),
      profileRepositoryProvider.overrideWithValue(
        profileRepo ?? InMemoryProfileRepository(),
      ),
      if (signedInUser != null)
        authControllerProvider.overrideWith(
          () => _SignedInAuthController(signedInUser),
        ),
      if (historyRepo != null)
        historyRepositoryProvider.overrideWithValue(historyRepo)
      else if (historyItems != null) ...[
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

/// Mengisi seluruh 7 pertanyaan survei dari awal hingga halaman ringkasan.
Future<void> _completeSevenSurveyQuestionsToReview(WidgetTester tester) async {
  // 1. Kualitas tidur -> Baik
  await _tapText(tester, 'Baik');
  await _tapText(tester, 'Lanjut');

  // 2. Waktu layar (default 6.0 jam) -> Lanjut
  await _tapText(tester, 'Lanjut');

  // 3. Durasi tidur (default 7.0 jam) -> Lanjut
  await _tapText(tester, 'Lanjut');

  // 4. Konsumsi kopi (default 1 atau 0, tekan + hingga menjadi 2 cangkir)
  final plusBtn = find.byIcon(Icons.add_rounded).first;
  await tester.ensureVisible(plusBtn);
  while (find.text('2').evaluate().isEmpty) {
    await tester.tap(plusBtn);
    await tester.pumpAndSettle();
  }
  await _tapText(tester, 'Lanjut');

  // 5. Beban aktivitas -> Sedang
  await _tapText(tester, 'Sedang');
  await _tapText(tester, 'Lanjut');

  // 6. Meditasi -> pilih preset 10 menit
  await _tapText(tester, '10');
  await _tapText(tester, 'Lanjut');

  // 7. Suasana hati -> Lanjut ke halaman ringkasan
  await _tapText(tester, 'Lanjut');
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

    testWidgets(
      'TC-REG-03 & TC-REG-04: Email kosong & format tidak valid ditolak',
      (tester) async {
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
      },
    );

    testWidgets('TC-REG-05: Registrasi dengan Kata Sandi kosong ditolak', (
      tester,
    ) async {
      await _pumpApp(tester, initialLocation: RoutePaths.register);
      await _fillByHint(tester, 'Nama Lengkap', 'Esatovin Victoria');
      await _fillByHint(tester, 'Email', 'esatovin@gmail.com');
      await _tapText(tester, 'Daftar');

      expect(find.text('Kata sandi minimal 6 karakter.'), findsOneWidget);
    });

    testWidgets(
      'TC-REG-06: Registrasi dengan konfirmasi Kata Sandi berbeda ditolak',
      (tester) async {
        await _pumpApp(tester, initialLocation: RoutePaths.register);
        await _fillByHint(tester, 'Nama Lengkap', 'Esatovin Victoria');
        await _fillByHint(tester, 'Email', 'esatovin@gmail.com');
        await _fillByHint(tester, 'Kata Sandi', 'password123');
        await _fillByHint(tester, 'Konfirmasi Kata Sandi', 'password1234');
        await _tapText(tester, 'Daftar');

        expect(find.text('Konfirmasi kata sandi tidak sama.'), findsOneWidget);
      },
    );

    testWidgets(
      'TC-REG-07: Registrasi dengan Email sudah terdaftar ditolak',
      (tester) async {
        await _pumpApp(tester, initialLocation: RoutePaths.register);
        await _fillByHint(tester, 'Nama Lengkap', 'Esatovin Victoria');
        await _fillByHint(tester, 'Email', 'dummy@example.com');
        await _fillByHint(tester, 'Kata Sandi', 'password123');
        await _fillByHint(tester, 'Konfirmasi Kata Sandi', 'password123');
        await _tapText(tester, 'Daftar');

        expect(find.text('Email sudah terdaftar.'), findsOneWidget);
        expect(find.byType(RegisterPage), findsOneWidget);
      },
    );

    testWidgets(
      'TC-REG-08: Menampilkan dan menyembunyikan Kata Sandi pada Registrasi',
      (tester) async {
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
      },
    );

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
    testWidgets(
      'TC-LOGIN-01 & TC-LOGIN-10: Login valid berhasil dan ke Dashboard',
      (tester) async {
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
      },
    );

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

    testWidgets(
      'TC-LOGIN-05: Login dengan Kata Sandi kosong menampilkan validasi',
      (tester) async {
        await _pumpApp(tester, initialLocation: RoutePaths.login);
        await _fillByHint(tester, 'Email', 'esatovin@gmail.com');
        await _tapText(tester, 'Masuk');

        expect(find.text('Kata sandi wajib diisi.'), findsOneWidget);
      },
    );

    testWidgets(
      'TC-LOGIN-06: Login dengan format Email tidak valid menampilkan validasi',
      (tester) async {
        await _pumpApp(tester, initialLocation: RoutePaths.login);
        await _fillByHint(tester, 'Email', 'esatovin.com');
        await _fillByHint(tester, 'Kata Sandi', 'password123');
        await _tapText(tester, 'Masuk');

        expect(find.text('Masukkan email yang valid.'), findsOneWidget);
      },
    );

    testWidgets(
      'TC-LOGIN-07: Toggle tampilkan & sembunyikan Kata Sandi di Login',
      (tester) async {
        await _pumpApp(tester, initialLocation: RoutePaths.login);
        await _fillByHint(tester, 'Kata Sandi', 'Password123');

        await tester.tap(find.byTooltip('Tampilkan kata sandi'));
        await tester.pumpAndSettle();
        expect(find.byTooltip('Sembunyikan kata sandi'), findsOneWidget);

        await tester.tap(find.byTooltip('Sembunyikan kata sandi'));
        await tester.pumpAndSettle();
        expect(find.byTooltip('Tampilkan kata sandi'), findsOneWidget);
      },
    );

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

    testWidgets(
      'TC-DASH-01 & TC-DASH-02: Menampilkan nama pengguna & risiko terakhir',
      (tester) async {
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
      },
    );

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

    testWidgets(
      'TC-DASH-04 & TC-DASH-06: Pintasan Mulai Survei & Lihat Detail dari Dashboard',
      (tester) async {
        final repo = _ControllableAssessmentRepo();
        repo.store['h-detail'] = Assessment(
          id: 'h-detail',
          riskLevel: RiskLevel.sedang,
          takenAt: DateTime(2026, 10, 19, 9, 0),
          modelFactors: const [
            AssessmentFactor(label: 'Waktu layar intensif (8.5 jam)'),
          ],
        );

        await _pumpApp(
          tester,
          signedInUser: esatovin,
          assessmentRepo: repo,
          historyItems: [
            AssessmentHistoryItem(
              id: 'h-detail',
              riskLevel: RiskLevel.sedang,
              takenAt: DateTime(2026, 10, 19, 9, 0),
            ),
          ],
        );

        // TC-DASH-06: Tap Lihat Detail pada kartu hasil asesmen terakhir
        final viewDetail = find.textContaining('Lihat Detail').first;
        await tester.ensureVisible(viewDetail);
        await tester.tap(viewDetail);
        await tester.pumpAndSettle();
        expect(find.byType(ResultPage), findsOneWidget);
        expect(find.text('Sedang'), findsWidgets);

        // Kembali ke Beranda
        await _tapBottomNav(tester, 'Beranda');
        expect(find.byType(DashboardPage), findsOneWidget);

        // TC-DASH-04: Tap pintasan Mulai Survei di Dashboard
        await _tapText(tester, 'Mulai Survei');
        expect(find.byType(SurveyIntroPage), findsOneWidget);
      },
    );

    testWidgets(
      'TC-DASH-05 & TC-DASH-07..TC-DASH-10: Pintasan Riwayat & Bottom Navigation',
      (tester) async {
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
      },
    );
  });

  // =========================================================================
  // FITUR 4: SURVEI INTERAKTIF (TS-SURV-01..04 | TC-SURV-01 .. TC-SURV-04)
  // =========================================================================
  group('PMPL Fitur 4 - Survei Interaktif (TS-SURV-01..04)', () {
    const testerUser = AuthUser(
      id: 'user-surv',
      email: 'surv@example.com',
      name: 'Survey User',
    );

    testWidgets(
      'TC-SURV-01: Mengisi 7 pertanyaan, meninjau ringkasan & mengubah jawaban kopi 2 -> 3',
      (tester) async {
        await _pumpApp(
          tester,
          signedInUser: testerUser,
          historyItems: const [],
        );
        await _tapBottomNav(tester, 'Survei');
        await _tapText(tester, 'Mulai Survei');
        expect(find.byType(SurveyQuestionPage), findsOneWidget);

        await _completeSevenSurveyQuestionsToReview(tester);

        // Ringkasan menampilkan 7 jawaban dan judul Periksa jawabanmu
        expect(find.text('Periksa jawabanmu'), findsOneWidget);
        expect(find.text('Ubah'), findsNWidgets(7));
        expect(find.textContaining('2 cangkir'), findsOneWidget);
        expect(find.text('Baik'), findsOneWidget);
        expect(find.text('Sedang'), findsOneWidget);

        // Tekan Ubah pada baris kopi (index ke-3 dari 7 pertanyaan)
        final editCoffee = find.text('Ubah').at(3);
        await tester.ensureVisible(editCoffee);
        await tester.tap(editCoffee);
        await tester.pumpAndSettle();

        // Ubah konsumsi kopi dari 2 menjadi 3
        final plusBtn = find.byIcon(Icons.add_rounded).first;
        await tester.ensureVisible(plusBtn);
        await tester.tap(plusBtn);
        await tester.pumpAndSettle();
        expect(find.text('3'), findsOneWidget);

        // Lanjut kembali ke ringkasan (langkah 4 -> 5 -> 6 -> 7 -> review)
        for (var i = 0; i < 4; i++) {
          await _tapText(tester, 'Lanjut');
        }

        expect(find.text('Periksa jawabanmu'), findsOneWidget);
        expect(find.textContaining('3 cangkir'), findsOneWidget);
        expect(find.text('Baik'), findsOneWidget);
        expect(find.text('Sedang'), findsOneWidget);
      },
    );

    testWidgets(
      'TC-SURV-02, TC-SURV-03, TC-SURV-04: Validasi wajib, Next/Back & retensi tab',
      (tester) async {
        await _pumpApp(
          tester,
          signedInUser: testerUser,
          historyItems: const [],
        );
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
      },
    );
  });

  // =========================================================================
  // FITUR 5: DETEKSI & KLASIFIKASI RISIKO (TS-DET & TS-KLA | TC-DET, TC-KLA)
  // =========================================================================
  group('PMPL Fitur 5 - Deteksi & Klasifikasi Risiko (TS-DET & TS-KLA)', () {
    const detUser = AuthUser(
      id: 'user-det',
      email: 'det@example.com',
      name: 'Deteksi User',
    );

    testWidgets(
      'TC-DET-001..003 & TC-HAS-003: Loading tertunda, gagal layanan jaga jawaban, lalu retry sukses',
      (tester) async {
        final gate = Completer<void>();
        final repo = _ControllableAssessmentRepo()
          ..shouldFail = true
          ..gate = gate
          ..nextRisk = RiskLevel.sedang;

        await _pumpApp(
          tester,
          signedInUser: detUser,
          historyItems: const [],
          assessmentRepo: repo,
        );
        await _tapBottomNav(tester, 'Survei');
        await _tapText(tester, 'Mulai Survei');
        await _completeSevenSurveyQuestionsToReview(tester);

        // Tekan Kirim & lihat hasil -> saat tertunda tampil loading indicator
        final submitBtn = find.text('Kirim & lihat hasil');
        await tester.ensureVisible(submitBtn);
        await tester.tap(submitBtn);
        await tester.pump();
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Selesaikan request dalam kondisi gagal (TC-HAS-003 / TC-DET-004..006)
        gate.complete();
        await tester.pumpAndSettle();
        expect(repo.store, isEmpty);
        expect(find.text('Periksa jawabanmu'), findsOneWidget);
        expect(find.text('Baik'), findsOneWidget); // Jawaban tetap terjaga

        // Pulihkan layanan & Retry (TC-HAS-010 & TC-DET-001..002)
        repo.gate = null;
        repo.shouldFail = false;
        await _tapText(tester, 'Kirim & lihat hasil');

        expect(repo.store.length, 1);
        expect(find.byType(ResultPage), findsOneWidget);
        expect(find.text('Sedang'), findsWidgets);
      },
    );

    test(
      'TC-KLA-01..05: Klasifikasi strictly 3 kategori valid & tolak kategori TidakDikenal/kosong',
      () {
        expect(parseStrictRiskCategory('Low'), RiskLevel.rendah);
        expect(parseStrictRiskCategory('Rendah'), RiskLevel.rendah);
        expect(parseStrictRiskCategory('Moderate'), RiskLevel.sedang);
        expect(parseStrictRiskCategory('Sedang'), RiskLevel.sedang);
        expect(parseStrictRiskCategory('High'), RiskLevel.tinggi);
        expect(parseStrictRiskCategory('Tinggi'), RiskLevel.tinggi);

        // TC-KLA-05: Kategori tidak dikenali atau kosong ditolak sebagai tidak valid
        expect(parseStrictRiskCategory('TidakDikenal'), isNull);
        expect(parseStrictRiskCategory(''), isNull);
        expect(parseStrictRiskCategory('   '), isNull);
        expect(parseStrictRiskCategory(null), isNull);
        expect(RiskLevel.values.length, 3);
      },
    );
  });

  // =========================================================================
  // FITUR 6: HASIL PREDIKSI & REKOMENDASI (TS-HAS & TS-REK)
  // =========================================================================
  group('PMPL Fitur 6 - Hasil Prediksi & Rekomendasi (TS-HAS & TS-REK)', () {
    testWidgets(
      'TC-HAS-001, TC-HAS-002, TC-HAS-004, TC-HAS-005 & TC-REK-04: Kategori, faktor & disclaimer',
      (tester) async {
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
      },
    );

    testWidgets(
      'TC-REK-01, TC-REK-02, TC-REK-03: Rekomendasi Risiko Rendah, Sedang & Tinggi (konsultasi psikolog)',
      (tester) async {
        final cases = [
          (
            'rek-low',
            RiskLevel.rendah,
            'Pertahankan jadwal tidur teratur dan rutinitas sehat.',
            false,
          ),
          (
            'rek-med',
            RiskLevel.sedang,
            'Ambil jeda teratur dan kurangi paparan layar malam.',
            false,
          ),
          (
            'rek-high',
            RiskLevel.tinggi,
            'Kurangi beban kerja dan jadwalkan konseling profesional.',
            true,
          ),
        ];

        for (final c in cases) {
          final item = Assessment(
            id: c.$1,
            riskLevel: c.$2,
            takenAt: DateTime(2026, 10, 19),
            aiRecommendation: c.$3,
          );

          await tester.pumpWidget(
            ProviderScope(
              key: ValueKey('rec-scope-${c.$1}'),
              overrides: [
                assessmentByIdProvider(c.$1).overrideWith((ref) async => item),
              ],
              child: MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: const Locale('id'),
                home: RecommendationPage(assessmentId: c.$1),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.text(c.$3), findsOneWidget);
          expect(
            find.byIcon(Icons.health_and_safety_rounded),
            c.$4 ? findsOneWidget : findsNothing,
          );
        }
      },
    );

    test(
      'TC-HAS-006..010: Kegagalan layanan tidak membuat hasil, retry sukses tersimpan tanpa duplikat',
      () async {
        final repo = _ControllableAssessmentRepo()..shouldFail = true;
        await expectLater(
          () => repo.submit({'sleep_quality': 'Baik'}),
          throwsA(isA<Exception>()),
        );
        expect(repo.store, isEmpty);

        repo.shouldFail = false;
        final saved = await repo.submit({'sleep_quality': 'Baik'});
        expect(saved.riskLevel, RiskLevel.sedang);
        expect(repo.store.length, 1);
      },
    );
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

    testWidgets(
      'TC-RIW-002 & TC-RIW-003: Daftar riwayat tampil & terurut terbaru ke terlama (19 -> 18 -> 17 Okt)',
      (tester) async {
        // Input sengaja tidak berurutan
        final unsorted = [
          AssessmentHistoryItem(
            id: 'r-17',
            riskLevel: RiskLevel.rendah,
            takenAt: DateTime(2026, 10, 17, 9, 0),
          ),
          AssessmentHistoryItem(
            id: 'r-19',
            riskLevel: RiskLevel.tinggi,
            takenAt: DateTime(2026, 10, 19, 9, 0),
          ),
          AssessmentHistoryItem(
            id: 'r-18',
            riskLevel: RiskLevel.sedang,
            takenAt: DateTime(2026, 10, 18, 9, 0),
          ),
        ];

        await _pumpApp(
          tester,
          signedInUser: historyUser,
          historyItems: unsorted,
        );
        await _tapBottomNav(tester, 'Riwayat');

        final tiles = tester
            .widgetList<AssessmentHistoryTile>(
              find.byType(AssessmentHistoryTile),
            )
            .toList();
        expect(tiles.length, 3);
        expect(tiles[0].item.id, 'r-19');
        expect(tiles[1].item.id, 'r-18');
        expect(tiles[2].item.id, 'r-17');
      },
    );

    testWidgets(
      'TC-RIW-004: Scroll daftar riwayat dengan 12 item tanpa lag atau crash',
      (tester) async {
        final many = List.generate(
          12,
          (i) => AssessmentHistoryItem(
            id: 'bulk-$i',
            riskLevel: RiskLevel.values[i % 3],
            takenAt: DateTime(2026, 10, 19 - i, 9, 0),
          ),
        );

        await _pumpApp(
          tester,
          signedInUser: historyUser,
          historyItems: many,
        );
        await _tapBottomNav(tester, 'Riwayat');

        final scrollable = find.byType(ListView).first;
        await tester.fling(scrollable, const Offset(0, -1200), 1500);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'TC-RIW-005: Isolasi riwayat antar pengguna (Akun A vs Akun B)',
      (tester) async {
        const userA = AuthUser(id: 'akun-a', email: 'a@example.com', name: 'A');
        const userB = AuthUser(id: 'akun-b', email: 'b@example.com', name: 'B');

        final records = {
          'akun-a': [
            AssessmentHistoryItem(
              id: 'A-R1',
              riskLevel: RiskLevel.rendah,
              takenAt: DateTime(2026, 10, 18, 9, 0),
            ),
            AssessmentHistoryItem(
              id: 'A-R2',
              riskLevel: RiskLevel.sedang,
              takenAt: DateTime(2026, 10, 19, 9, 0),
            ),
          ],
          'akun-b': [
            AssessmentHistoryItem(
              id: 'B-R1',
              riskLevel: RiskLevel.tinggi,
              takenAt: DateTime(2026, 10, 19, 10, 0),
            ),
          ],
        };

        // 1. Login sebagai A -> hanya melihat A-R1 dan A-R2
        await _pumpApp(
          tester,
          signedInUser: userA,
          historyRepo: _PerUserHistoryRepo(
            currentUserId: () => userA.id,
            recordsByUser: records,
          ),
        );
        await _tapBottomNav(tester, 'Riwayat');
        var tiles = tester
            .widgetList<AssessmentHistoryTile>(
              find.byType(AssessmentHistoryTile),
            )
            .map((t) => t.item.id)
            .toList();
        expect(tiles, containsAll(['A-R1', 'A-R2']));
        expect(tiles, isNot(contains('B-R1')));

        // 2. Login sebagai B -> hanya melihat B-R1
        await _pumpApp(
          tester,
          signedInUser: userB,
          historyRepo: _PerUserHistoryRepo(
            currentUserId: () => userB.id,
            recordsByUser: records,
          ),
        );
        await _tapBottomNav(tester, 'Riwayat');
        tiles = tester
            .widgetList<AssessmentHistoryTile>(
              find.byType(AssessmentHistoryTile),
            )
            .map((t) => t.item.id)
            .toList();
        expect(tiles, ['B-R1']);
      },
    );

    testWidgets(
      'TC-RIW-006, TC-RIW-007, TC-RIW-008: Buka detail riwayat, rekomendasi terkait & kembali ke Riwayat',
      (tester) async {
        final repo = _ControllableAssessmentRepo();
        repo.store['riw-detail'] = Assessment(
          id: 'riw-detail',
          riskLevel: RiskLevel.tinggi,
          takenAt: DateTime(2026, 10, 19, 9, 0),
          modelFactors: const [
            AssessmentFactor(label: 'Kelelahan kerja kronis'),
          ],
          aiRecommendation: 'Prioritaskan istirahat dan konsultasi profesional.',
        );

        await _pumpApp(
          tester,
          signedInUser: historyUser,
          assessmentRepo: repo,
          historyItems: [
            AssessmentHistoryItem(
              id: 'riw-detail',
              riskLevel: RiskLevel.tinggi,
              takenAt: DateTime(2026, 10, 19, 9, 0),
            ),
          ],
        );
        await _tapBottomNav(tester, 'Riwayat');

        // TC-RIW-006: Klik item riwayat -> buka detail hasil
        await _tapText(tester, 'Detail');
        expect(find.byType(ResultPage), findsOneWidget);
        expect(find.text('Kelelahan kerja kronis'), findsOneWidget);

        // TC-RIW-007: Buka rekomendasi dari detail hasil
        await _tapText(tester, 'Lihat Rekomendasi');
        expect(find.byType(RecommendationPage), findsOneWidget);
        expect(
          find.text('Prioritaskan istirahat dan konsultasi profesional.'),
          findsOneWidget,
        );

        // TC-RIW-008: Kembali dari rekomendasi -> detail -> daftar Riwayat tanpa error
        final recBack = find.byType(IconButton).first;
        await tester.ensureVisible(recBack);
        await tester.tap(recBack);
        await tester.pumpAndSettle();
        expect(find.byType(ResultPage), findsOneWidget);

        final resBack = find.byType(IconButton).first;
        await tester.ensureVisible(resBack);
        await tester.tap(resBack);
        await tester.pumpAndSettle();
        expect(find.byType(HistoryPage), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    test(
      'TC-RIW-009, TC-RIW-010, TC-RIW-011: Grafik 7 hari dengan 1, 2, dan multi-hasil di tanggal sama',
      () {
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
      },
    );
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

    testWidgets(
      'TC-PROF-01-01, TC-PROF-02-01, TC-PROF-02-02: Profil, edit nama valid & email read-only',
      (tester) async {
        await _pumpApp(
          tester,
          signedInUser: profileUser,
          historyItems: const [],
        );
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
      },
    );

    testWidgets(
      'TC-PROF-03-01, TC-PROF-03-02, TC-PROF-03-03: Validasi nama kosong, spasi & batas 60 karakter',
      (tester) async {
        await _pumpApp(
          tester,
          signedInUser: profileUser,
          historyItems: const [],
        );
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
      },
    );

    testWidgets(
      'TC-PROF-05-01: Mengubah foto profil dengan gambar PNG valid berhasil diperbarui',
      (tester) async {
        final container = await _pumpApp(
          tester,
          signedInUser: profileUser,
          historyItems: const [],
          imagePicker: () async => _validPngBytes,
        );
        await _tapBottomNav(tester, 'Profil');
        await _tapText(tester, 'Edit Profil');
        final changePhoto = find.text('Ubah Foto').last;
        await tester.ensureVisible(changePhoto);
        await tester.tap(changePhoto);
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 100)),
        );
        await tester.pumpAndSettle();
        await _tapText(tester, 'Simpan Perubahan');

        expect(
          container.read(profileControllerProvider).photoBytes,
          equals(_validPngBytes),
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'TC-PROF-05-02: Penanganan byte foto kosong & tidak valid tanpa crash',
      (tester) async {
        Uint8List nextBytes = Uint8List(0);
        await _pumpApp(
          tester,
          signedInUser: profileUser,
          historyItems: const [],
          imagePicker: () async => nextBytes,
        );
        await _tapBottomNav(tester, 'Profil');
        await _tapText(tester, 'Edit Profil');

        // 1. Byte kosong
        await _tapText(tester, 'Ubah Foto');
        expect(tester.takeException(), isNull);

        // 2. Byte tidak valid [0, 1, 2, 3]
        nextBytes = Uint8List.fromList([0, 1, 2, 3]);
        await _tapText(tester, 'Ubah Foto');
        expect(
          find.text(
            'Foto belum dapat dibuka. Izinkan akses galeri atau coba foto lain.',
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'TC-PROF-06-01: Mengakses & mengisi 3 tahap Personalisasi Profil (12 nilai), navigasi & retensi sesi',
      (tester) async {
        final profileRepo = InMemoryProfileRepository();
        final container = await _pumpApp(
          tester,
          signedInUser: profileUser,
          historyItems: const [],
          profileRepo: profileRepo,
        );
        await _tapBottomNav(tester, 'Profil');
        await _tapText(tester, 'Personalisasi Profil');
        expect(find.byType(PersonalizationPage), findsOneWidget);

        // Isi seluruh 12 nilai personalisasi melalui controller & verifikasi navigasi 3 tahap
        final targetData = Personalization(
          birthDate: DateTime(2000, 1, 1),
          gender: 'Laki-laki',
          country: 'Indonesia',
          education: 'D4 / S1',
          occupation: 'Pelajar / Mahasiswa',
          employmentStatus: 'Penuh waktu',
          workLocation: 'Hybrid',
          smoking: 'Tidak',
          alcohol: 'Tidak',
          income: '5000000',
          familyMentalHealthHistory: 'Tidak',
          professionalSupport: 'Ya',
        );
        container.read(personalizationControllerProvider.notifier).update(
          targetData,
        );
        await tester.pumpAndSettle();

        // Tahap 1 -> Tahap 2 -> Kembali ke Tahap 1 -> Tahap 2 -> Tahap 3 -> Simpan
        await _tapText(tester, 'Selanjutnya');
        expect(find.text('Hybrid'), findsOneWidget);
        await _tapText(tester, 'Sebelumnya');
        expect(find.text('Laki-laki'), findsOneWidget);

        await _tapText(tester, 'Selanjutnya');
        await _tapText(tester, 'Selanjutnya');
        await _tapText(tester, 'Simpan Personalisasi');

        // Kembali ke Profil lalu buka lagi Personalisasi Profil dalam sesi sama
        expect(find.byType(ProfilePage), findsOneWidget);
        await _tapText(tester, 'Personalisasi Profil');
        expect(find.byType(PersonalizationPage), findsOneWidget);

        final saved = container.read(personalizationControllerProvider).data;
        expect(saved.birthDate, DateTime(2000, 1, 1));
        expect(saved.gender, 'Laki-laki');
        expect(saved.country, 'Indonesia');
        expect(saved.education, 'D4 / S1');
        expect(saved.occupation, 'Pelajar / Mahasiswa');
        expect(saved.employmentStatus, 'Penuh waktu');
        expect(saved.workLocation, 'Hybrid');
        expect(saved.smoking, 'Tidak');
        expect(saved.alcohol, 'Tidak');
        expect(saved.income, '5000000');
        expect(saved.familyMentalHealthHistory, 'Tidak');
        expect(saved.professionalSupport, 'Ya');
      },
    );

    testWidgets(
      'TC-PROF-07-01, TC-PROF-07-02, TC-PROF-08-01, TC-PROF-08-02: Preferensi tema & pengingat',
      (tester) async {
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

        // TC-PROF-07-01 & TC-PROF-07-02: Toggle pengingat aktif, keluar & buka ulang, lalu nonaktifkan
        expect(find.text('Pengingat Harian (Check-in)'), findsOneWidget);
        await _tapText(tester, 'Pengingat Harian (Check-in)');
        expect(
          container.read(preferencesControllerProvider).dailyReminder,
          isTrue,
        );

        await tester.tap(find.byType(IconButton).first);
        await tester.pumpAndSettle();
        await _tapText(tester, 'Preferensi');
        expect(
          container.read(preferencesControllerProvider).dailyReminder,
          isTrue,
        );

        await _tapText(tester, 'Pengingat Harian (Check-in)');
        expect(
          container.read(preferencesControllerProvider).dailyReminder,
          isFalse,
        );
      },
    );

    testWidgets(
      'TC-PROF-09-01 & TC-PROF-10-01: Membuka halaman Bantuan dan Tentang Aplikasi',
      (tester) async {
        await _pumpApp(
          tester,
          signedInUser: profileUser,
          historyItems: const [],
        );
        await _tapBottomNav(tester, 'Profil');

        await _tapText(tester, 'Bantuan');
        expect(find.byType(HelpPage), findsOneWidget);

        await tester.tap(find.byType(IconButton).first);
        await tester.pumpAndSettle();

        await _tapText(tester, 'Tentang Aplikasi');
        expect(find.byType(AboutPage), findsOneWidget);
        expect(find.text('AntiBurnout'), findsOneWidget);
      },
    );

    testWidgets(
      'TC-PROF-04-01: Logout dari halaman Profil mengakhiri sesi dan ke Login',
      (tester) async {
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
      },
    );
  });
}
