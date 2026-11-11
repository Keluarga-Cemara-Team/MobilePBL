import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/personalization.dart';
import 'personalization_fields.dart';

class AdditionalInformationSection extends StatelessWidget {
  const AdditionalInformationSection({
    super.key,
    required this.data,
    required this.onChanged,
  });

  final Personalization data;
  final ValueChanged<Personalization> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PersonalizationDescription(l10n.personalizationOptionalIntro),
        PersonalizationNumberField(
          label: l10n.personalizationMonthlyIncome,
          hint: l10n.personalizationIncomeHint,
          suffix: 'IDR',
          value: data.income,
          onChanged: (value) {
            onChanged(data.copyWith(income: value));
          },
        ),
        PersonalizationChoices(
          label: l10n.personalizationFamilyHistory,
          description: l10n.personalizationFamilyHistoryDescription,
          value: data.familyMentalHealthHistory,
          options: const [
            'Ya',
            'Tidak',
          ],
          onChanged: (value) {
            onChanged(
              data.copyWith(familyMentalHealthHistory: value),
            );
          },
        ),
        PersonalizationChoices(
          label: l10n.personalizationProfessionalSupport,
          description: l10n.personalizationProfessionalSupportDescription,
          value: data.professionalSupport,
          options: const [
            'Ya',
            'Tidak',
          ],
          onChanged: (value) {
            onChanged(data.copyWith(professionalSupport: value));
          },
        ),
      ],
    );
  }
}
