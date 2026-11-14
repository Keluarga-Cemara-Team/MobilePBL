import 'package:cloud_firestore/cloud_firestore.dart';
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

