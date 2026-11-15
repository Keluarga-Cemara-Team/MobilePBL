import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  AuthUser? _currentUser;
  final Map<String, _OtpEntry> _otps = {};

  final Map<String, _StoredAccount> _accounts = {
    'dummy@example.com': const _StoredAccount(
      user: AuthUser(
        id: 'dummy-user',
        email: 'dummy@example.com',
        name: 'Dummy',
      ),
      password: '123456',
    ),
  };

  @override
  Future<AuthUser?> getCurrentUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _currentUser;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final cleanEmail = email.trim().toLowerCase();
    final account = _accounts[cleanEmail];

    if (account == null || account.password != password) {
      throw Exception('Email atau kata sandi tidak sesuai.');
    }

    _currentUser = account.user;
    return account.user;
  }

  bool isGoogleNewUser = false;

  @override
  Future<AuthUser> loginWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final googleUser = AuthUser(
      id: 'google-demo-user',
      email: 'user.google@gmail.com',
      name: 'Google User Demo',
      photoUrl: null,
      isNewUser: isGoogleNewUser,
    );
    _currentUser = googleUser;
    return googleUser;
  }

  @override
  Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final key = email.trim().toLowerCase();

    if (_accounts.containsKey(key)) {
      throw Exception('Email sudah terdaftar.');
    }

    final user = AuthUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: key,
      name: name.trim(),
      isNewUser: true,
    );

    _accounts[key] = _StoredAccount(
      user: AuthUser(
        id: user.id,
        email: user.email,
        name: user.name,
        photoUrl: user.photoUrl,
        isNewUser: false,
      ),
      password: password,
    );
    _currentUser = _accounts[key]!.user;

    return user;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      throw Exception('Format email tidak valid.');
    }
  }

  @override
  Future<String> requestPasswordResetOtp(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      throw Exception('Format email tidak valid.');
    }
    const otp = '123456';
    _otps[cleanEmail] = _OtpEntry(
      otp: otp,
      expiresAt: DateTime.now().add(const Duration(minutes: 10)),
    );
    return otp;
  }

  @override
  Future<bool> verifyPasswordResetOtp({
    required String email,
    required String otp,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final cleanEmail = email.trim().toLowerCase();
    final entry = _otps[cleanEmail];
    if (entry == null) {
      if (otp.trim() == '123456') return true;
      throw Exception('Kode OTP belum diminta. Silakan minta kode OTP.');
    }
    if (DateTime.now().isAfter(entry.expiresAt)) {
      throw Exception('Kode OTP telah kedaluwarsa. Silakan minta kode baru.');
    }
    if (entry.otp != otp.trim() && otp.trim() != '123456') {
      throw Exception('Kode OTP tidak sesuai. Periksa kembali kode Anda.');
    }
    return true;
  }

  @override
  Future<void> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    await verifyPasswordResetOtp(email: email, otp: otp);
    final cleanEmail = email.trim().toLowerCase();
    final account = _accounts[cleanEmail];
    if (account != null) {
      _accounts[cleanEmail] = _StoredAccount(
        user: account.user,
        password: newPassword,
      );
    }
    _otps.remove(cleanEmail);
  }

  @override
  Future<AuthUser> updateProfile({
    required String userId,
    required String name,
    String? photoUrl,
  }) async {
    final updated = AuthUser(
      id: userId,
      email: _currentUser?.email ?? '',
      name: name.trim(),
      photoUrl: photoUrl,
    );
    _currentUser = updated;
    return updated;
  }
}

class _StoredAccount {
  const _StoredAccount({required this.user, required this.password});

  final AuthUser user;
  final String password;
}

class _OtpEntry {
  const _OtpEntry({required this.otp, required this.expiresAt});

  final String otp;
  final DateTime expiresAt;
}
