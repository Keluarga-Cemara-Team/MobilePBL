import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/firestore_auth_repository.dart';
import '../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirestoreAuthRepository();
});
