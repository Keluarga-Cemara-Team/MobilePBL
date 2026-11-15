import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser?> getCurrentUser();

  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<AuthUser> loginWithGoogle();

  Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> sendPasswordReset(String email);

  Future<String> requestPasswordResetOtp(String email);

  Future<bool> verifyPasswordResetOtp({
    required String email,
    required String otp,
  });

  Future<void> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<AuthUser> updateProfile({
    required String userId,
    required String name,
    String? photoUrl,
  });
}
