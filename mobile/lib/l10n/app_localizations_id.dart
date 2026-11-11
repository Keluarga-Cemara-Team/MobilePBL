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
}
