import 'package:flutter/material.dart';

import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class HistoryEmptyView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const HistoryEmptyView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.ui(12),
              color: AppColors.of(context).hint,
            ),
          ),
          if (onRetry != null) ...[
            SizedBox(height: context.ui(8)),
            TextButton(
              onPressed: onRetry,
              child: Text(
                AppLocalizations.of(context)!.historyRetry,
                style: TextStyle(fontSize: context.ui(14)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
