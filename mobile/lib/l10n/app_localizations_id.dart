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
}
