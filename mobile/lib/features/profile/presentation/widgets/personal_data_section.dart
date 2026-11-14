import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/personalization.dart';
import 'personalization_fields.dart';

class PersonalDataSection extends StatelessWidget {
  const PersonalDataSection({
    super.key,
    required this.data,
    required this.onChanged,
  });

  final Personalization data;
  final ValueChanged<Personalization> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PersonalizationDescription(l10n.personalizationTellAboutYou),
        PersonalizationDateField(
          label: l10n.personalizationBirthDate,
          value: data.birthDate,
          firstDate: DateTime(1900),
          lastDate: DateTime(now.year, now.month, now.day),
          onChanged: (value) {
            onChanged(
              data.copyWith(birthDate: value, clearBirthDate: value == null),
            );
          },
        ),
        PersonalizationChoices(
          label: l10n.personalizationGender,
          value: data.gender,
          options: const ['Perempuan', 'Laki-laki', 'Lainnya'],
          onChanged: (value) {
            onChanged(data.copyWith(gender: value));
          },
        ),
        PersonalizationDropdown(
          label: l10n.personalizationCountry,
          hint: l10n.personalizationSelectCountry,
          value: data.country,
          options: const [
            'Indonesia',
            'Malaysia',
            'Singapura',
            'Thailand',
            'Filipina',
            'Vietnam',
            'Lainnya',
          ],
          onChanged: (value) {
            onChanged(data.copyWith(country: value));
          },
        ),
        PersonalizationDropdown(
          label: l10n.personalizationEducation,
          hint: l10n.personalizationSelectEducation,
          value: data.education,
          options: const [
            'SD / sederajat',
            'SMP / sederajat',
            'SMA / SMK / sederajat',
            'Diploma',
            'D4 / S1',
            'S2',
            'S3',
            'Lainnya',
          ],
          onChanged: (value) {
            onChanged(data.copyWith(education: value));
          },
        ),
      ],
    );
  }
}
