import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../assessment/di/assessment_providers.dart';
import '../../../assessment/domain/entities/assessment.dart';
import '../../../history/presentation/controllers/history_controller.dart';
import '../../../history/presentation/controllers/history_repository.dart';

final dashboardAssessmentsProvider = Provider<List<Assessment>>((ref) {
  final sessionAssessments = ref.watch(assessmentSessionCacheProvider);
  final historyState = ref.watch(historyControllerProvider);
  final historyItems = historyState.items;

  // 1. Kumpulkan seluruh asesmen riil (dari riwayat Firestore & cache sesi)
  final realMap = <String, Assessment>{};

  // Dari riwayat Firestore pengguna
  for (final item in historyItems) {
    final isDemo = item.id.startsWith('demo-') ||
        item.id == '1' ||
        item.id == '2' ||
        item.id == '3' ||
        item.id == '4';
    realMap[item.id] = Assessment(
      id: item.id,
      riskLevel: item.riskLevel,
      takenAt: item.takenAt,
      isExample: isDemo,
    );
  }

  // Dari sesi aktif (menimpa dengan data lengkap modelFactors & answerSummary)
  for (final sessionItem in sessionAssessments.values) {
    realMap[sessionItem.id] = sessionItem;
  }

  // 2. Pisahkan data riil pengguna
  final realAssessments = realMap.values.where((a) => !a.isExample).toList()
    ..sort((a, b) => b.takenAt.compareTo(a.takenAt));

  // 3. Jika pengguna sudah memiliki asesmen riil, utamakan data riil tersebut
  if (realAssessments.isNotEmpty) {
    return List.unmodifiable(realAssessments);
  }

  // 4. Jika belum ada asesmen riil, gunakan fixture contoh untuk pratinjau statistik
  final fixtureItems = {
    for (final item in ref.watch(assessmentFixtureProvider))
      item.id: Assessment(
        id: item.id,
        riskLevel: item.riskLevel,
        takenAt: item.takenAt,
        isExample: true,
      ),
    ...realMap,
  }.values.toList()..sort((a, b) => b.takenAt.compareTo(a.takenAt));

  return List.unmodifiable(fixtureItems);
});

final latestAssessmentProvider = Provider<Assessment?>((ref) {
  final assessments = ref.watch(dashboardAssessmentsProvider);
  final real = assessments.where((a) => !a.isExample);
  if (real.isNotEmpty) {
    return real.first;
  }
  return assessments.isEmpty ? null : assessments.first;
});
