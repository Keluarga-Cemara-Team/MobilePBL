import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/controllers/auth_controller.dart';
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
  return ref.watch(assessmentRepositoryProvider).getById(id);
});

final submitAssessmentProvider = Provider<SubmitAssessment>(
  (ref) => SubmitAssessment(ref.watch(assessmentRepositoryProvider)),
);
