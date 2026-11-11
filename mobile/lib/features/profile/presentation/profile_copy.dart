import 'package:mobile/l10n/app_localizations.dart';

String localizeProfileOption(AppLocalizations l10n, String value) =>
    switch (value) {
      'Perempuan' => l10n.personalizationGenderFemale,
      'Laki-laki' => l10n.personalizationGenderMale,
      'Ya' => l10n.personalizationYes,
      'Tidak' => l10n.personalizationNo,
      'Lainnya' => l10n.personalizationOther,
      'Singapura' => l10n.personalizationCountrySingapore,
      'Filipina' => l10n.personalizationCountryPhilippines,
      'SD / sederajat' => l10n.personalizationEducationPrimary,
      'SMP / sederajat' => l10n.personalizationEducationJunior,
      'SMA / SMK / sederajat' => l10n.personalizationEducationSenior,
      'Diploma' => l10n.personalizationEducationDiploma,
      'D4 / S1' => l10n.personalizationEducationBachelor,
      'S2' => l10n.personalizationEducationMaster,
      'S3' => l10n.personalizationEducationDoctorate,
      'Pelajar / Mahasiswa' => l10n.personalizationOccupationStudent,
      'Karyawan' => l10n.personalizationOccupationEmployee,
      'Wirausaha' => l10n.personalizationOccupationEntrepreneur,
      'Freelancer' => l10n.personalizationOccupationFreelancer,
      'Mengurus rumah tangga' => l10n.personalizationOccupationHomemaker,
      'Belum bekerja' => l10n.personalizationOccupationUnemployed,
      'Penuh waktu' => l10n.personalizationEmploymentFullTime,
      'Paruh waktu' => l10n.personalizationEmploymentPartTime,
      'Kontrak' => l10n.personalizationEmploymentContract,
      'Magang' => l10n.personalizationEmploymentIntern,
      'Bekerja mandiri' => l10n.personalizationEmploymentSelfEmployed,
      'Tidak bekerja' => l10n.personalizationEmploymentUnemployed,
      'Rumah' => l10n.personalizationWorkHome,
      'Kantor' => l10n.personalizationWorkOffice,
      _ => value,
    };

String localizePersonalizationError(AppLocalizations l10n, String message) =>
    switch (message) {
      'Silakan masuk terlebih dahulu.' => l10n.personalizationLoginRequired,
      'Personalisasi gagal dimuat. Silakan coba lagi.' =>
        l10n.personalizationLoadError,
      'Pilih tanggal lahir antara 1 Januari 1900 dan hari ini.' =>
        l10n.personalizationBirthDateInvalid,
      'Personalisasi gagal disimpan. Silakan coba lagi.' =>
        l10n.personalizationSaveError,
      _ => message,
    };
