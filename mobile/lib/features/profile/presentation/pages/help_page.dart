import 'package:flutter/material.dart';

import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/profile_subpage_scaffold.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final questions = [
      (l10n.profileFaq1Question, l10n.profileFaq1Answer),
      (l10n.profileFaq2Question, l10n.profileFaq2Answer),
      (l10n.profileFaq3Question, l10n.profileFaq3Answer),
      (l10n.profileFaq4Question, l10n.profileFaq4Answer),
      (l10n.profileFaq5Question, l10n.profileFaq5Answer),
      (l10n.profileFaq6Question, l10n.profileFaq6Answer),
      (l10n.profileFaq7Question, l10n.profileFaq7Answer),
    ];
    return ProfileSubpageScaffold(
      title: l10n.profileHelpTitle,
      onBack: onBack,
      children: [
        ProfileInfoCard(
          icon: Icons.help_outline_rounded,
          text: l10n.profileHelpIntro,
        ),
        SizedBox(height: context.ui(28)),
        Text(
          l10n.profileFaqTitle,
          style: AppTextStyles.title(context)
              .copyWith(fontSize: context.ui(18)),
        ),
        SizedBox(height: context.ui(16)),
        for (var index = 0; index < questions.length; index++) ...[
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.of(context).border),
              borderRadius: BorderRadius.circular(context.ui(16)),
            ),
            clipBehavior: Clip.antiAlias,
            child: IconTheme.merge(
              data: IconThemeData(size: context.ui(24)),
              child: ExpansionTile(
                key: PageStorageKey('faq-$index'),
                maintainState: true,
                minTileHeight: context
                    .ui(56)
                    .clamp(48.0, double.infinity)
                    .toDouble(),
                shape: const Border(),
                collapsedShape: const Border(),
                tilePadding: EdgeInsets.symmetric(
                  horizontal: context.ui(16),
                  vertical: context.ui(6),
                ),
                childrenPadding: EdgeInsets.fromLTRB(
                  context.ui(16),
                  0,
                  context.ui(16),
                  context.ui(18),
                ),
                title: Text(
                  questions[index].$1,
                  style: AppTextStyles.subtitle(context).copyWith(
                    color: AppColors.of(context).navy,
                    fontWeight: FontWeight.w600,
                    fontSize: context.ui(14),
                  ),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      questions[index].$2,
                      style: AppTextStyles.subtitle(context)
                          .copyWith(fontSize: context.ui(13), height: 1.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: context.ui(12)),
        ],
      ],
    );
  }
}
