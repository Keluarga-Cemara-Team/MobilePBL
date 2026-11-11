import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/assessment_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../../../../shared/widgets/app_blob_background.dart';
import '../../../assessment/di/assessment_providers.dart';
import '../../../assessment/domain/entities/risk_level.dart';
import '../result_copy.dart';
import '../widgets/risk_summary_card.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({
    super.key,
    required this.assessmentId,
    this.onBack,
    this.onRecommendationTap,
  });

  final String assessmentId;
  final VoidCallback? onBack;
  final VoidCallback? onRecommendationTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final assessment = ref.watch(assessmentByIdProvider(assessmentId));
    final goBack = onBack ?? () => Navigator.of(context).maybePop();

    return Scaffold(
      backgroundColor: AppColors.of(context).background,
      body: AppBlobBackground(
        subtle: true,
        refreshKey: assessmentId,
        child: SafeArea(
          child: assessment.when(
            loading: () => _ResultStatus(
              onBack: goBack,
              child: const Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => _ResultStatus(
              onBack: goBack,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.resultLoadError,
                    style: AppTextStyles.subtitle(context)
                        .copyWith(fontSize: context.ui(14)),
                  ),
                  TextButton(
                    onPressed: () =>
                        ref.invalidate(assessmentByIdProvider(assessmentId)),
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(fontSize: context.ui(14)),
                      padding: EdgeInsets.all(context.ui(12)),
                    ),
                    child: Text(l10n.historyRetry),
                  ),
                ],
              ),
            ),
            data: (item) {
              if (item == null) {
                return _ResultStatus(
                  onBack: goBack,
                  child: Text(
                    l10n.resultNotFound,
                    style: AppTextStyles.subtitle(context)
                        .copyWith(fontSize: context.ui(14)),
                  ),
                );
              }

              final (label, color) = switch (item.riskLevel) {
                RiskLevel.rendah => (l10n.riskLow, AssessmentColors.riskLow),
                RiskLevel.sedang => (
                  l10n.riskMedium,
                  AssessmentColors.riskMedium,
                ),
                RiskLevel.tinggi => (l10n.riskHigh, AssessmentColors.riskHigh),
              };
              return RiskSummaryCard(
                key: ValueKey(item.id),
                scrollKey: PageStorageKey('result-scroll-${item.id}'),
                title: l10n.resultTitle,
                level: label,
                levelColor: color,
                ringColor: color,
                description: l10n.resultDescription(label.toLowerCase()),
                assessmentDate: l10n.resultAssessmentDate(
                  formatAssessmentDate(
                    item.takenAt,
                    english: l10n.localeName == 'en',
                  ),
                ),
                disclaimer: l10n.resultDisclaimer,
                isExample: item.isExample,
                factors: [
                  for (var index = 0; index < item.modelFactors.length; index++)
                    FactorItemData(
                      icon: item.isExample
                          ? switch (index) {
                              0 => Icons.nightlight_outlined,
                              1 => Icons.bar_chart_rounded,
                              _ => Icons.favorite_rounded,
                            }
                          : Icons.insights_outlined,
                      label: localizeResultFactor(
                        l10n,
                        item.modelFactors[index].label,
                      ),
                      backgroundColor: item.isExample
                          ? switch (index) {
                              0 => AppColors.of(context).blob,
                              1 => AssessmentColors.sleepTint,
                              _ => AssessmentColors.relaxationTint,
                            }
                          : AssessmentColors.activityTint,
                      iconColor: item.isExample
                          ? switch (index) {
                              0 => AppColors.of(context).primary,
                              1 => AppColors.of(context).leaf,
                              _ => AssessmentColors.riskHigh,
                            }
                          : AppColors.of(context).primary,
                    ),
                ],
                answerSummary: [
                  for (final answer in item.answerSummary)
                    AnswerSummaryItemData(
                      label: localizeResultAnswerLabel(l10n, answer.label),
                      value: localizeResultAnswerValue(l10n, answer),
                    ),
                ],
                onBackTap: goBack,
                onRecommendationTap: onRecommendationTap,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ResultStatus extends StatelessWidget {
  const _ResultStatus({required this.onBack, required this.child});

  final VoidCallback onBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ResultHeader(
            title: AppLocalizations.of(context)!.resultTitle,
            onBack: onBack,
          ),
          Padding(
            padding: EdgeInsets.all(context.ui(AppSpacing.lg)),
            child: SizedBox(width: double.infinity, child: child),
          ),
        ],
      ),
    );
  }
}
