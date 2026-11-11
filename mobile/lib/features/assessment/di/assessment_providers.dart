import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/controllers/auth_controller.dart';
import '../data/fixtures/assessment_fixtures.dart';
import '../data/repositories/firestore_assessment_repository.dart';
import '../domain/entities/assessment.dart';
import '../domain/repositories/assessment_repository.dart';
import '../domain/usecases/submit_assessment.dart';

final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  return FirestoreAssessmentRepository(
    currentUserProvider: () => ref.read(authControllerProvider).user,
  );
});

/// Successful submissions remain available by their exact ID for this session.
final assessmentSessionCacheProvider = StateProvider<Map<String, Assessment>>((
  ref,
) {
  ref.watch(authControllerProvider.select((state) => state.user?.id));
  return {};
});

final assessmentByIdProvider = FutureProvider.family<Assessment?, String>((
  ref,
  id,
) async {
  final cached = ref.watch(assessmentSessionCacheProvider)[id];
  if (cached != null) return cached;
  final fromRepo = await ref.watch(assessmentRepositoryProvider).getById(id);
  if (fromRepo != null) return fromRepo;

  // Fallback ke data contoh jika id adalah item pratinjau demo
  if (id == '1' || id == '2' || id == '3' || id == '4' || id.startsWith('demo-')) {
    final risk = switch (id) {
      '1' => RiskLevel.tinggi,
      '2' || '4' => RiskLevel.sedang,
      _ => RiskLevel.rendah,
    };
    return createExampleAssessment(
      id: id,
      riskLevel: risk,
      takenAt: DateTime.now().subtract(const Duration(days: 1)),
    );
  }
  return null;
});

final submitAssessmentProvider = Provider<SubmitAssessment>(
  (ref) => SubmitAssessment(ref.watch(assessmentRepositoryProvider)),
);
