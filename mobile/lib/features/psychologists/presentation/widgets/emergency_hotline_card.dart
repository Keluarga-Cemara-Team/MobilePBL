import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/assessment_colors.dart';
import '../../../../l10n/app_localizations.dart';

class EmergencyHotlineCard extends StatelessWidget {
  const EmergencyHotlineCard({super.key});

  Future<void> _callHotline() async {
    final uri = Uri.parse('tel:119');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
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
                  Icons.support_agent_rounded,
                  color: AssessmentColors.riskHigh,
                  size: context.ui(20),
                ),
              ),
              SizedBox(width: context.ui(AppSpacing.sm)),
              Expanded(
                child: Text(
                  l10n.emergencyHotlineTitle,
                  style: TextStyle(
                    fontSize: context.ui(14),
                    fontWeight: FontWeight.bold,
                    color: AppColors.of(context).navy,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.ui(AppSpacing.xs)),
          Text(
            l10n.emergencyHotlineDesc,
            style: TextStyle(
              fontSize: context.ui(12),
              color: AppColors.of(context).body,
              height: 1.4,
            ),
          ),
          SizedBox(height: context.ui(AppSpacing.sm)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _callHotline,
              icon: Icon(Icons.phone_in_talk, size: context.ui(16)),
              label: Text(
                l10n.emergencyHotlineCallButton,
                style: TextStyle(
                  fontSize: context.ui(13),
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AssessmentColors.riskHigh,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: context.ui(10)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.ui(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
