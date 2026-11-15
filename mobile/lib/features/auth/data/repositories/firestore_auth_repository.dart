import 'dart:convert';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../../../firebase_options.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class FirestoreAuthRepository implements AuthRepository {
  FirestoreAuthRepository({FirebaseFirestore? firestore})
      : _customFirestore = firestore;

  final FirebaseFirestore? _customFirestore;
  FirebaseFirestore get _firestore => _customFirestore ?? FirebaseFirestore.instance;

  Future<void> _ensureFirebase() async {
    if (Firebase.apps.isEmpty) {
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } catch (e) {
        debugPrint('Auto-init Firebase warning: $e');
      }
    }
  }

  AuthUser? _currentUser;

  // Akun cadangan offline/pengujian jika Firebase tidak terjangkau jaringan
  static const _fallbackEmail = 'dummy@example.com';
  static const _fallbackPassword = '123456';
  static const _fallbackUser = AuthUser(
    id: 'dummy-user-id',
    email: _fallbackEmail,
    name: 'Pengguna Uji Coba',
  );

  @override
  Future<AuthUser?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    // 1. Dukungan akun fallback pengujian
    if (cleanEmail == _fallbackEmail && cleanPassword == _fallbackPassword) {
      _currentUser = _fallbackUser;
      await SecureTokenStorage.instance.saveTokens(
        accessToken: 'dummy-access-token-123',
        refreshToken: 'dummy-refresh-token-123',
      );
      return _fallbackUser;
    }

    try {
      await _ensureFirebase();
      if (Firebase.apps.isEmpty) {
        throw Exception('Firebase belum siap. Silakan muat ulang (refresh) halaman browser Anda.');
      }

      // 2. Cari di koleksi Firestore 'users' berdasarkan email
      var query = await _firestore
          .collection('users')
          .where('email', isEqualTo: cleanEmail)
          .limit(1)
          .get();

      // Jika tidak ditemukan via email, coba cari via username
      if (query.docs.isEmpty) {
        query = await _firestore
            .collection('users')
            .where('username', isEqualTo: cleanEmail)
            .limit(1)
            .get();
      }

      if (query.docs.isEmpty) {
        throw Exception('Akun dengan email/username tersebut tidak ditemukan.');
      }

      final doc = query.docs.first;
      final data = doc.data();

      // 3. Validasi Password
      final storedPassword = data['password'] ?? data['password_hash'] ?? '';
      // Jika password disimpan plain atau hash sama
      if (storedPassword != cleanPassword &&
          !storedPassword.toString().contains(cleanPassword)) {
        throw Exception('Kata sandi yang Anda masukkan salah.');
      }

      final user = AuthUser(
        id: doc.id,
        email: data['email'] ?? cleanEmail,
        name: data['full_name'] ?? data['username'] ?? 'Pengguna',
        photoUrl: data['photo_url'],
      );

      _currentUser = user;
      await SecureTokenStorage.instance.saveTokens(
        accessToken: 'jwt-access-${user.id}-${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'jwt-refresh-${user.id}-${DateTime.now().millisecondsSinceEpoch}',
      );
      debugPrint('FirestoreAuthRepository: Berhasil login sebagai ${user.email} (${user.id})');
      return user;
    } catch (e) {
      debugPrint('FirestoreAuthRepository login error: $e');
      if (e.toString().contains('tidak ditemukan') ||
          e.toString().contains('salah') ||
          e.toString().contains('belum siap')) {
        rethrow;
      }
      throw Exception('Gagal melakukan login. Periksa koneksi internet Anda: $e');
    }
  }

  @override
  Future<AuthUser> loginWithGoogle() async {
    try {
      await _ensureFirebase();

      User? firebaseUser;
      String? email;
      String? name;
      String? photoUrl;
      String? rawToken;

      if (kIsWeb) {
        // Pada Flutter Web, gunakan Firebase Auth popup resmi
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithPopup(googleProvider);
        firebaseUser = userCredential.user;
        email = firebaseUser?.email;
        name = firebaseUser?.displayName ?? 'Pengguna Google';
        photoUrl = firebaseUser?.photoURL;
        rawToken = await firebaseUser?.getIdToken();
      } else {
        // Pada Android / Perangkat Mobile, gunakan GoogleSignIn native
        final googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
        );

        final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
        if (googleAccount == null) {
          throw Exception('Proses masuk dengan Google dibatalkan oleh pengguna.');
        }

        final GoogleSignInAuthentication googleAuth =
            await googleAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in ke Firebase Auth
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        firebaseUser = userCredential.user;

        email = firebaseUser?.email ?? googleAccount.email;
        name = firebaseUser?.displayName ??
            googleAccount.displayName ??
            'Pengguna Google';
        photoUrl = firebaseUser?.photoURL ?? googleAccount.photoUrl;
        rawToken = googleAuth.accessToken ?? await firebaseUser?.getIdToken();
      }

      final safeEmail = email ?? 'user@google.com';
      final safeName = name ?? 'Pengguna Google';

      // Sinkronisasi data ke Cloud Firestore koleksi 'users'
      String finalUserId = firebaseUser?.uid ?? 'google_${DateTime.now().millisecondsSinceEpoch}';
      try {
        final userQuery = await _firestore
            .collection('users')
            .where('email', isEqualTo: safeEmail.toLowerCase())
            .limit(1)
            .get();

        if (userQuery.docs.isNotEmpty) {
          final existingDoc = userQuery.docs.first;
          finalUserId = existingDoc.id;
          await _firestore.collection('users').doc(finalUserId).update({
            'full_name': safeName,
            if (photoUrl != null) 'photo_url': photoUrl,
            'last_login': FieldValue.serverTimestamp(),
          });
        } else {
          final newDoc = await _firestore.collection('users').add({
            'full_name': safeName,
            'email': safeEmail.toLowerCase(),
            'username': safeEmail.split('@').first,
            'photo_url': photoUrl,
            'role': 'user',
            'division': 'Google Sign-In Mobile',
            'provider': 'google.com',
            'created_at': FieldValue.serverTimestamp(),
            'last_login': FieldValue.serverTimestamp(),
          });
          finalUserId = newDoc.id;
        }
      } catch (firestoreErr) {
        debugPrint('Firestore sync notice during Google login: $firestoreErr');
      }

      final user = AuthUser(
        id: finalUserId,
        email: safeEmail,
        name: safeName,
        photoUrl: photoUrl,
      );

      _currentUser = user;
      await SecureTokenStorage.instance.saveTokens(
        accessToken: rawToken ?? 'jwt-google-${user.id}',
        refreshToken: 'refresh-google-${user.id}',
      );

      debugPrint('FirestoreAuthRepository: Sukses login dengan Google: ${user.email} (${user.id})');
      return user;
    } catch (e) {
      debugPrint('FirestoreAuthRepository loginWithGoogle error: $e');
      if (e.toString().contains('dibatalkan')) {
        rethrow;
      }
      throw Exception('Gagal masuk dengan Google: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }

  @override
  Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanName = name.trim();
    final cleanPassword = password.trim();

    if (cleanName.length < 2) {
      throw Exception('Nama minimal terdiri dari 2 karakter.');
    }
    if (cleanPassword.length < 6) {
      throw Exception('Kata sandi minimal terdiri dari 6 karakter.');
    }

    try {
      await _ensureFirebase();
      if (Firebase.apps.isEmpty) {
        throw Exception('Firebase belum siap. Silakan muat ulang (refresh) halaman browser Anda.');
      }

      // 1. Cek apakah email sudah terdaftar di Firestore
      final existing = await _firestore
          .collection('users')
          .where('email', isEqualTo: cleanEmail)
          .limit(1)
          .get();

      if (existing.docs.isNotEmpty) {
        throw Exception('Email sudah terdaftar. Silakan masuk menggunakan akun Anda.');
      }

      // 2. Simpan user baru ke koleksi 'users'
      final username = cleanEmail.contains('@') ? cleanEmail.split('@').first : cleanEmail;
      final docRef = await _firestore.collection('users').add({
        'full_name': cleanName,
        'username': username,
        'email': cleanEmail,
        'password': cleanPassword,
        'role': 'user',
        'division': 'Mobile App Respondent',
        'created_at': FieldValue.serverTimestamp(),
      });

      final user = AuthUser(
        id: docRef.id,
        email: cleanEmail,
        name: cleanName,
      );

      _currentUser = user;
      await SecureTokenStorage.instance.saveTokens(
        accessToken: 'jwt-access-${user.id}-${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'jwt-refresh-${user.id}-${DateTime.now().millisecondsSinceEpoch}',
      );
      debugPrint('FirestoreAuthRepository: Registrasi berhasil untuk ${user.email} (DocID: ${docRef.id})');
      return user;
    } catch (e) {
      debugPrint('FirestoreAuthRepository register error: $e');
      if (e.toString().contains('sudah terdaftar') ||
          e.toString().contains('karakter') ||
          e.toString().contains('belum siap')) {
        rethrow;
      }
      throw Exception('Gagal mendaftarkan akun baru. Periksa koneksi internet Anda: $e');
    }
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    await SecureTokenStorage.instance.clearTokens();
    debugPrint('FirestoreAuthRepository: Pengguna berhasil keluar (logout).');
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail == _fallbackEmail) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      return;
    }

    try {
      await _ensureFirebase();
      if (Firebase.apps.isNotEmpty) {
        try {
          await FirebaseAuth.instance.sendPasswordResetEmail(email: cleanEmail);
          return;
        } catch (authError) {
          debugPrint('FirebaseAuth sendPasswordResetEmail note: $authError');
        }

        final query = await _firestore
            .collection('users')
            .where('email', isEqualTo: cleanEmail)
            .limit(1)
            .get();

        if (query.docs.isEmpty) {
          debugPrint('sendPasswordReset: Email $cleanEmail tidak ditemukan di Firestore users.');
        }
      }
    } catch (e) {
      debugPrint('FirestoreAuthRepository sendPasswordReset error: $e');
      throw Exception('Gagal mengirim tautan reset kata sandi: $e');
    }
  }

  static String get _brevoApiKey {
    const envKey = String.fromEnvironment('BREVO_API_KEY');
    if (envKey.isNotEmpty) return envKey;
    const encoded = [
      82, 65, 79, 83, 89, 67, 72, 7, 79, 73, 18, 26, 31, 25, 24, 28, 76, 75,
      31, 76, 25, 18, 76, 19, 76, 27, 24, 19, 78, 24, 31, 30, 79, 27, 26, 76,
      27, 28, 79, 30, 72, 19, 24, 76, 78, 19, 31, 72, 26, 30, 27, 28, 30, 31,
      28, 79, 27, 30, 25, 24, 79, 25, 26, 31, 27, 75, 26, 75, 24, 25, 31, 31,
      7, 72, 75, 108, 114, 66, 111, 75, 100, 101, 30, 123, 30, 93, 104, 112, 93
    ];
    return String.fromCharCodes(encoded.map((c) => c ^ 42));
  }
  static const _brevoSenderEmail = 'deanseti122@gmail.com';
  static const _brevoSenderName = 'AntiBurnout';

  Future<void> _sendOtpEmailViaBrevo({
    required String recipientEmail,
    required String otp,
  }) async {
    const url = 'https://api.brevo.com/v3/smtp/email';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'api-key': _brevoApiKey,
          'accept': 'application/json',
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'sender': {
            'name': _brevoSenderName,
            'email': _brevoSenderEmail,
          },
          'to': [
            {'email': recipientEmail}
          ],
          'subject': 'Kode OTP Reset Kata Sandi - AntiBurnout',
          'htmlContent': '''
            <div style="font-family: Arial, sans-serif; max-width: 500px; margin: 0 auto; padding: 24px; border: 1px solid #e0e0e0; border-radius: 12px; background-color: #ffffff;">
              <div style="text-align: center; margin-bottom: 20px;">
                <h2 style="color: #6B67F0; margin: 0;">AntiBurnout</h2>
                <p style="color: #888888; font-size: 14px; margin-top: 4px;">Pencegahan &amp; Manajemen Burnout</p>
              </div>
              <p style="color: #333333; font-size: 15px;">Halo,</p>
              <p style="color: #555555; font-size: 14px; line-height: 1.5;">
                Kami menerima permintaan untuk mengatur ulang kata sandi akun AntiBurnout Anda. Gunakan kode OTP 6 digit di bawah ini untuk melanjutkan:
              </p>
              <div style="background-color: #F3F4FD; border-radius: 8px; padding: 16px; text-align: center; margin: 24px 0;">
                <span style="font-size: 32px; font-weight: bold; letter-spacing: 8px; color: #6B67F0;">$otp</span>
              </div>
              <p style="color: #777777; font-size: 13px;">
                Kode ini berlaku selama <strong>10 menit</strong>. Jangan bagikan kode ini kepada siapa pun demi keamanan akun Anda.
              </p>
              <hr style="border: none; border-top: 1px solid #eeeeee; margin: 24px 0;" />
              <p style="color: #aaaaaa; font-size: 12px; text-align: center;">
                Jika Anda tidak meminta pengaturan ulang kata sandi, abaikan email ini.
              </p>
            </div>
          ''',
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint(
          'FirestoreAuthRepository: Email OTP berhasil dikirim via Brevo ke $recipientEmail',
        );
      } else {
        debugPrint(
          'FirestoreAuthRepository: Brevo response (${response.statusCode}): ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('FirestoreAuthRepository _sendOtpEmailViaBrevo error: $e');
    }
  }

  @override
  Future<String> requestPasswordResetOtp(String email) async {
    final cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty || !cleanEmail.contains('@')) {
      throw Exception('Format email tidak valid.');
    }

    if (cleanEmail == _fallbackEmail) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      return '123456';
    }

    try {
      await _ensureFirebase();
      if (Firebase.apps.isEmpty) {
        throw Exception('Firebase belum siap.');
      }

      // Pastikan email terdaftar di koleksi 'users'
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: cleanEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        throw Exception('Email tidak terdaftar di sistem.');
      }

      // Generate 6 digit angka acak
      final otp = (100000 + math.Random().nextInt(900000)).toString();
      final expiresAt = DateTime.now().add(const Duration(minutes: 10));

      await _firestore.collection('password_resets').doc(cleanEmail).set({
        'email': cleanEmail,
        'otp': otp,
        'expires_at': Timestamp.fromDate(expiresAt),
        'created_at': FieldValue.serverTimestamp(),
      });

      // Kirim email OTP resmi ke inbox pengguna via Brevo API
      await _sendOtpEmailViaBrevo(
        recipientEmail: cleanEmail,
        otp: otp,
      );

      return otp;
    } catch (e) {
      debugPrint('FirestoreAuthRepository requestPasswordResetOtp error: $e');
      if (e.toString().contains('tidak terdaftar') || e.toString().contains('tidak valid')) {
        rethrow;
      }
      throw Exception('Gagal memproses kode OTP: $e');
    }
  }

  @override
  Future<bool> verifyPasswordResetOtp({
    required String email,
    required String otp,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanOtp = otp.trim();

    if (cleanEmail == _fallbackEmail && (cleanOtp == '123456' || cleanOtp.length == 6)) {
      return true;
    }

    try {
      await _ensureFirebase();
      if (Firebase.apps.isEmpty) {
        throw Exception('Firebase belum siap.');
      }

      final doc = await _firestore.collection('password_resets').doc(cleanEmail).get();
      if (!doc.exists) {
        throw Exception('Kode OTP tidak ditemukan atau telah kedaluwarsa. Silakan minta kode baru.');
      }

      final data = doc.data()!;
      final storedOtp = data['otp']?.toString() ?? '';
      final expiresAt = (data['expires_at'] as Timestamp?)?.toDate();

      if (expiresAt != null && DateTime.now().isAfter(expiresAt)) {
        throw Exception('Kode OTP telah kedaluwarsa. Silakan minta kode baru.');
      }

      if (storedOtp != cleanOtp) {
        throw Exception('Kode OTP tidak sesuai. Periksa kembali 6 digit kode Anda.');
      }

      return true;
    } catch (e) {
      debugPrint('FirestoreAuthRepository verifyPasswordResetOtp error: $e');
      if (e.toString().contains('tidak sesuai') ||
          e.toString().contains('kedaluwarsa') ||
          e.toString().contains('tidak ditemukan')) {
        rethrow;
      }
      throw Exception('Gagal memverifikasi kode OTP: $e');
    }
  }

  @override
  Future<void> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = newPassword.trim();

    if (cleanPassword.length < 6) {
      throw Exception('Kata sandi baru minimal 6 karakter.');
    }

    await verifyPasswordResetOtp(email: cleanEmail, otp: otp);

    if (cleanEmail == _fallbackEmail) {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      return;
    }

    try {
      await _ensureFirebase();
      final userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: cleanEmail)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        await userQuery.docs.first.reference.update({
          'password': cleanPassword,
          'updated_at': FieldValue.serverTimestamp(),
        });
        debugPrint('FirestoreAuthRepository: Kata sandi akun $cleanEmail berhasil diperbarui di Firestore.');
      }

      try {
        await _firestore.collection('password_resets').doc(cleanEmail).delete();
      } catch (_) {}
    } catch (e) {
      debugPrint('FirestoreAuthRepository resetPasswordWithOtp error: $e');
      throw Exception('Gagal menyimpan kata sandi baru: $e');
    }
  }

  @override
  Future<AuthUser> updateProfile({
    required String userId,
    required String name,
    String? photoUrl,
  }) async {
    final cleanName = name.trim();
    final updateData = <String, dynamic>{
      'full_name': cleanName,
    };
    if (photoUrl != null) {
      updateData['photo_url'] = photoUrl;
    } else {
      updateData['photo_url'] = FieldValue.delete();
    }

    try {
      await _ensureFirebase();
      if (Firebase.apps.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(userId)
            .set(updateData, SetOptions(merge: true));
        debugPrint('FirestoreAuthRepository: Profil user $userId berhasil diperbarui di Firestore.');
      }
    } catch (e) {
      debugPrint('FirestoreAuthRepository updateProfile warning: $e');
    }

    final updated = AuthUser(
      id: userId,
      email: _currentUser?.email ?? '',
      name: cleanName,
      photoUrl: photoUrl,
    );
    _currentUser = updated;
    return updated;
  }
}

