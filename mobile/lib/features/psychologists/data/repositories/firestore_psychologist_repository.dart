import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/psychologist.dart';
import '../../domain/repositories/psychologist_repository.dart';
import '../../domain/utils/geo_calculator.dart';
import '../fixtures/psychologist_fixtures.dart';

class FirestorePsychologistRepository implements PsychologistRepository {
  FirestorePsychologistRepository({FirebaseFirestore? firestore})
      : _customFirestore = firestore;

  final FirebaseFirestore? _customFirestore;
  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Psychologist>> getPsychologists({
    String? city,
    double? userLatitude,
    double? userLongitude,
    String? query,
  }) async {
    List<Psychologist> results = [];

    try {
      if (Firebase.apps.isNotEmpty || _customFirestore != null) {
        final snapshot = await _firestore.collection('psychologists').get();
        if (snapshot.docs.isNotEmpty) {
          results = snapshot.docs
              .map((doc) => Psychologist.fromJson(doc.data(), id: doc.id))
              .toList();
        }
      }
    } catch (e) {
      debugPrint('FirestorePsychologistRepository notice: using fixtures fallback ($e)');
    }

    if (results.isEmpty) {
      results = List.of(kDefaultPsychologists);
    }

    // Filter berdasarkan kota jika ada
    if (city != null && city.isNotEmpty && city.toLowerCase() != 'semua') {
      final cleanCity = city.trim().toLowerCase();
      results = results
          .where((p) => p.city.toLowerCase() == cleanCity)
          .toList();
    }

    // Filter pencarian teks jika ada
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      results = results.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.clinicOrHospital.toLowerCase().contains(q) ||
            p.address.toLowerCase().contains(q) ||
            p.specialties.any((s) => s.toLowerCase().contains(q));
      }).toList();
    }

    // Hitung jarak ke user jika koordinat user ada
    if (userLatitude != null && userLongitude != null) {
      results = results.map((item) {
        final dist = GeoCalculator.distanceBetweenKm(
          startLatitude: userLatitude,
          startLongitude: userLongitude,
          endLatitude: item.latitude,
          endLongitude: item.longitude,
        );
        return item.copyWith(distanceKm: dist);
      }).toList();

      // Urutkan dari yang terdekat
      results.sort((a, b) {
        final distA = a.distanceKm ?? double.infinity;
        final distB = b.distanceKm ?? double.infinity;
        return distA.compareTo(distB);
      });
    }

    return results;
  }
}
