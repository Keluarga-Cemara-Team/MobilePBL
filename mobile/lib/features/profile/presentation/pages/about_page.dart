import 'package:flutter/material.dart';

import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/profile_subpage_scaffold.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ProfileSubpageScaffold(
      title: l10n.profileAboutTitle,
      onBack: onBack,
      children: [
        Container(
          padding: EdgeInsets.all(context.ui(24)),
          decoration: BoxDecoration(
            color: Color.alphaBlend(
              AppColors.of(context).blob.withValues(alpha: 0.6),
              AppColors.of(context).background,
            ),
            borderRadius: BorderRadius.circular(context.ui(24)),
          ),
          child: Column(
            children: [
              Container(
                width: context.ui(72),
                height: context.ui(72),
                decoration: BoxDecoration(
                  color: AppColors.of(context).primary,
                  borderRadius: BorderRadius.circular(context.ui(22)),
                ),
                child: Icon(
                  Icons.spa_outlined,
                  color: AppColors.of(context).onPrimary,
                  size: context.ui(38),
                ),
              ),
              SizedBox(height: context.ui(18)),
              Text(
                'AntiBurnout',
                style: AppTextStyles.brand(context)
                    .copyWith(fontSize: context.ui(28)),
              ),
              SizedBox(height: context.ui(6)),
              Text(
                l10n.profileMotto,
                textAlign: TextAlign.center,
                style: AppTextStyles.subtitle(context)
                    .copyWith(fontSize: context.ui(14)),
              ),
              SizedBox(height: context.ui(10)),
              Text(
                l10n.profileVersion('1.0.0'),
                style: AppTextStyles.subtitle(context)
                    .copyWith(fontSize: context.ui(12)),
              ),
            ],
          ),
        ),
        SizedBox(height: context.ui(28)),
        Text(
          l10n.profileAboutHeading,
          style: AppTextStyles.title(context)
              .copyWith(fontSize: context.ui(18)),
        ),
        SizedBox(height: context.ui(10)),
        Text(
          l10n.profileAboutDescription,
          style: AppTextStyles.subtitle(context)
              .copyWith(fontSize: context.ui(14)),
        ),
        SizedBox(height: context.ui(24)),
        for (final feature in [
          (
            Icons.assignment_outlined,
            l10n.profileFeatureAssessment,
            l10n.profileFeatureAssessmentDescription,
          ),
          (
            Icons.history_rounded,
            l10n.profileFeatureHistory,
            l10n.profileFeatureHistoryDescription,
          ),
          (
            Icons.favorite_border_rounded,
            l10n.profileFeatureGuidance,
            l10n.profileFeatureGuidanceDescription,
          ),
        ]) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(context.ui(11)),
                decoration: BoxDecoration(
                  color: AppColors.of(context).blob,
                  borderRadius: BorderRadius.circular(context.ui(12)),
                ),
                child: Icon(
                  feature.$1,
                  color: AppColors.of(context).primary,
                  size: context.ui(24),
                ),
              ),
              SizedBox(width: context.ui(14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature.$2,
                      style: AppTextStyles.subtitle(context).copyWith(
                        color: AppColors.of(context).navy,
                        fontWeight: FontWeight.w600,
                        fontSize: context.ui(14),
                      ),
                    ),
                    SizedBox(height: context.ui(4)),
                    Text(
                      feature.$3,
                      style: AppTextStyles.subtitle(context)
                          .copyWith(fontSize: context.ui(13)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.ui(20)),
        ],
        ProfileInfoCard(
          text: l10n.profileAboutDisclaimer,
        ),
        SizedBox(height: context.ui(28)),
        Text(
          l10n.profileDevelopedBy,
          textAlign: TextAlign.center,
          style: AppTextStyles.subtitle(context)
              .copyWith(fontSize: context.ui(13)),
        ),
        SizedBox(height: context.ui(6)),
        Text(
          '© 2026 AntiBurnout',
          textAlign: TextAlign.center,
          style: AppTextStyles.subtitle(context).copyWith(
            color: AppColors.of(context).hint,
            fontSize: context.ui(12),
          ),
        ),
      ],
    );
  }
}
