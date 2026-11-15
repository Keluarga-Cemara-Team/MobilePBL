import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/assessment_colors.dart';
import '../../../../shared/widgets/app_blob_background.dart';
import '../../../assessment/di/assessment_providers.dart';
import '../../../assessment/domain/entities/risk_level.dart';
import '../widgets/encouragement_card.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/recommendation_header.dart';

class RecommendationPage extends ConsumerWidget {
  const RecommendationPage({
    super.key,
    required this.assessmentId,
    this.onBack,
  });

  final String assessmentId;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assessment = ref.watch(assessmentByIdProvider(assessmentId));
    return Scaffold(
      backgroundColor: AppColors.of(context).background,
      body: AppBlobBackground(
        refreshKey: assessmentId,
        child: SafeArea(
          child: SingleChildScrollView(
            key: PageStorageKey('recommendation-scroll-$assessmentId'),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RecommendationHeader(
                  onBack: onBack ?? () => Navigator.of(context).maybePop(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.ui(AppSpacing.lg),
                    0,
                    context.ui(AppSpacing.lg),
                    context.ui(AppSpacing.lg),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: context.ui(AppSpacing.md)),
                      assessment.when(
                        loading: () => Padding(
                          padding: EdgeInsets.all(context.ui(AppSpacing.xl)),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        error: (error, stackTrace) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Asesmen belum dapat dimuat.',
                              style: AppTextStyles.subtitle(context)
                                  .copyWith(fontSize: context.ui(14)),
                            ),
                            TextButton(
                              onPressed: () => ref.invalidate(
                                assessmentByIdProvider(assessmentId),
                              ),
                              style: TextButton.styleFrom(
                                textStyle: TextStyle(fontSize: context.ui(14)),
                                padding: EdgeInsets.all(context.ui(12)),
                              ),
                              child: const Text('Coba lagi'),
                            ),
                          ],
                        ),
                        data: (item) => item == null
                            ? Text(
                                'Hasil asesmen tidak ditemukan. Buka rekomendasi dari '
                                'hasil asesmen yang tersedia.',
                                style: AppTextStyles.subtitle(context)
                                    .copyWith(fontSize: context.ui(14)),
                              )
                            : _GeneralRecommendations(
                                isHighRisk: item.riskLevel == RiskLevel.tinggi,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GeneralRecommendations extends StatelessWidget {
  const _GeneralRecommendations({this.isHighRisk = false});

  final bool isHighRisk;

  static const _items = [
    (
      icon: Icons.bed_outlined,
      background: AssessmentColors.sleepTint,
      title: 'Perbaiki Pola Tidur',
      body: 'Usahakan tidur 7–8 jam per hari dengan jadwal yang konsisten.',
    ),
    (
      icon: Icons.monitor_heart_outlined,
      background: AssessmentColors.activityTint,
      title: 'Kelola Aktivitas',
      body: 'Buat prioritas dan atur waktu istirahat di sela pekerjaan.',
    ),
    (
      icon: Icons.self_improvement_outlined,
      background: AssessmentColors.relaxationTint,
      title: 'Latih Relaksasi',
      body:
          'Coba teknik pernapasan, meditasi, atau mindfulness selama '
          '5–10 menit setiap hari.',
    ),
    (
      icon: Icons.diversity_1_outlined,
      background: AssessmentColors.socialTint,
      title: 'Cari Dukungan Sosial',
      body:
          'Jangan ragu untuk berbicara dengan teman, keluarga, atau '
          'profesional jika merasa terbebani.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Berikut beberapa langkah yang bisa kamu lakukan untuk '
          'membantu menjaga kesehatan mental.',
          style: AppTextStyles.subtitle(context)
              .copyWith(fontSize: context.ui(14)),
        ),
        SizedBox(height: context.ui(AppSpacing.sm)),
        Text(
          'Panduan umum, belum dipersonalisasi berdasarkan hasil asesmen.',
          style: AppTextStyles.subtitle(context)
              .copyWith(fontSize: context.ui(12)),
        ),
        SizedBox(height: context.ui(AppSpacing.md)),
        if (isHighRisk) ...[
          Container(
            padding: EdgeInsets.all(context.ui(AppSpacing.md)),
            decoration: BoxDecoration(
              color: AssessmentColors.riskHigh.withOpacity(0.08),
              borderRadius: BorderRadius.circular(context.ui(16)),
              border: Border.all(
                color: AssessmentColors.riskHigh.withOpacity(0.35),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(context.ui(6)),
                      decoration: BoxDecoration(
                        color: AssessmentColors.riskHigh.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.health_and_safety_rounded,
                        color: AssessmentColors.riskHigh,
                        size: context.ui(22),
                      ),
                    ),
                    SizedBox(width: context.ui(AppSpacing.sm)),
                    Expanded(
                      child: Text(
                        'Konsultasi Psikolog Profesional',
                        style: TextStyle(
                          fontSize: context.ui(14.5),
                          fontWeight: FontWeight.bold,
                          color: AssessmentColors.riskHigh,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.ui(AppSpacing.xs)),
                Text(
                  'Tingkat burnout berat memerlukan penanganan dan evaluasi dari ahli. Temukan psikolog atau faskes terdekat untuk langkah pemulihan terbaik.',
                  style: TextStyle(
                    fontSize: context.ui(12.5),
                    color: AppColors.of(context).body,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: context.ui(AppSpacing.sm)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        context.push(RoutePaths.nearbyPsychologists),
                    icon: Icon(Icons.near_me_rounded, size: context.ui(16)),
                    label: Text(
                      'Cari Psikolog Terdekat',
                      style: TextStyle(
                        fontSize: context.ui(13),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AssessmentColors.riskHigh,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        vertical: context.ui(10),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.ui(10)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.ui(AppSpacing.md)),
        ],
        for (final item in _items) ...[
          RecommendationCard(
            icon: item.icon,
            backgroundColor: item.background,
            title: item.title,
            body: item.body,
          ),
          SizedBox(height: context.ui(12)),
        ],
        const EncouragementCard(),
      ],
    );
  }
}
