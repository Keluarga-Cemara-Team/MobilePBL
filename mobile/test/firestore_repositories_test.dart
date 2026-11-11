import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/assessment/data/repositories/firestore_assessment_repository.dart';
import 'package:mobile/features/assessment/domain/entities/risk_level.dart';
import 'package:mobile/features/auth/data/repositories/firestore_auth_repository.dart';
import 'package:mobile/features/auth/domain/entities/auth_user.dart';
import 'package:mobile/features/history/data/repositories/firestore_history_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FirestoreAuthRepository Tests', () {
    late FirestoreAuthRepository authRepo;

    setUp(() {
      authRepo = FirestoreAuthRepository();
    });

    test('Login dengan akun dummy fallback berhasil dan mengembalikan AuthUser', () async {
      final user = await authRepo.login(
        email: 'dummy@example.com',
        password: '123456',
      );

      expect(user.email, 'dummy@example.com');
      expect(user.name, isNotEmpty);
      expect(await authRepo.getCurrentUser(), isNotNull);
    });

    test('Logout mengosongkan pengguna aktif', () async {
      await authRepo.login(
        email: 'dummy@example.com',
        password: '123456',
      );
      expect(await authRepo.getCurrentUser(), isNotNull);

      await authRepo.logout();
      expect(await authRepo.getCurrentUser(), isNull);
    });

    test('Registrasi dengan nama terlalu pendek melempar Exception', () async {
      expect(
        () => authRepo.register(
          name: 'A',
          email: 'test@example.com',
          password: 'password123',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Registrasi dengan password kurang dari 6 karakter melempar Exception', () async {
      expect(
        () => authRepo.register(
          name: 'Budi Santoso',
          email: 'budi@example.com',
          password: '123',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('FirestoreAssessmentRepository Tests', () {
    late FirestoreAssessmentRepository assessmentRepo;

    setUp(() {
      assessmentRepo = FirestoreAssessmentRepository(
        currentUserProvider: () => const AuthUser(
          id: 'test-user-1',
          email: 'tester@example.com',
          name: 'Tester AntiBurnout',
        ),
      );
    });

    test('Submit dengan beban aktivitas berat dan tidur minim menghasilkan risiko tinggi', () async {
      final answers = {
        'sleep_quality': 'Buruk',
        'sleep_hours': '4.5',
        'screen_hours': '10.0',
        'coffee_cups': '5',
        'activity_load': 'Berat',
        'meditation_minutes': '0',
        'mood_rating': '30',
      };

      final result = await assessmentRepo.submit(answers);

      expect(result.id, isNotEmpty);
      expect(result.riskLevel, RiskLevel.tinggi);
      expect(result.isExample, isFalse);
      expect(result.modelFactors.isNotEmpty, isTrue);
      expect(result.answerSummary.length, 7);
    });

    test('Submit dengan beban ringan dan tidur cukup menghasilkan risiko rendah', () async {
      final answers = {
        'sleep_quality': 'Sangat baik',
        'sleep_hours': '8.0',
        'screen_hours': '4.0',
        'coffee_cups': '1',
        'activity_load': 'Ringan',
        'meditation_minutes': '20',
        'mood_rating': '85',
      };

      final result = await assessmentRepo.submit(answers);

      expect(result.id, isNotEmpty);
      expect(result.riskLevel, RiskLevel.rendah);
      expect(result.isExample, isFalse);
      expect(result.answerSummary.length, 7);
    });
  });

  group('FirestoreHistoryRepository Tests', () {
    test('fetchHistory fallback mengembalikan daftar riwayat terurut berdasarkan tanggal', () async {
      final historyRepo = FirestoreHistoryRepository(
        currentUserProvider: () => const AuthUser(
          id: 'test-user-1',
          email: 'tester@example.com',
          name: 'Tester AntiBurnout',
        ),
      );

      final items = await historyRepo.fetchHistory();
      expect(items.isNotEmpty, isTrue);

      // Verifikasi urutan tanggal descending
      for (var i = 0; i < items.length - 1; i++) {
        expect(
          items[i].takenAt.isAfter(items[i + 1].takenAt) ||
              items[i].takenAt.isAtSameMomentAs(items[i + 1].takenAt),
          isTrue,
        );
      }
    });
  });
}

