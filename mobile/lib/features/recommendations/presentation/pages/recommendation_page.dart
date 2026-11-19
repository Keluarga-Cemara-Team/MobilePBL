import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/assessment_colors.dart';
import '../../../../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
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
                              l10n.recommendationErrorLoading,
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
                              child: Text(l10n.recommendationTryAgain),
                            ),
                          ],
                        ),
                        data: (item) => item == null
                            ? Text(
                                l10n.recommendationNotFound,
                                style: AppTextStyles.subtitle(context)
                                    .copyWith(fontSize: context.ui(14)),
                              )
                            : _GeneralRecommendations(
                                isHighRisk: item.riskLevel == RiskLevel.tinggi,
                                aiRecommendation: item.aiRecommendation,
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
  const _GeneralRecommendations({
    this.isHighRisk = false,
    this.aiRecommendation,
  });

  final bool isHighRisk;
  final String? aiRecommendation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasAiRecommendation =
        aiRecommendation != null && aiRecommendation!.trim().isNotEmpty;
    final items = [
      (
        icon: Icons.bed_outlined,
        background: AssessmentColors.sleepTint,
        title: l10n.recItemSleepTitle,
        body: l10n.recItemSleepBody,
      ),
      (
        icon: Icons.monitor_heart_outlined,
        background: AssessmentColors.activityTint,
        title: l10n.recItemActivityTitle,
        body: l10n.recItemActivityBody,
      ),
      (
        icon: Icons.self_improvement_outlined,
        background: AssessmentColors.relaxationTint,
        title: l10n.recItemRelaxationTitle,
        body: l10n.recItemRelaxationBody,
      ),
      (
        icon: Icons.diversity_1_outlined,
        background: AssessmentColors.socialTint,
        title: l10n.recItemSocialSupportTitle,
        body: l10n.recItemSocialSupportBody,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recommendationIntroSteps,
          style: AppTextStyles.subtitle(context)
              .copyWith(fontSize: context.ui(14)),
        ),
        SizedBox(height: context.ui(AppSpacing.sm)),
        Text(
          hasAiRecommendation
              ? l10n.recommendationPersonalizedNote
              : l10n.recommendationGeneralNote,
          style: AppTextStyles.subtitle(context)
              .copyWith(fontSize: context.ui(12)),
        ),
        SizedBox(height: context.ui(AppSpacing.md)),
        if (hasAiRecommendation)
          _AiPersonalizedRecommendationCard(
            recommendation: aiRecommendation!.trim(),
          ),
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
                        l10n.highRiskConsultationTitle,
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
                  l10n.highRiskConsultationDesc,
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
                      l10n.findNearestPsychologistsAction,
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
        for (final item in items) ...[
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

class _AiPersonalizedRecommendationCard extends StatelessWidget {
  const _AiPersonalizedRecommendationCard({required this.recommendation});

  final String recommendation;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: context.ui(AppSpacing.md)),
      padding: EdgeInsets.all(context.ui(AppSpacing.md)),
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(context.ui(16)),
        border: Border.all(
          color: colors.primary.withOpacity(0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.ui(6)),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(context.ui(10)),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: colors.primary,
                  size: context.ui(20),
                ),
              ),
              SizedBox(width: context.ui(AppSpacing.sm)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.aiRecommendationCardTitle,
                      style: TextStyle(
                        fontSize: context.ui(14.5),
                        fontWeight: FontWeight.bold,
                        color: colors.navy,
                      ),
                    ),
                    Text(
                      l10n.aiRecommendationBadge,
                      style: TextStyle(
                        fontSize: context.ui(11),
                        fontWeight: FontWeight.w600,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.ui(AppSpacing.sm)),
          Text(
            recommendation,
            style: TextStyle(
              fontSize: context.ui(13),
              color: colors.body,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
