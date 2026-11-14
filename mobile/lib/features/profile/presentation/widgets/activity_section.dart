import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/personalization.dart';
import 'personalization_fields.dart';

class ActivitySection extends StatelessWidget {
  const ActivitySection({
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
        PersonalizationDropdown(
          label: l10n.personalizationActivityOccupation,
          hint: l10n.personalizationSelectOccupation,
          value: data.occupation,
          options: const [
            'Pelajar / Mahasiswa',
            'Karyawan',
            'Wirausaha',
            'Freelancer',
            'Mengurus rumah tangga',
            'Belum bekerja',
            'Lainnya',
          ],
          onChanged: (value) {
            onChanged(data.copyWith(occupation: value));
          },
        ),
        PersonalizationDropdown(
          label: l10n.personalizationEmploymentStatus,
          hint: l10n.personalizationSelectEmploymentStatus,
          value: data.employmentStatus,
          options: const [
            'Penuh waktu',
            'Paruh waktu',
            'Kontrak',
            'Magang',
            'Bekerja mandiri',
            'Tidak bekerja',
          ],
          onChanged: (value) {
            onChanged(data.copyWith(employmentStatus: value));
          },
        ),
        PersonalizationChoices(
          label: l10n.personalizationWorkLocation,
          value: data.workLocation,
          options: const [
            'Rumah',
            'Kantor',
            'Hybrid',
          ],
          onChanged: (value) {
            onChanged(data.copyWith(workLocation: value));
          },
        ),
        PersonalizationChoices(
          label: l10n.personalizationSmoking,
          value: data.smoking,
          options: const [
            'Ya',
            'Tidak',
          ],
          onChanged: (value) {
            onChanged(data.copyWith(smoking: value));
          },
        ),
        PersonalizationChoices(
          label: l10n.personalizationAlcohol,
          value: data.alcohol,
          options: const [
            'Ya',
            'Tidak',
          ],
          onChanged: (value) {
            onChanged(data.copyWith(alcohol: value));
          },
        ),
      ],
    );
  }
}
