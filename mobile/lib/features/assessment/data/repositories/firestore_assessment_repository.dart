import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/network/api_client.dart';
import '../../../../firebase_options.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../domain/entities/assessment.dart';
import '../../domain/repositories/assessment_repository.dart';

class FirestoreAssessmentRepository implements AssessmentRepository {
  FirestoreAssessmentRepository({
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

  // Cache lokal dalam sesi aplikasi
  final Map<String, Assessment> _memoryCache = {};

  @override
  Future<Assessment?> getById(String id) async {
    if (_memoryCache.containsKey(id)) {
      return _memoryCache[id];
    }

    try {
      await _ensureFirebase();
      final doc = await _firestore.collection('assessments').doc(id).get();
      if (!doc.exists || doc.data() == null) {
        return null;
      }

      final data = doc.data()!;
      final assessment = _mapDocToAssessment(doc.id, data);
      _memoryCache[id] = assessment;
      return assessment;
    } catch (e) {
      debugPrint('FirestoreAssessmentRepository getById error: $e');
      return null;
    }
  }

  @override
  Future<Assessment> submit(Map<String, String> answers) async {
    final user = currentUserProvider?.call();
    final userId = user?.id ?? 'guest-user';
    final userName = user?.name ?? 'Pengguna Mobile';

    // 1. Ekstrak jawaban dari 7 pertanyaan survei
    final rawSleepQuality = answers['sleep_quality'] ?? 'Cukup';
    final screenHours = double.tryParse(answers['screen_hours'] ?? '6.0') ?? 6.0;
    final sleepHours = double.tryParse(answers['sleep_hours'] ?? '7.0') ?? 7.0;
    final coffeeCups = int.tryParse(answers['coffee_cups'] ?? '2') ?? 2;
    final rawActivityLoad = answers['activity_load'] ?? 'Sedang';
    final meditationMinutes = double.tryParse(answers['meditation_minutes'] ?? '10') ?? 10.0;
    final moodRating = double.tryParse(answers['mood_rating'] ?? '65') ?? 65.0;

    // 2. Normalisasi format data
    final mappedSleepQuality = switch (rawSleepQuality) {
      'Buruk' => 'Poor',
      'Cukup' => 'Average',
      'Baik' => 'Good',
      'Sangat baik' => 'Excellent',
      _ => 'Average',
    };

    final mappedStressLevel = switch (rawActivityLoad) {
      'Berat' => 'High',
      'Sedang' => 'Moderate',
      _ => 'Low',
    };

    // 3. Siapkan payload API
    final payload = {
      'user_id': userId,
      'full_name': userName,
      'sleep_quality': mappedSleepQuality,
      'sleep_hours': sleepHours,
      'screen_time_hours': screenHours,
      'coffee_cups_per_day': coffeeCups,
      'stress_level': mappedStressLevel,
      'meditation_minutes': meditationMinutes,
      'mood_score': moodRating,
      'work_hours_per_week': 40.0,
      'age': 25.0,
      'gender': 'Male',
      'occupation': 'Mobile User',
    };

    // 4. Minta inferensi ke API Machine Learning (dengan fallback lokal)
    double burnoutScore = 50.0;
    String burnoutRisk = 'Moderate';
    String recommendation = 'Jaga pola istirahat dan lakukan relaksasi secara rutin.';

    final apiResponse = await ApiClient.instance.predictBurnout(payload);
    if (apiResponse != null && apiResponse['evaluation'] != null) {
      final eval = apiResponse['evaluation'] as Map<String, dynamic>;
      burnoutScore = (eval['burnout_score'] as num?)?.toDouble() ?? 50.0;
      burnoutRisk = eval['burnout_risk']?.toString() ?? 'Moderate';
      recommendation = eval['ai_wellness_recommendation']?.toString() ?? recommendation;
    } else {
      // Perhitungan Heuristic Cerdas AntiBurnout (Fallback)
      double calc = 45.0;
      if (mappedStressLevel == 'High') calc += 25.0;
      else if (mappedStressLevel == 'Moderate') calc += 10.0;
      else calc -= 15.0;

      if (sleepHours < 6.0) calc += 15.0;
      else if (sleepHours >= 7.5) calc -= 10.0;

      if (coffeeCups >= 4) calc += 8.0;
      if (screenHours >= 9.0) calc += 7.0;
      if (meditationMinutes >= 15.0) calc -= 8.0;

      burnoutScore = calc.clamp(5.0, 95.0);
      if (burnoutScore >= 70.0) {
        burnoutRisk = 'High';
        recommendation = 'Tingkat kelelahan kerja tinggi terdeteksi. Segera luangkan waktu untuk jeda dan pemulihan fisik & mental.';
      } else if (burnoutScore >= 40.0) {
        burnoutRisk = 'Moderate';
        recommendation = 'Mulai terindikasi kelelahan kerja. Disarankan untuk mengambil jeda berkala dan menjaga batasan kerja sehat.';
      } else {
        burnoutRisk = 'Low';
        recommendation = 'Kondisi kesehatan mental dan ritme kerjamu sangat baik. Pertahankan pola hidup sehat ini!';
      }
    }

    final riskLevel = switch (burnoutRisk.toLowerCase()) {
      'high' || 'tinggi' => RiskLevel.tinggi,
      'low' || 'rendah' => RiskLevel.rendah,
      _ => RiskLevel.sedang,
    };

    // 5. Bangun faktor penjelasan dinamis
    final factors = <AssessmentFactor>[];
    if (sleepHours < 6.5) {
      factors.add(AssessmentFactor(label: 'Durasi tidur kurang optimal ($sleepHours jam)'));
    }
    if (rawActivityLoad == 'Berat') {
      factors.add(const AssessmentFactor(label: 'Beban aktivitas dan stres harian tinggi'));
    }
    if (screenHours >= 8.0) {
      factors.add(AssessmentFactor(label: 'Paparan layar intensif ($screenHours jam)'));
    }
    if (coffeeCups >= 4) {
      factors.add(AssessmentFactor(label: 'Konsumsi kafein cukup tinggi ($coffeeCups cangkir)'));
    }
    if (meditationMinutes >= 15.0) {
      factors.add(const AssessmentFactor(label: 'Praktik relaksasi / meditasi sangat baik'));
    }
    if (factors.isEmpty) {
      factors.add(const AssessmentFactor(label: 'Aktivitas dan pola istirahat seimbang'));
    }

    // 6. Ringkasan jawaban survei
    final answerSummary = [
      AssessmentAnswerSummary(label: 'Kualitas tidur', value: rawSleepQuality),
      AssessmentAnswerSummary(label: 'Waktu layar', value: '$screenHours jam'),
      AssessmentAnswerSummary(label: 'Durasi tidur', value: '$sleepHours jam'),
      AssessmentAnswerSummary(label: 'Konsumsi kopi', value: '$coffeeCups cangkir'),
      AssessmentAnswerSummary(label: 'Beban aktivitas', value: rawActivityLoad),
      AssessmentAnswerSummary(label: 'Meditasi', value: '$meditationMinutes menit'),
      AssessmentAnswerSummary(label: 'Suasana hati', value: '${moodRating.toInt()}/100'),
    ];

    final now = DateTime.now();

    // 7. Simpan dokumen ke Cloud Firestore koleksi 'assessments'
    String savedId = 'ASM-${now.millisecondsSinceEpoch}';
    try {
      await _ensureFirebase();
      final docRef = await _firestore.collection('assessments').add({
        'user_id': userId,
        'person_id': 'PID-MOB-${now.millisecondsSinceEpoch}',
        'full_name': userName,
        'sleep_quality': mappedSleepQuality,
        'sleep_hours': sleepHours,
        'screen_time_hours': screenHours,
        'coffee_cups_per_day': coffeeCups,
        'stress_level': mappedStressLevel,
        'meditation_minutes': meditationMinutes,
        'mood_score': moodRating,
        'burnout_score': burnoutScore,
        'burnout_risk': burnoutRisk,
        'mental_health_status': burnoutRisk == 'High' ? 'Critical' : (burnoutRisk == 'Low' ? 'Healthy' : 'Needs Attention'),
        'ai_wellness_recommendation': recommendation,
        'created_at': FieldValue.serverTimestamp(),
      });
      savedId = docRef.id;
      debugPrint('FirestoreAssessmentRepository: Berhasil menyimpan asesmen ke Firestore (DocID: $savedId)');
    } catch (e) {
      debugPrint('FirestoreAssessmentRepository save error (fallback to local id): $e');
    }

    final assessment = Assessment(
      id: savedId,
      riskLevel: riskLevel,
      takenAt: now,
      isExample: false,
      modelFactors: factors,
      answerSummary: answerSummary,
    );

    _memoryCache[savedId] = assessment;
    return assessment;
  }

  Assessment _mapDocToAssessment(String docId, Map<String, dynamic> data) {
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

    final sleepHours = (data['sleep_hours'] as num?)?.toDouble() ?? 7.0;
    final screenHours = (data['screen_time_hours'] as num?)?.toDouble() ?? 6.0;
    final coffeeCups = (data['coffee_cups_per_day'] as num?)?.toInt() ?? 2;
    final stressLevel = data['stress_level']?.toString() ?? 'Moderate';

    final factors = <AssessmentFactor>[
      if (stressLevel == 'High') const AssessmentFactor(label: 'Tingkat stres tergolong tinggi'),
      if (sleepHours < 6.5) AssessmentFactor(label: 'Durasi tidur kurang ($sleepHours jam)'),
      if (screenHours >= 8.0) AssessmentFactor(label: 'Waktu layar cukup tinggi ($screenHours jam)'),
      if (coffeeCups >= 4) AssessmentFactor(label: 'Konsumsi kafein tinggi ($coffeeCups cangkir)'),
    ];
    if (factors.isEmpty) {
      factors.add(const AssessmentFactor(label: 'Pola istirahat dan beban kerja terkendali'));
    }

    final answerSummary = [
      AssessmentAnswerSummary(label: 'Kualitas tidur', value: data['sleep_quality']?.toString() ?? 'Cukup'),
      AssessmentAnswerSummary(label: 'Durasi tidur', value: '$sleepHours jam'),
      AssessmentAnswerSummary(label: 'Waktu layar', value: '$screenHours jam'),
      AssessmentAnswerSummary(label: 'Konsumsi kopi', value: '$coffeeCups cangkir'),
      AssessmentAnswerSummary(label: 'Tingkat stres', value: stressLevel),
    ];

    return Assessment(
      id: docId,
      riskLevel: riskLevel,
      takenAt: takenAt,
      isExample: false,
      modelFactors: factors,
      answerSummary: answerSummary,
    );
  }
}

