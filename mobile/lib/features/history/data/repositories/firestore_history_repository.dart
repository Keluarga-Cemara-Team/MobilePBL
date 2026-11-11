import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../../../firebase_options.dart';
import '../../../assessment/domain/entities/risk_level.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../presentation/controllers/history_repository.dart';
import '../../presentation/widgets/assessment_history_item.dart';

class FirestoreHistoryRepository implements HistoryRepository {
  FirestoreHistoryRepository({
    FirebaseFirestore? firestore,
    this.currentUserProvider,
  }) : _customFirestore = firestore;

  final FirebaseFirestore? _customFirestore;
  FirebaseFirestore get _firestore => _customFirestore ?? FirebaseFirestore.instance;
  final AuthUser? Function()? currentUserProvider;

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

  @override
  Future<List<AssessmentHistoryItem>> fetchHistory() async {
    final user = currentUserProvider?.call();
    final userId = user?.id;

    final results = <AssessmentHistoryItem>[];

    try {
      await _ensureFirebase();
      Query<Map<String, dynamic>> query = _firestore.collection('assessments');
      if (userId != null && userId.isNotEmpty) {
        query = query.where('user_id', isEqualTo: userId);
      }

      final snapshot = await query.limit(50).get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final rawRisk = data['burnout_risk']?.toString().toLowerCase() ?? 'moderate';
        final riskLevel = switch (rawRisk) {
          'high' || 'tinggi' => RiskLevel.tinggi,
          'low' || 'rendah' => RiskLevel.rendah,
          _ => RiskLevel.sedang,
        };

        DateTime takenAt = DateTime.now();
        final rawDate = data['created_at'];
        if (rawDate is Timestamp) {
          takenAt = rawDate.toDate();
        } else if (rawDate is String) {
          takenAt = DateTime.tryParse(rawDate) ?? DateTime.now();
        }

        results.add(
          AssessmentHistoryItem(
            id: doc.id,
            riskLevel: riskLevel,
            takenAt: takenAt,
          ),
        );
      }

      results.sort((a, b) => b.takenAt.compareTo(a.takenAt));
      debugPrint('FirestoreHistoryRepository: Berhasil memuat ${results.length} riwayat dari Firestore.');
      return results;
    } catch (e) {
      debugPrint('FirestoreHistoryRepository fetchHistory error: $e. Fallback ke demo data.');
      // Fallback ke data demo jika offline atau koneksi gagal
      return createDemoAssessmentHistory(now: DateTime.now());
    }
  }
}

