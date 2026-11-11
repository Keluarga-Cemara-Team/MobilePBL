// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get dashboardHello => 'Halo,';

  @override
  String get dashboardSubtitle =>
      'Jaga kesehatan mentalmu, mulai dari sekarang.';

  @override
  String get openProfile => 'Buka profil';

  @override
  String get latestAssessmentHeading => 'HASIL ASESMEN TERAKHIR';

  @override
  String get startSurvey => 'Mulai Survei';

  @override
  String get startSurveySubtitle => 'Lakukan asesmen burnout baru';

  @override
  String get myHistory => 'Riwayat Saya';

  @override
  String get myHistorySubtitle => 'Lihat hasil asesmen sebelumnya';

  @override
  String get latestAssessmentEmpty => 'Belum ada asesmen';

  @override
  String get startSurveyPrompt =>
      'Mulai survei untuk mengenali kondisi keseharianmu.';

  @override
  String get viewDetails => 'Lihat Detail ›';

  @override
  String get burnoutRisk => 'Risiko Burnout';

  @override
  String get riskLow => 'Rendah';

  @override
  String get riskMedium => 'Sedang';

  @override
  String get riskHigh => 'Tinggi';

  @override
  String get motivationTitle => 'Motivasi Hari Ini';

  @override
  String get riskStatisticsTitle => 'Statistik Risiko';

  @override
  String get assessmentHistorySummary => 'Ringkasan seluruh riwayat survei';

  @override
  String get samplePreview => 'Pratinjau dengan data contoh';

  @override
  String get includesSampleData => 'Termasuk data contoh';

  @override
  String assessmentsTotal(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count asesmen secara keseluruhan',
      one: '1 asesmen secara keseluruhan',
      zero: 'Belum ada asesmen',
    );
    return '$_temp0';
  }

  @override
  String get lastSevenDaysChart => 'Grafik 7 hari terakhir';

  @override
  String get weeklyEmpty => 'Belum ada survei dalam 7 hari terakhir.';

  @override
  String get weeklyBarDescription =>
      'Setiap batang mewakili satu survei. Ketuk untuk melihat risikonya.';

  @override
  String get weeklyChartOrderNote =>
      'Urutan dari baru ke lama. Tinggi batang menunjukkan kategori risiko, bukan skor medis.';

  @override
  String get swipeForDates => 'Geser untuk melihat tanggal lainnya.';

  @override
  String dayAssessmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count survei',
      one: '1 survei',
      zero: 'Tidak ada survei',
    );
    return '$_temp0';
  }

  @override
  String emptyDateSemantics(Object date) {
    return '$date, belum ada survei';
  }

  @override
  String riskTooltip(Object risk, Object time) {
    return '$risk · $time';
  }

  @override
  String riskSemantics(Object date, Object risk) {
    return '$date, risiko $risk';
  }

  @override
  String weekRange(Object end, Object start) {
    return '$start – $end';
  }

  @override
  String get motivation01 =>
      'Tidur yang cukup membantu menjaga kesehatan mental dan produktivitasmu.';

  @override
  String get motivation02 =>
      'Langkah kecil hari ini tetap berarti. Kamu boleh bergerak sesuai kemampuanmu.';

  @override
  String get motivation03 =>
      'Beristirahat sejenak memberi ruang untuk memulai kembali.';

  @override
  String get motivation04 =>
      'Tidak semuanya perlu selesai sekaligus. Mulailah dari satu hal yang paling penting.';

  @override
  String get motivation05 =>
      'Beri apresiasi pada dirimu atas usaha yang sudah kamu lakukan hari ini.';

  @override
  String get motivation06 =>
      'Di sela kesibukan, sisihkan sedikit waktu untuk hal yang kamu nikmati.';

  @override
  String get motivation07 =>
      'Saat merasa kewalahan, kamu boleh meminta bantuan orang yang kamu percaya.';

  @override
  String get motivation08 =>
      'Berikan dirimu izin untuk berhenti sejenak dan mengatur ulang prioritas.';

  @override
  String get motivation09 =>
      'Hari yang berat tidak menghapus kemajuan yang sudah kamu buat.';

  @override
  String get motivation10 =>
      'Kamu boleh menetapkan batas ketika tenaga dan waktumu sedang terbatas.';

  @override
  String get motivation11 =>
      'Luangkan waktu untuk terhubung dengan orang yang membuatmu merasa didengar.';

  @override
  String get motivation12 =>
      'Mulai lagi dengan satu langkah kecil. Tidak semuanya harus sempurna.';

  @override
  String get mondayShort => 'Sen';

  @override
  String get tuesdayShort => 'Sel';

  @override
  String get wednesdayShort => 'Rab';

  @override
  String get thursdayShort => 'Kam';

  @override
  String get fridayShort => 'Jum';

  @override
  String get saturdayShort => 'Sab';

  @override
  String get sundayShort => 'Min';

  @override
  String get surveyTitle => 'Survei Harian';

  @override
  String get surveyIntroTime => 'Waktu untuk dirimu · 3–5 menit';

  @override
  String get surveyIntroQuestion => 'Bagaimana harimu?';

  @override
  String get surveyIntroBody =>
      'Luangkan waktu sejenak untuk mengenali aktivitas, kebiasaan, dan perasaanmu hari ini.';

  @override
  String get surveyIntroBenefitTitle => 'Langkah kecil, manfaat berarti';

  @override
  String get surveyIntroSimpleTitle => 'Pertanyaan sederhana';

  @override
  String get surveyIntroSimpleBody =>
      'Ceritakan aktivitas dan kebiasaan harianmu.';

  @override
  String get surveyIntroPatternTitle => 'Kenali pola keseharianmu';

  @override
  String get surveyIntroPatternBody =>
      'Bantu refleksi dan pantau kesejahteraanmu.';

  @override
  String get surveyIntroDisclaimer =>
      'Tidak ada jawaban benar atau salah. Jawab sesuai kondisi yang kamu rasakan.';

  @override
  String get surveyStart => 'Mulai Survei';

  @override
  String get surveyBackToIntro => 'Kembali ke pengantar survei';

  @override
  String get surveyUnavailable => 'Survei belum tersedia';

  @override
  String get surveyLoadFailed => 'Survei gagal dimuat';

  @override
  String get surveyUnavailableBody =>
      'Pertanyaan dan layanan asesmen belum tersedia. Silakan kembali lagi nanti.';

  @override
  String get surveyRetry => 'Coba Lagi';

  @override
  String get surveyBackToIntroButton => 'Kembali ke Pengantar';

  @override
  String get surveyAnswerPrompt => 'Jawab sesuai kondisi yang kamu rasakan.';

  @override
  String get surveySubmitAnswers => 'Kirim Jawaban';

  @override
  String get surveyWriteAnswer => 'Tulis jawabanmu';

  @override
  String get surveyReviewTitle => 'Periksa jawabanmu';

  @override
  String get surveyReviewSubtitle => 'Pastikan jawaban sesuai sebelum dikirim.';

  @override
  String get surveyReviewTip =>
      'Hasil merupakan estimasi risiko, bukan diagnosis.';

  @override
  String surveyStepLabel(int current, int total) {
    return 'Langkah $current dari $total';
  }

  @override
  String get surveyBack => 'Kembali';

  @override
  String get surveyContinue => 'Lanjut';

  @override
  String get surveySubmitViewResults => 'Kirim & lihat hasil';

  @override
  String get surveyEditAnswer => 'Ubah';

  @override
  String get surveyActivityEasy => 'Aktivitas terasa mudah dihadapi';

  @override
  String get surveyActivityOverwhelming =>
      'Terasa terbebani, tetapi masih teratasi';

  @override
  String get surveyActivityDifficult => 'Beban terasa sulit dihadapi';

  @override
  String get surveyZeroHours => '0 jam';

  @override
  String surveyMaximumHours(int hours) {
    return '$hours jam';
  }

  @override
  String get surveyOutOf100 => 'dari 100';

  @override
  String get surveyVeryUncomfortable => 'Sangat tidak nyaman';

  @override
  String get surveyVeryComfortable => 'Sangat nyaman';

  @override
  String get surveyOwnDuration => 'Atau isi durasi sendiri';

  @override
  String get surveyUnitHours => 'jam';

  @override
  String get surveyUnitCups => 'cangkir';

  @override
  String get surveyUnitMinutes => 'menit';

  @override
  String get surveyMinutesValidation =>
      'Masukkan jumlah menit berupa bilangan bulat 0 atau lebih.';

  @override
  String get surveyErrorLoadQuestions =>
      'Pertanyaan survei gagal dimuat. Coba lagi.';

  @override
  String get surveyErrorServiceUnavailable =>
      'Layanan asesmen belum tersedia. Jawaban belum dikirim.';

  @override
  String get surveyErrorSubmit => 'Jawaban gagal dikirim. Coba lagi.';

  @override
  String get sleepQualityLabel => 'Bagaimana kualitas tidurmu\ntadi malam?';

  @override
  String get sleepQualitySubtitle => 'Pilih kualitas tidur yang paling sesuai.';

  @override
  String get sleepQualityTip =>
      'Durasi dan kualitas tidur adalah dua hal berbeda.';

  @override
  String get sleepQualityReview => 'Kualitas tidur';

  @override
  String get sleepPoor => 'Buruk';

  @override
  String get sleepFair => 'Cukup';

  @override
  String get sleepGood => 'Baik';

  @override
  String get sleepVeryGood => 'Sangat baik';

  @override
  String get screenTimeLabel => 'Berapa lama kamu menggunakan\nlayar hari ini?';

  @override
  String get screenTimeSubtitle => 'Hitung penggunaan HP, laptop, dan TV.';

  @override
  String get screenTimeTip =>
      'Beri jeda dari layar untuk mengistirahatkan mata dan pikiran.';

  @override
  String get screenTimeReview => 'Waktu layar';

  @override
  String get sleepDurationLabel => 'Berapa lama durasi tidur Anda\nhari ini?';

  @override
  String get sleepDurationSubtitle =>
      'Geser slider atau gunakan tombol untuk menentukan durasi tidur.';

  @override
  String get sleepDurationTip =>
      'Tidur yang cukup membantu menjaga kesehatan mental dan produktivitasmu.';

  @override
  String get sleepDurationReview => 'Durasi tidur';

  @override
  String get coffeeLabel => 'Berapa cangkir kopi yang kamu\nminum hari ini?';

  @override
  String get coffeeSubtitle =>
      'Gunakan tombol untuk menambah atau mengurangi jumlah.';

  @override
  String get coffeeTip =>
      'Kafein secukupnya memberi energi, namun berlebihan bisa memicu kecemasan.';

  @override
  String get coffeeReview => 'Kopi';

  @override
  String get workloadLabel =>
      'Seberapa terbebani kamu oleh\naktivitas hari ini?';

  @override
  String get workloadSubtitle =>
      'Pilih kondisi yang paling mendekati perasaanmu.';

  @override
  String get workloadTip =>
      'Menyeimbangkan aktivitas harian sangat penting untuk kesehatan fisik dan mentalmu.';

  @override
  String get workloadReview => 'Stres';

  @override
  String get workloadLight => 'Ringan';

  @override
  String get workloadModerate => 'Sedang';

  @override
  String get workloadHeavy => 'Berat';

  @override
  String get meditationLabel =>
      'Berapa menit kamu melakukan\nmeditasi hari ini?';

  @override
  String get meditationSubtitle =>
      'Pilih durasi atau isi dengan angka sendiri.';

  @override
  String get meditationTip =>
      'Cuma butuh 15 menit meditasi buat recharge energi dan jernihin pikiran.';

  @override
  String get meditationReview => 'Meditasi';

  @override
  String get moodLabel => 'Berapa rating secara keseluruhan\nhari ini?';

  @override
  String get moodSubtitle => 'Geser slider untuk menentukan nilai.';

  @override
  String get moodTip =>
      'Refleksi singkat di akhir hari membantu mengenali apa yang membuatmu stres atau bahagia.';

  @override
  String get moodReview => 'Suasana hati';

  @override
  String get historyTitle => 'Riwayat Survei';

  @override
  String get historyDescription => 'Hasil asesmen burnout sebelumnya.';

  @override
  String get historySearchHint => 'Cari riwayat...';

  @override
  String get historyFilterAll => 'Semua';

  @override
  String get historyEmpty => 'Belum ada riwayat pemeriksaan.';

  @override
  String get historyNoResults => 'Riwayat tidak ditemukan.';

  @override
  String get historyLoadError => 'Gagal memuat riwayat. Coba lagi.';

  @override
  String get historyRetry => 'Coba lagi';

  @override
  String get historyLatest => 'Hasil asesmen terbaru';

  @override
  String get historyPrevious => 'Hasil asesmen sebelumnya';

  @override
  String get historyRiskTitle => 'Risiko Burnout';

  @override
  String get historyDetails => 'Detail';

  @override
  String get resultTitle => 'Hasil Prediksi';

  @override
  String get resultLoadError => 'Hasil asesmen belum dapat dimuat.';

  @override
  String get resultNotFound =>
      'Hasil asesmen tidak ditemukan. Buka hasil dari riwayat atau selesaikan survei terlebih dahulu.';

  @override
  String resultDescription(Object risk) {
    return 'Hasil asesmen menunjukkan indikasi risiko burnout pada tingkat $risk.';
  }

  @override
  String resultAssessmentDate(Object date) {
    return 'Asesmen $date';
  }

  @override
  String get resultDisclaimer =>
      'Ini bukan diagnosis medis, tetapi indikasi awal yang dapat membantumu lebih memahami kondisi diri.';

  @override
  String get resultSampleData => 'Data contoh';

  @override
  String get resultFactorsTitle => 'Faktor yang Mempengaruhi';

  @override
  String get resultFactorsUnavailable =>
      'Faktor dari model belum tersedia untuk asesmen ini.';

  @override
  String get resultExampleFactorsCaption =>
      'Faktor pada contoh hasil asesmen ini.';

  @override
  String get resultModelFactorsCaption =>
      'Faktor yang disertakan dalam hasil model untuk asesmen ini.';

  @override
  String get resultAnswerSummaryTitle => 'Ringkasan Jawaban';

  @override
  String get resultExampleAnswersCaption =>
      'Ringkasan jawaban pada contoh asesmen ini.';

  @override
  String get resultAnswersCaption =>
      'Ringkasan jawaban survei, bukan kontribusi model prediksi.';

  @override
  String get resultAnswersUnavailable => 'Ringkasan jawaban belum tersedia.';

  @override
  String get resultRecommendation => 'Lihat Rekomendasi';

  @override
  String get resultRiskLevel => 'Tingkat Risiko';

  @override
  String get resultRiskBurnout => 'Risiko Burnout';

  @override
  String get resultStressLabel => 'Tingkat stres';

  @override
  String resultRiskSemantics(Object risk) {
    return 'Tingkat risiko burnout: $risk';
  }

  @override
  String get resultExampleFactorSleep => 'Durasi tidur kurang stabil';

  @override
  String get resultExampleFactorActivity => 'Beban aktivitas cukup tinggi';

  @override
  String get resultExampleFactorStress => 'Tingkat stres yang meningkat';

  @override
  String resultFactorSleepSuboptimal(Object hours) {
    return 'Durasi tidur kurang optimal ($hours jam)';
  }

  @override
  String get resultFactorActivityStressHigh =>
      'Beban aktivitas dan stres harian tinggi';

  @override
  String resultFactorScreenIntensive(Object hours) {
    return 'Paparan layar intensif ($hours jam)';
  }

  @override
  String resultFactorCoffeeHigh(Object cups) {
    return 'Konsumsi kafein tinggi ($cups cangkir)';
  }

  @override
  String resultFactorCoffeeModerateHigh(Object cups) {
    return 'Konsumsi kafein cukup tinggi ($cups cangkir)';
  }

  @override
  String get resultFactorMeditationPositive =>
      'Praktik relaksasi / meditasi sangat baik';

  @override
  String get resultFactorBalancedActivityRest =>
      'Aktivitas dan pola istirahat seimbang';

  @override
  String get resultFactorStressHigh => 'Tingkat stres tergolong tinggi';

  @override
  String resultFactorSleepLow(Object hours) {
    return 'Durasi tidur kurang ($hours jam)';
  }

  @override
  String resultFactorScreenHigh(Object hours) {
    return 'Waktu layar cukup tinggi ($hours jam)';
  }

  @override
  String get resultFactorRestWorkBalanced =>
      'Pola istirahat dan beban kerja terkendali';

  @override
  String get resultFactorFatigueRhythm =>
      'Evaluasi kelelahan kerja & ritme harian';

  @override
  String get resultFactorRestStressAnalysis =>
      'Analisis waktu istirahat dan stres';

  @override
  String get navHome => 'Beranda';

  @override
  String get navSurvey => 'Survei';

  @override
  String get navHistory => 'Riwayat';

  @override
  String get navProfile => 'Profil';

  @override
  String get userAvatarSemantics => 'Avatar pengguna';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileEdit => 'Edit Profil';

  @override
  String get profilePersonalization => 'Personalisasi Profil';

  @override
  String get profilePreferences => 'Preferensi';

  @override
  String get profileHelp => 'Bantuan';

  @override
  String get profileAbout => 'Tentang Aplikasi';

  @override
  String get profileLogout => 'Keluar';

  @override
  String get profileLogoutError => 'Gagal keluar. Silakan coba lagi.';

  @override
  String get profileDefaultUser => 'Pengguna';

  @override
  String get profileEditTitle => 'Edit Profil';

  @override
  String get profileChangePhoto => 'Ubah Foto';

  @override
  String get profileOpeningGallery => 'Membuka galeri...';

  @override
  String get profileUseDefaultAvatar => 'Gunakan avatar bawaan';

  @override
  String get profilePhotoError =>
      'Foto belum dapat dibuka. Izinkan akses galeri atau coba foto lain.';

  @override
  String get profileName => 'Nama';

  @override
  String get profileNameHint => 'Masukkan nama kamu';

  @override
  String get profileNameRequired => 'Nama tidak boleh kosong.';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileEmailCannotChange => 'Email tidak dapat diubah.';

  @override
  String get profileNamePhotoSync =>
      'Nama dan foto profil disinkronkan secara aman ke akun Anda.';

  @override
  String get profileSaveChanges => 'Simpan Perubahan';

  @override
  String get profileCancel => 'Batal';

  @override
  String get profileSaved => 'Profil berhasil diperbarui dan disimpan.';

  @override
  String get profilePreferencesIntro =>
      'Sesuaikan tampilan tema, bahasa, serta jadwal pengingat check-in harian dan motivasi untuk mendukung kesehatan mentalmu.';

  @override
  String get profileAppearance => 'Tampilan';

  @override
  String get profileChooseTheme => 'Pilih tema yang paling nyaman untukmu.';

  @override
  String get profileThemeLight => 'Terang';

  @override
  String get profileThemeDark => 'Gelap';

  @override
  String get profileThemeSystem => 'Sistem';

  @override
  String get profileLanguageTitle => 'Bahasa';

  @override
  String get profileChooseLanguage =>
      'Pilih bahasa yang digunakan pada aplikasi.';

  @override
  String get profileLanguageIndonesian => 'Indonesia';

  @override
  String get profileLanguageIndonesianSubtitle => 'Bahasa Indonesia';

  @override
  String get profileLanguageEnglish => 'English';

  @override
  String get profileLanguageEnglishSubtitle => 'English';

  @override
  String get profileNotifications => 'Pengingat & Notifikasi';

  @override
  String get profileNotificationDescription =>
      'Pilih mode notifikasi yang ingin kamu aktifkan untuk mendukung rutinitas harianmu.';

  @override
  String get profileDailyCheckIn => 'Pengingat Harian (Check-in)';

  @override
  String get profileDailyCheckInDescription =>
      'Pengingat otomatis setiap pagi (09:00) untuk evaluasi tingkat burnout.';

  @override
  String get profileDailyReminderEnabled =>
      'Pengingat harian dijadwalkan setiap 09:00 WIB';

  @override
  String get profileDailyReminderDisabled => 'Pengingat harian dinonaktifkan';

  @override
  String get profileWellbeingMotivation => 'Motivasi Sederhana';

  @override
  String get profileWellbeingMotivationDescription =>
      'Kutipan penyemangat & afirmasi relaksasi setiap siang (14:00).';

  @override
  String get profileMotivationEnabled =>
      'Motivasi harian dijadwalkan setiap 14:00 WIB';

  @override
  String get profileMotivationDisabled => 'Motivasi harian dinonaktifkan';

  @override
  String get profileTestReminder => 'Tes Reminder';

  @override
  String get profileTestMotivation => 'Tes Motivasi';

  @override
  String get profileTestReminderSuccess =>
      'Notifikasi Reminder Harian berhasil dikirim!';

  @override
  String get profileTestMotivationSuccess =>
      'Notifikasi Motivasi berhasil dikirim!';

  @override
  String get profileNotificationTestHint =>
      'Gunakan tombol tes di atas untuk mencoba pratinjau notifikasi secara instan pada perangkat.';

  @override
  String get profileAboutTitle => 'Tentang Aplikasi';

  @override
  String get profileMotto => 'Kenali dirimu. Jaga keseimbanganmu.';

  @override
  String profileVersion(Object version) {
    return 'Versi $version';
  }

  @override
  String get profileAboutHeading => 'Tentang AntiBurnout';

  @override
  String get profileAboutDescription =>
      'AntiBurnout membantu pengguna mengenali kondisi diri melalui asesmen mandiri, melihat riwayat hasil, dan menemukan panduan umum untuk menjaga keseimbangan aktivitas sehari-hari.';

  @override
  String get profileFeatureAssessment => 'Asesmen mandiri';

  @override
  String get profileFeatureAssessmentDescription =>
      'Refleksikan kebiasaan dan kondisi melalui pertanyaan singkat.';

  @override
  String get profileFeatureHistory => 'Riwayat asesmen';

  @override
  String get profileFeatureHistoryDescription =>
      'Telusuri kembali hasil dan ringkasan asesmen sebelumnya.';

  @override
  String get profileFeatureGuidance => 'Panduan keseharian';

  @override
  String get profileFeatureGuidanceDescription =>
      'Temukan ide untuk istirahat, relaksasi, dan dukungan sosial.';

  @override
  String get profileAboutDisclaimer =>
      'Hasil asesmen bukan diagnosis medis. Aplikasi ini tidak menggantikan konsultasi dengan tenaga profesional.';

  @override
  String get profileDevelopedBy => 'Dikembangkan oleh Tim AntiBurnout';

  @override
  String get profileHelpTitle => 'Bantuan';

  @override
  String get profileHelpIntro =>
      'Temukan jawaban tentang penggunaan aplikasi. Ketuk pertanyaan untuk membaca penjelasannya.';

  @override
  String get profileFaqTitle => 'Pertanyaan yang sering diajukan';

  @override
  String get profileFaq1Question => 'Bagaimana cara menggunakan AntiBurnout?';

  @override
  String get profileFaq1Answer =>
      'Mulai dari Beranda untuk melihat ringkasan kondisi dan motivasi harian. Gunakan tab Survei untuk mengisi asesmen, Riwayat untuk membuka hasil sebelumnya, dan Profil untuk mengatur informasi diri.';

  @override
  String get profileFaq2Question => 'Bagaimana cara memulai survei?';

  @override
  String get profileFaq2Answer =>
      'Buka tab Survei atau ketuk Mulai Survei di Beranda. Baca pengantar, lalu pilih jawaban yang paling sesuai dengan kondisimu. Tinjau kembali jawaban sebelum mengirim. Layanan pengiriman dan prediksi masih dalam pengembangan.';

  @override
  String get profileFaq3Question =>
      'Di mana saya bisa melihat hasil sebelumnya?';

  @override
  String get profileFaq3Answer =>
      'Buka tab Riwayat, lalu ketuk salah satu asesmen untuk melihat detailnya. Pencarian dan filter dapat membantu menemukan riwayat. Data yang ditampilkan saat ini merupakan contoh untuk pratinjau UI.';

  @override
  String get profileFaq4Question =>
      'Apakah hasil asesmen merupakan diagnosis medis?';

  @override
  String get profileFaq4Answer =>
      'Tidak. Hasil asesmen bukan diagnosis medis dan tidak menggantikan konsultasi dengan tenaga profesional. Gunakan informasi ini sebagai bahan refleksi untuk lebih mengenali kondisi diri.';

  @override
  String get profileFaq5Question =>
      'Bagaimana membaca faktor dan ringkasan jawaban?';

  @override
  String get profileFaq5Answer =>
      'Faktor dan ringkasan membantu menjelaskan tampilan hasil asesmen. Pada versi pratinjau ini, isinya adalah data statis. Ringkasan jawaban tidak menunjukkan besarnya kontribusi model prediksi.';

  @override
  String get profileFaq6Question => 'Bagaimana cara mengubah nama dan foto?';

  @override
  String get profileFaq6Answer =>
      'Buka Profil, lalu Edit Profil. Ubah nama atau pilih foto dari galeri, kemudian ketuk Simpan Perubahan. Perubahan diingat selama sesi aplikasi dan belum disimpan ke server.';

  @override
  String get profileFaq7Question => 'Bagaimana cara mengubah tema aplikasi?';

  @override
  String get profileFaq7Answer =>
      'Buka Profil, lalu Preferensi. Pilih Terang atau Gelap untuk mengubah tampilan aplikasi, atau Sistem untuk mengikuti tema perangkat. Pengingat masih berupa pratinjau dan belum mengirim notifikasi.';

  @override
  String get profileBackToProfile => 'Kembali ke profil';

  @override
  String get profileBackToHome => 'Kembali ke beranda';

  @override
  String get personalizationTitle => 'Personalisasi Profil';

  @override
  String get personalizationIntroTitle => 'Kenali dirimu lebih dekat';

  @override
  String get personalizationIntroBody =>
      'Isi sekali untuk melengkapi surveimu.\nPerbarui kapan pun kondisimu berubah.';

  @override
  String get personalizationTabPersonal => 'Data Diri';

  @override
  String get personalizationTabActivity => 'Aktivitas';

  @override
  String get personalizationTabAdditional => 'Tambahan';

  @override
  String get personalizationSectionBasic => 'Informasi dasar';

  @override
  String get personalizationSectionActivity => 'Aktivitas & kebiasaan';

  @override
  String get personalizationSectionAdditional => 'Informasi tambahan';

  @override
  String get personalizationSaved => 'Personalisasi profil berhasil disimpan.';

  @override
  String get personalizationUnavailable => 'Personalisasi belum tersedia.';

  @override
  String get personalizationRetry => 'Coba Lagi';

  @override
  String get personalizationContinue => 'Selanjutnya';

  @override
  String get personalizationSave => 'Simpan Personalisasi';

  @override
  String get personalizationPrevious => 'Sebelumnya';

  @override
  String personalizationProgress(int current, int total) {
    return 'Langkah $current dari $total';
  }

  @override
  String get personalizationLoginRequired => 'Silakan masuk terlebih dahulu.';

  @override
  String get personalizationLoadError =>
      'Personalisasi gagal dimuat. Silakan coba lagi.';

  @override
  String get personalizationBirthDateInvalid =>
      'Pilih tanggal lahir antara 1 Januari 1900 dan hari ini.';

  @override
  String get personalizationSaveError =>
      'Personalisasi gagal disimpan. Silakan coba lagi.';

  @override
  String get personalizationTellAboutYou => 'Ceritakan sedikit tentang dirimu.';

  @override
  String get personalizationBirthDate => 'Tanggal Lahir';

  @override
  String get personalizationGender => 'Jenis kelamin';

  @override
  String get personalizationCountry => 'Negara tempat tinggal';

  @override
  String get personalizationSelectCountry => 'Pilih negara';

  @override
  String get personalizationEducation =>
      'Pendidikan terakhir yang diselesaikan';

  @override
  String get personalizationSelectEducation => 'Pilih jenjang pendidikan';

  @override
  String get personalizationGenderFemale => 'Perempuan';

  @override
  String get personalizationGenderMale => 'Laki-laki';

  @override
  String get personalizationOther => 'Lainnya';

  @override
  String get personalizationCountrySingapore => 'Singapura';

  @override
  String get personalizationCountryPhilippines => 'Filipina';

  @override
  String get personalizationEducationPrimary => 'SD / sederajat';

  @override
  String get personalizationEducationJunior => 'SMP / sederajat';

  @override
  String get personalizationEducationSenior => 'SMA / SMK / sederajat';

  @override
  String get personalizationEducationDiploma => 'Diploma';

  @override
  String get personalizationEducationBachelor => 'D4 / S1';

  @override
  String get personalizationEducationMaster => 'S2';

  @override
  String get personalizationEducationDoctorate => 'S3';

  @override
  String get personalizationDateHint => 'Pilih tanggal lahir (DD/MM/YYYY)';

  @override
  String get personalizationRemoveDate => 'Hapus tanggal lahir';

  @override
  String get personalizationSelectDate => 'Pilih tanggal lahir';

  @override
  String get personalizationDateCancel => 'Batal';

  @override
  String get personalizationDateConfirm => 'Pilih';

  @override
  String get personalizationActivityOccupation => 'Pekerjaan / aktivitas utama';

  @override
  String get personalizationSelectOccupation => 'Pilih aktivitas utama';

  @override
  String get personalizationOccupationStudent => 'Pelajar / Mahasiswa';

  @override
  String get personalizationOccupationEmployee => 'Karyawan';

  @override
  String get personalizationOccupationEntrepreneur => 'Wirausaha';

  @override
  String get personalizationOccupationFreelancer => 'Freelancer';

  @override
  String get personalizationOccupationHomemaker => 'Mengurus rumah tangga';

  @override
  String get personalizationOccupationUnemployed => 'Belum bekerja';

  @override
  String get personalizationEmploymentStatus => 'Status pekerjaan';

  @override
  String get personalizationSelectEmploymentStatus => 'Pilih status pekerjaan';

  @override
  String get personalizationEmploymentFullTime => 'Penuh waktu';

  @override
  String get personalizationEmploymentPartTime => 'Paruh waktu';

  @override
  String get personalizationEmploymentContract => 'Kontrak';

  @override
  String get personalizationEmploymentIntern => 'Magang';

  @override
  String get personalizationEmploymentSelfEmployed => 'Bekerja mandiri';

  @override
  String get personalizationEmploymentUnemployed => 'Tidak bekerja';

  @override
  String get personalizationWorkLocation => 'Lokasi kerja';

  @override
  String get personalizationWorkHome => 'Rumah';

  @override
  String get personalizationWorkOffice => 'Kantor';

  @override
  String get personalizationSmoking => 'Apakah kamu merokok?';

  @override
  String get personalizationAlcohol => 'Apakah kamu mengonsumsi alkohol?';

  @override
  String get personalizationYes => 'Ya';

  @override
  String get personalizationNo => 'Tidak';

  @override
  String get personalizationOptionalIntro => 'Isi jika kamu merasa nyaman.';

  @override
  String get personalizationMonthlyIncome => 'Pendapatan bulanan (IDR)';

  @override
  String get personalizationIncomeHint => 'Isi jumlah atau biarkan kosong';

  @override
  String get personalizationFamilyHistory => 'Riwayat kondisi kesehatan mental';

  @override
  String get personalizationFamilyHistoryDescription =>
      'Apakah ada anggota keluarga yang pernah mengalami gangguan kesehatan mental?';

  @override
  String get personalizationProfessionalSupport => 'Dukungan profesional';

  @override
  String get personalizationProfessionalSupportDescription =>
      'Apakah kamu mengikuti terapi atau konseling untuk kesehatan mental?';
}
