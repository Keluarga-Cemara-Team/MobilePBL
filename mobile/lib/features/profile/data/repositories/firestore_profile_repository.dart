import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../../../firebase_options.dart';
import '../../domain/entities/personalization.dart';
import '../../domain/repositories/profile_repository.dart';

class FirestoreProfileRepository implements ProfileRepository {
  FirestoreProfileRepository({FirebaseFirestore? firestore})
      : _customFirestore = firestore;

  final FirebaseFirestore? _customFirestore;
  FirebaseFirestore get _firestore => _customFirestore ?? FirebaseFirestore.instance;

  final Map<String, Personalization> _memoryCache = {};

  Future<void> _ensureFirebase() async {
    if (Firebase.apps.isEmpty) {
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } catch (e) {
        debugPrint('Auto-init Firebase warning in FirestoreProfileRepository: $e');
      }
    }
  }

  @override
  Future<Personalization?> getPersonalization(String userId) async {
    if (_memoryCache.containsKey(userId)) {
      return _memoryCache[userId];
    }

    try {
      await _ensureFirebase();
      if (Firebase.apps.isNotEmpty) {
        // 1. Cek di koleksi 'personalizations'
        final doc = await _firestore.collection('personalizations').doc(userId).get();
        if (doc.exists && doc.data() != null) {
          final data = Personalization.fromJson(doc.data()!);
          _memoryCache[userId] = data;
          return data;
        }

        // 2. Fallback cek di dokumen 'users'
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists && userDoc.data() != null) {
          final userData = userDoc.data()!;
          if (userData['personalization'] is Map<String, dynamic>) {
            final data = Personalization.fromJson(
              userData['personalization'] as Map<String, dynamic>,
            );
            _memoryCache[userId] = data;
            return data;
          }
        }
      }
    } catch (e) {
      debugPrint('FirestoreProfileRepository getPersonalization error: $e');
    }

    return _memoryCache[userId];
  }

  @override
  Future<void> savePersonalization({
    required String userId,
    required Personalization personalization,
  }) async {
    _memoryCache[userId] = personalization;

    try {
      await _ensureFirebase();
      if (Firebase.apps.isNotEmpty) {
        final data = personalization.toJson();
        data['updated_at'] = FieldValue.serverTimestamp();

        // 1. Simpan di koleksi personalizations
        await _firestore.collection('personalizations').doc(userId).set(
          data,
          SetOptions(merge: true),
        );

        // 2. Simpan juga di sub-field user document agar tersinkronisasi
        await _firestore.collection('users').doc(userId).set(
          {'personalization': personalization.toJson()},
          SetOptions(merge: true),
        );

        debugPrint('FirestoreProfileRepository: Personalisasi tersimpan ke Firestore untuk user $userId');
      }
    } catch (e) {
      debugPrint('FirestoreProfileRepository savePersonalization error (fallback memory): $e');
    }
  }
}

