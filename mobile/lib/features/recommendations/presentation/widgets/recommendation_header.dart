import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_header.dart';

class RecommendationHeader extends StatelessWidget {
  const RecommendationHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppPageHeader(
      title: l10n.recommendationsForYouTitle,
      onBack: onBack,
      tooltip: l10n.recommendationsBackTooltip,
      fontSize: 20,
    );
  }
}
