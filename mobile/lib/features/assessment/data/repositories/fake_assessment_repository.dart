import '../../domain/entities/assessment.dart';
import '../../domain/repositories/assessment_repository.dart';

/// Read-only access to the existing sample history until a service is supplied.
/// This repository does not generate predictions or explanations.
class FakeAssessmentRepository implements AssessmentRepository {
  FakeAssessmentRepository(Iterable<Assessment> assessments)
    : _assessments = {for (final item in assessments) item.id: item};

  final Map<String, Assessment> _assessments;

  @override
  Future<Assessment?> getById(String id) async => _assessments[id];

  @override
  Future<Assessment> submit(Map<String, String> answers) async {
    final now = DateTime.now();
    final newId = 'ASM-${now.millisecondsSinceEpoch}';
    final rawActivity = answers['activity_load']?.toLowerCase() ?? 'sedang';
    final riskLevel = switch (rawActivity) {
      'berat' => RiskLevel.tinggi,
      'ringan' => RiskLevel.rendah,
      _ => RiskLevel.sedang,
    };

    final assessment = Assessment(
      id: newId,
      riskLevel: riskLevel,
      takenAt: now,
      isExample: false,
      modelFactors: const [
        AssessmentFactor(label: 'Evaluasi kelelahan kerja & ritme harian'),
        AssessmentFactor(label: 'Analisis waktu istirahat dan stres'),
      ],
      answerSummary: [
        for (final entry in answers.entries)
          AssessmentAnswerSummary(label: entry.key, value: entry.value),
      ],
    );

    _assessments[newId] = assessment;
    return assessment;
  }
}
