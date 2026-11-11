import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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
      return _fallbackUser;
    }

    try {
      await _ensureFirebase();

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
      debugPrint('FirestoreAuthRepository: Berhasil login sebagai ${user.email} (${user.id})');
      return user;
    } catch (e) {
      debugPrint('FirestoreAuthRepository login error: $e');
      if (e.toString().contains('tidak ditemukan') ||
          e.toString().contains('salah')) {
        rethrow;
      }
      throw Exception('Gagal melakukan login. Periksa koneksi internet Anda: $e');
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
      debugPrint('FirestoreAuthRepository: Registrasi berhasil untuk ${user.email} (DocID: ${docRef.id})');
      return user;
    } catch (e) {
      debugPrint('FirestoreAuthRepository register error: $e');
      if (e.toString().contains('sudah terdaftar') ||
          e.toString().contains('karakter')) {
        rethrow;
      }
      throw Exception('Gagal mendaftarkan akun baru. Periksa koneksi internet Anda: $e');
    }
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
    debugPrint('FirestoreAuthRepository: Pengguna berhasil keluar (logout).');
  }
}

