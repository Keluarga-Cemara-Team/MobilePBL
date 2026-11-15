import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/firestore_psychologist_repository.dart';
import '../domain/repositories/psychologist_repository.dart';

final psychologistRepositoryProvider = Provider<PsychologistRepository>((ref) {
  return FirestorePsychologistRepository();
});

