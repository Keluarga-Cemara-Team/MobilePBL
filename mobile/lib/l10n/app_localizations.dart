import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @dashboardHello.
  ///
  /// In id, this message translates to:
  /// **'Halo,'**
  String get dashboardHello;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Jaga kesehatan mentalmu, mulai dari sekarang.'**
  String get dashboardSubtitle;

  /// No description provided for @openProfile.
  ///
  /// In id, this message translates to:
  /// **'Buka profil'**
  String get openProfile;

  /// No description provided for @latestAssessmentHeading.
  ///
  /// In id, this message translates to:
  /// **'HASIL ASESMEN TERAKHIR'**
  String get latestAssessmentHeading;

  /// No description provided for @startSurvey.
  ///
  /// In id, this message translates to:
  /// **'Mulai Survei'**
  String get startSurvey;

  /// No description provided for @startSurveySubtitle.
  ///
  /// In id, this message translates to:
  /// **'Lakukan asesmen burnout baru'**
  String get startSurveySubtitle;

  /// No description provided for @myHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Saya'**
  String get myHistory;

  /// No description provided for @myHistorySubtitle.
  ///
  /// In id, this message translates to:
  /// **'Lihat hasil asesmen sebelumnya'**
  String get myHistorySubtitle;

  /// No description provided for @latestAssessmentEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada asesmen'**
  String get latestAssessmentEmpty;

  /// No description provided for @startSurveyPrompt.
  ///
  /// In id, this message translates to:
  /// **'Mulai survei untuk mengenali kondisi keseharianmu.'**
  String get startSurveyPrompt;

  /// No description provided for @viewDetails.
  ///
  /// In id, this message translates to:
  /// **'Lihat Detail ›'**
  String get viewDetails;

  /// No description provided for @burnoutRisk.
  ///
  /// In id, this message translates to:
  /// **'Risiko Burnout'**
  String get burnoutRisk;

  /// No description provided for @riskLow.
  ///
  /// In id, this message translates to:
  /// **'Rendah'**
  String get riskLow;

  /// No description provided for @riskMedium.
  ///
  /// In id, this message translates to:
  /// **'Sedang'**
  String get riskMedium;

  /// No description provided for @riskHigh.
  ///
  /// In id, this message translates to:
  /// **'Tinggi'**
  String get riskHigh;

  /// No description provided for @motivationTitle.
  ///
  /// In id, this message translates to:
  /// **'Motivasi Hari Ini'**
  String get motivationTitle;

  /// No description provided for @riskStatisticsTitle.
  ///
  /// In id, this message translates to:
  /// **'Statistik Risiko'**
  String get riskStatisticsTitle;

  /// No description provided for @assessmentHistorySummary.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan seluruh riwayat survei'**
  String get assessmentHistorySummary;

  /// No description provided for @samplePreview.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau dengan data contoh'**
  String get samplePreview;

  /// No description provided for @includesSampleData.
  ///
  /// In id, this message translates to:
  /// **'Termasuk data contoh'**
  String get includesSampleData;

  /// No description provided for @assessmentsTotal.
  ///
  /// In id, this message translates to:
  /// **'{count, plural, =0{Belum ada asesmen} =1{1 asesmen secara keseluruhan} other{{count} asesmen secara keseluruhan}}'**
  String assessmentsTotal(num count);

  /// No description provided for @lastSevenDaysChart.
  ///
  /// In id, this message translates to:
  /// **'Grafik 7 hari terakhir'**
  String get lastSevenDaysChart;

  /// No description provided for @weeklyEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada survei dalam 7 hari terakhir.'**
  String get weeklyEmpty;

  /// No description provided for @weeklyBarDescription.
  ///
  /// In id, this message translates to:
  /// **'Setiap batang mewakili satu survei. Ketuk untuk melihat risikonya.'**
  String get weeklyBarDescription;

  /// No description provided for @weeklyChartOrderNote.
  ///
  /// In id, this message translates to:
  /// **'Urutan dari baru ke lama. Tinggi batang menunjukkan kategori risiko, bukan skor medis.'**
  String get weeklyChartOrderNote;

  /// No description provided for @swipeForDates.
  ///
  /// In id, this message translates to:
  /// **'Geser untuk melihat tanggal lainnya.'**
  String get swipeForDates;

  /// No description provided for @dayAssessmentCount.
  ///
  /// In id, this message translates to:
  /// **'{count, plural, =0{Tidak ada survei} =1{1 survei} other{{count} survei}}'**
  String dayAssessmentCount(num count);

  /// No description provided for @emptyDateSemantics.
  ///
  /// In id, this message translates to:
  /// **'{date}, belum ada survei'**
  String emptyDateSemantics(Object date);

  /// No description provided for @riskTooltip.
  ///
  /// In id, this message translates to:
  /// **'{risk} · {time}'**
  String riskTooltip(Object risk, Object time);

  /// No description provided for @riskSemantics.
  ///
  /// In id, this message translates to:
  /// **'{date}, risiko {risk}'**
  String riskSemantics(Object date, Object risk);

  /// No description provided for @weekRange.
  ///
  /// In id, this message translates to:
  /// **'{start} – {end}'**
  String weekRange(Object end, Object start);

  /// No description provided for @motivation01.
  ///
  /// In id, this message translates to:
  /// **'Tidur yang cukup membantu menjaga kesehatan mental dan produktivitasmu.'**
  String get motivation01;

  /// No description provided for @motivation02.
  ///
  /// In id, this message translates to:
  /// **'Langkah kecil hari ini tetap berarti. Kamu boleh bergerak sesuai kemampuanmu.'**
  String get motivation02;

  /// No description provided for @motivation03.
  ///
  /// In id, this message translates to:
  /// **'Beristirahat sejenak memberi ruang untuk memulai kembali.'**
  String get motivation03;

  /// No description provided for @motivation04.
  ///
  /// In id, this message translates to:
  /// **'Tidak semuanya perlu selesai sekaligus. Mulailah dari satu hal yang paling penting.'**
  String get motivation04;

  /// No description provided for @motivation05.
  ///
  /// In id, this message translates to:
  /// **'Beri apresiasi pada dirimu atas usaha yang sudah kamu lakukan hari ini.'**
  String get motivation05;

  /// No description provided for @motivation06.
  ///
  /// In id, this message translates to:
  /// **'Di sela kesibukan, sisihkan sedikit waktu untuk hal yang kamu nikmati.'**
  String get motivation06;

  /// No description provided for @motivation07.
  ///
  /// In id, this message translates to:
  /// **'Saat merasa kewalahan, kamu boleh meminta bantuan orang yang kamu percaya.'**
  String get motivation07;

  /// No description provided for @motivation08.
  ///
  /// In id, this message translates to:
  /// **'Berikan dirimu izin untuk berhenti sejenak dan mengatur ulang prioritas.'**
  String get motivation08;

  /// No description provided for @motivation09.
  ///
  /// In id, this message translates to:
  /// **'Hari yang berat tidak menghapus kemajuan yang sudah kamu buat.'**
  String get motivation09;

  /// No description provided for @motivation10.
  ///
  /// In id, this message translates to:
  /// **'Kamu boleh menetapkan batas ketika tenaga dan waktumu sedang terbatas.'**
  String get motivation10;

  /// No description provided for @motivation11.
  ///
  /// In id, this message translates to:
  /// **'Luangkan waktu untuk terhubung dengan orang yang membuatmu merasa didengar.'**
  String get motivation11;

  /// No description provided for @motivation12.
  ///
  /// In id, this message translates to:
  /// **'Mulai lagi dengan satu langkah kecil. Tidak semuanya harus sempurna.'**
  String get motivation12;

  /// No description provided for @mondayShort.
  ///
  /// In id, this message translates to:
  /// **'Sen'**
  String get mondayShort;

  /// No description provided for @tuesdayShort.
  ///
  /// In id, this message translates to:
  /// **'Sel'**
  String get tuesdayShort;

  /// No description provided for @wednesdayShort.
  ///
  /// In id, this message translates to:
  /// **'Rab'**
  String get wednesdayShort;

  /// No description provided for @thursdayShort.
  ///
  /// In id, this message translates to:
  /// **'Kam'**
  String get thursdayShort;

  /// No description provided for @fridayShort.
  ///
  /// In id, this message translates to:
  /// **'Jum'**
  String get fridayShort;

  /// No description provided for @saturdayShort.
  ///
  /// In id, this message translates to:
  /// **'Sab'**
  String get saturdayShort;

  /// No description provided for @sundayShort.
  ///
  /// In id, this message translates to:
  /// **'Min'**
  String get sundayShort;

  /// No description provided for @surveyTitle.
  ///
  /// In id, this message translates to:
  /// **'Survei Harian'**
  String get surveyTitle;

  /// No description provided for @surveyIntroTime.
  ///
  /// In id, this message translates to:
  /// **'Waktu untuk dirimu · 3–5 menit'**
  String get surveyIntroTime;

  /// No description provided for @surveyIntroQuestion.
  ///
  /// In id, this message translates to:
  /// **'Bagaimana harimu?'**
  String get surveyIntroQuestion;

  /// No description provided for @surveyIntroBody.
  ///
  /// In id, this message translates to:
  /// **'Luangkan waktu sejenak untuk mengenali aktivitas, kebiasaan, dan perasaanmu hari ini.'**
  String get surveyIntroBody;

  /// No description provided for @surveyIntroBenefitTitle.
  ///
  /// In id, this message translates to:
  /// **'Langkah kecil, manfaat berarti'**
  String get surveyIntroBenefitTitle;

  /// No description provided for @surveyIntroSimpleTitle.
  ///
  /// In id, this message translates to:
  /// **'Pertanyaan sederhana'**
  String get surveyIntroSimpleTitle;

  /// No description provided for @surveyIntroSimpleBody.
  ///
  /// In id, this message translates to:
  /// **'Ceritakan aktivitas dan kebiasaan harianmu.'**
  String get surveyIntroSimpleBody;

  /// No description provided for @surveyIntroPatternTitle.
  ///
  /// In id, this message translates to:
  /// **'Kenali pola keseharianmu'**
  String get surveyIntroPatternTitle;

  /// No description provided for @surveyIntroPatternBody.
  ///
  /// In id, this message translates to:
  /// **'Bantu refleksi dan pantau kesejahteraanmu.'**
  String get surveyIntroPatternBody;

  /// No description provided for @surveyIntroDisclaimer.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada jawaban benar atau salah. Jawab sesuai kondisi yang kamu rasakan.'**
  String get surveyIntroDisclaimer;

  /// No description provided for @surveyStart.
  ///
  /// In id, this message translates to:
  /// **'Mulai Survei'**
  String get surveyStart;

  /// No description provided for @surveyBackToIntro.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke pengantar survei'**
  String get surveyBackToIntro;

  /// No description provided for @surveyUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Survei belum tersedia'**
  String get surveyUnavailable;

  /// No description provided for @surveyLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Survei gagal dimuat'**
  String get surveyLoadFailed;

  /// No description provided for @surveyUnavailableBody.
  ///
  /// In id, this message translates to:
  /// **'Pertanyaan dan layanan asesmen belum tersedia. Silakan kembali lagi nanti.'**
  String get surveyUnavailableBody;

  /// No description provided for @surveyRetry.
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get surveyRetry;

  /// No description provided for @surveyBackToIntroButton.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke Pengantar'**
  String get surveyBackToIntroButton;

  /// No description provided for @surveyAnswerPrompt.
  ///
  /// In id, this message translates to:
  /// **'Jawab sesuai kondisi yang kamu rasakan.'**
  String get surveyAnswerPrompt;

  /// No description provided for @surveySubmitAnswers.
  ///
  /// In id, this message translates to:
  /// **'Kirim Jawaban'**
  String get surveySubmitAnswers;

  /// No description provided for @surveyWriteAnswer.
  ///
  /// In id, this message translates to:
  /// **'Tulis jawabanmu'**
  String get surveyWriteAnswer;

  /// No description provided for @surveyReviewTitle.
  ///
  /// In id, this message translates to:
  /// **'Periksa jawabanmu'**
  String get surveyReviewTitle;

  /// No description provided for @surveyReviewSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pastikan jawaban sesuai sebelum dikirim.'**
  String get surveyReviewSubtitle;

  /// No description provided for @surveyReviewTip.
  ///
  /// In id, this message translates to:
  /// **'Hasil merupakan estimasi risiko, bukan diagnosis.'**
  String get surveyReviewTip;

  /// Step number and total number of survey steps
  ///
  /// In id, this message translates to:
  /// **'Langkah {current} dari {total}'**
  String surveyStepLabel(int current, int total);

  /// No description provided for @surveyBack.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get surveyBack;

  /// No description provided for @surveyContinue.
  ///
  /// In id, this message translates to:
  /// **'Lanjut'**
  String get surveyContinue;

  /// No description provided for @surveySubmitViewResults.
  ///
  /// In id, this message translates to:
  /// **'Kirim & lihat hasil'**
  String get surveySubmitViewResults;

  /// No description provided for @surveyEditAnswer.
  ///
  /// In id, this message translates to:
  /// **'Ubah'**
  String get surveyEditAnswer;

  /// No description provided for @surveyActivityEasy.
  ///
  /// In id, this message translates to:
  /// **'Aktivitas terasa mudah dihadapi'**
  String get surveyActivityEasy;

  /// No description provided for @surveyActivityOverwhelming.
  ///
  /// In id, this message translates to:
  /// **'Terasa terbebani, tetapi masih teratasi'**
  String get surveyActivityOverwhelming;

  /// No description provided for @surveyActivityDifficult.
  ///
  /// In id, this message translates to:
  /// **'Beban terasa sulit dihadapi'**
  String get surveyActivityDifficult;

  /// No description provided for @surveyZeroHours.
  ///
  /// In id, this message translates to:
  /// **'0 jam'**
  String get surveyZeroHours;

  /// Maximum duration for the current question in hours
  ///
  /// In id, this message translates to:
  /// **'{hours} jam'**
  String surveyMaximumHours(int hours);

  /// No description provided for @surveyOutOf100.
  ///
  /// In id, this message translates to:
  /// **'dari 100'**
  String get surveyOutOf100;

  /// No description provided for @surveyVeryUncomfortable.
  ///
  /// In id, this message translates to:
  /// **'Sangat tidak nyaman'**
  String get surveyVeryUncomfortable;

  /// No description provided for @surveyVeryComfortable.
  ///
  /// In id, this message translates to:
  /// **'Sangat nyaman'**
  String get surveyVeryComfortable;

  /// No description provided for @surveyOwnDuration.
  ///
  /// In id, this message translates to:
  /// **'Atau isi durasi sendiri'**
  String get surveyOwnDuration;

  /// No description provided for @surveyUnitHours.
  ///
  /// In id, this message translates to:
  /// **'jam'**
  String get surveyUnitHours;

  /// No description provided for @surveyUnitCups.
  ///
  /// In id, this message translates to:
  /// **'cangkir'**
  String get surveyUnitCups;

  /// No description provided for @surveyUnitMinutes.
  ///
  /// In id, this message translates to:
  /// **'menit'**
  String get surveyUnitMinutes;

  /// No description provided for @surveyMinutesValidation.
  ///
  /// In id, this message translates to:
  /// **'Masukkan jumlah menit berupa bilangan bulat 0 atau lebih.'**
  String get surveyMinutesValidation;

  /// No description provided for @surveyErrorLoadQuestions.
  ///
  /// In id, this message translates to:
  /// **'Pertanyaan survei gagal dimuat. Coba lagi.'**
  String get surveyErrorLoadQuestions;

  /// No description provided for @surveyErrorServiceUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Layanan asesmen belum tersedia. Jawaban belum dikirim.'**
  String get surveyErrorServiceUnavailable;

  /// No description provided for @surveyErrorSubmit.
  ///
  /// In id, this message translates to:
  /// **'Jawaban gagal dikirim. Coba lagi.'**
  String get surveyErrorSubmit;

  /// No description provided for @sleepQualityLabel.
  ///
  /// In id, this message translates to:
  /// **'Bagaimana kualitas tidurmu\ntadi malam?'**
  String get sleepQualityLabel;

  /// No description provided for @sleepQualitySubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih kualitas tidur yang paling sesuai.'**
  String get sleepQualitySubtitle;

  /// No description provided for @sleepQualityTip.
  ///
  /// In id, this message translates to:
  /// **'Durasi dan kualitas tidur adalah dua hal berbeda.'**
  String get sleepQualityTip;

  /// No description provided for @sleepQualityReview.
  ///
  /// In id, this message translates to:
  /// **'Kualitas tidur'**
  String get sleepQualityReview;

  /// No description provided for @sleepPoor.
  ///
  /// In id, this message translates to:
  /// **'Buruk'**
  String get sleepPoor;

  /// No description provided for @sleepFair.
  ///
  /// In id, this message translates to:
  /// **'Cukup'**
  String get sleepFair;

  /// No description provided for @sleepGood.
  ///
  /// In id, this message translates to:
  /// **'Baik'**
  String get sleepGood;

  /// No description provided for @sleepVeryGood.
  ///
  /// In id, this message translates to:
  /// **'Sangat baik'**
  String get sleepVeryGood;

  /// No description provided for @screenTimeLabel.
  ///
  /// In id, this message translates to:
  /// **'Berapa lama kamu menggunakan\nlayar hari ini?'**
  String get screenTimeLabel;

  /// No description provided for @screenTimeSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Hitung penggunaan HP, laptop, dan TV.'**
  String get screenTimeSubtitle;

  /// No description provided for @screenTimeTip.
  ///
  /// In id, this message translates to:
  /// **'Beri jeda dari layar untuk mengistirahatkan mata dan pikiran.'**
  String get screenTimeTip;

  /// No description provided for @screenTimeReview.
  ///
  /// In id, this message translates to:
  /// **'Waktu layar'**
  String get screenTimeReview;

  /// No description provided for @sleepDurationLabel.
  ///
  /// In id, this message translates to:
  /// **'Berapa lama durasi tidur Anda\nhari ini?'**
  String get sleepDurationLabel;

  /// No description provided for @sleepDurationSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Geser slider atau gunakan tombol untuk menentukan durasi tidur.'**
  String get sleepDurationSubtitle;

  /// No description provided for @sleepDurationTip.
  ///
  /// In id, this message translates to:
  /// **'Tidur yang cukup membantu menjaga kesehatan mental dan produktivitasmu.'**
  String get sleepDurationTip;

  /// No description provided for @sleepDurationReview.
  ///
  /// In id, this message translates to:
  /// **'Durasi tidur'**
  String get sleepDurationReview;

  /// No description provided for @coffeeLabel.
  ///
  /// In id, this message translates to:
  /// **'Berapa cangkir kopi yang kamu\nminum hari ini?'**
  String get coffeeLabel;

  /// No description provided for @coffeeSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Gunakan tombol untuk menambah atau mengurangi jumlah.'**
  String get coffeeSubtitle;

  /// No description provided for @coffeeTip.
  ///
  /// In id, this message translates to:
  /// **'Kafein secukupnya memberi energi, namun berlebihan bisa memicu kecemasan.'**
  String get coffeeTip;

  /// No description provided for @coffeeReview.
  ///
  /// In id, this message translates to:
  /// **'Kopi'**
  String get coffeeReview;

  /// No description provided for @workloadLabel.
  ///
  /// In id, this message translates to:
  /// **'Seberapa terbebani kamu oleh\naktivitas hari ini?'**
  String get workloadLabel;

  /// No description provided for @workloadSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih kondisi yang paling mendekati perasaanmu.'**
  String get workloadSubtitle;

  /// No description provided for @workloadTip.
  ///
  /// In id, this message translates to:
  /// **'Menyeimbangkan aktivitas harian sangat penting untuk kesehatan fisik dan mentalmu.'**
  String get workloadTip;

  /// No description provided for @workloadReview.
  ///
  /// In id, this message translates to:
  /// **'Stres'**
  String get workloadReview;

  /// No description provided for @workloadLight.
  ///
  /// In id, this message translates to:
  /// **'Ringan'**
  String get workloadLight;

  /// No description provided for @workloadModerate.
  ///
  /// In id, this message translates to:
  /// **'Sedang'**
  String get workloadModerate;

  /// No description provided for @workloadHeavy.
  ///
  /// In id, this message translates to:
  /// **'Berat'**
  String get workloadHeavy;

  /// No description provided for @meditationLabel.
  ///
  /// In id, this message translates to:
  /// **'Berapa menit kamu melakukan\nmeditasi hari ini?'**
  String get meditationLabel;

  /// No description provided for @meditationSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih durasi atau isi dengan angka sendiri.'**
  String get meditationSubtitle;

  /// No description provided for @meditationTip.
  ///
  /// In id, this message translates to:
  /// **'Cuma butuh 15 menit meditasi buat recharge energi dan jernihin pikiran.'**
  String get meditationTip;

  /// No description provided for @meditationReview.
  ///
  /// In id, this message translates to:
  /// **'Meditasi'**
  String get meditationReview;

  /// No description provided for @moodLabel.
  ///
  /// In id, this message translates to:
  /// **'Berapa rating secara keseluruhan\nhari ini?'**
  String get moodLabel;

  /// No description provided for @moodSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Geser slider untuk menentukan nilai.'**
  String get moodSubtitle;

  /// No description provided for @moodTip.
  ///
  /// In id, this message translates to:
  /// **'Refleksi singkat di akhir hari membantu mengenali apa yang membuatmu stres atau bahagia.'**
  String get moodTip;

  /// No description provided for @moodReview.
  ///
  /// In id, this message translates to:
  /// **'Suasana hati'**
  String get moodReview;

  /// No description provided for @historyTitle.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Survei'**
  String get historyTitle;

  /// No description provided for @historyDescription.
  ///
  /// In id, this message translates to:
  /// **'Hasil asesmen burnout sebelumnya.'**
  String get historyDescription;

  /// No description provided for @historySearchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari riwayat...'**
  String get historySearchHint;

  /// No description provided for @historyFilterAll.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get historyFilterAll;

  /// No description provided for @historyEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada riwayat pemeriksaan.'**
  String get historyEmpty;

  /// No description provided for @historyNoResults.
  ///
  /// In id, this message translates to:
  /// **'Riwayat tidak ditemukan.'**
  String get historyNoResults;

  /// No description provided for @historyLoadError.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat riwayat. Coba lagi.'**
  String get historyLoadError;

  /// No description provided for @historyRetry.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get historyRetry;

  /// No description provided for @historyLatest.
  ///
  /// In id, this message translates to:
  /// **'Hasil asesmen terbaru'**
  String get historyLatest;

  /// No description provided for @historyPrevious.
  ///
  /// In id, this message translates to:
  /// **'Hasil asesmen sebelumnya'**
  String get historyPrevious;

  /// No description provided for @historyRiskTitle.
  ///
  /// In id, this message translates to:
  /// **'Risiko Burnout'**
  String get historyRiskTitle;

  /// No description provided for @historyDetails.
  ///
  /// In id, this message translates to:
  /// **'Detail'**
  String get historyDetails;

  /// No description provided for @resultTitle.
  ///
  /// In id, this message translates to:
  /// **'Hasil Prediksi'**
  String get resultTitle;

  /// No description provided for @resultLoadError.
  ///
  /// In id, this message translates to:
  /// **'Hasil asesmen belum dapat dimuat.'**
  String get resultLoadError;

  /// No description provided for @resultNotFound.
  ///
  /// In id, this message translates to:
  /// **'Hasil asesmen tidak ditemukan. Buka hasil dari riwayat atau selesaikan survei terlebih dahulu.'**
  String get resultNotFound;

  /// No description provided for @resultDescription.
  ///
  /// In id, this message translates to:
  /// **'Hasil asesmen menunjukkan indikasi risiko burnout pada tingkat {risk}.'**
  String resultDescription(Object risk);

  /// No description provided for @resultAssessmentDate.
  ///
  /// In id, this message translates to:
  /// **'Asesmen {date}'**
  String resultAssessmentDate(Object date);

  /// No description provided for @resultDisclaimer.
  ///
  /// In id, this message translates to:
  /// **'Ini bukan diagnosis medis, tetapi indikasi awal yang dapat membantumu lebih memahami kondisi diri.'**
  String get resultDisclaimer;

  /// No description provided for @resultSampleData.
  ///
  /// In id, this message translates to:
  /// **'Data contoh'**
  String get resultSampleData;

  /// No description provided for @resultFactorsTitle.
  ///
  /// In id, this message translates to:
  /// **'Faktor yang Mempengaruhi'**
  String get resultFactorsTitle;

  /// No description provided for @resultFactorsUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Faktor dari model belum tersedia untuk asesmen ini.'**
  String get resultFactorsUnavailable;

  /// No description provided for @resultExampleFactorsCaption.
  ///
  /// In id, this message translates to:
  /// **'Faktor pada contoh hasil asesmen ini.'**
  String get resultExampleFactorsCaption;

  /// No description provided for @resultModelFactorsCaption.
  ///
  /// In id, this message translates to:
  /// **'Faktor yang disertakan dalam hasil model untuk asesmen ini.'**
  String get resultModelFactorsCaption;

  /// No description provided for @resultAnswerSummaryTitle.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan Jawaban'**
  String get resultAnswerSummaryTitle;

  /// No description provided for @resultExampleAnswersCaption.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan jawaban pada contoh asesmen ini.'**
  String get resultExampleAnswersCaption;

  /// No description provided for @resultAnswersCaption.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan jawaban survei, bukan kontribusi model prediksi.'**
  String get resultAnswersCaption;

  /// No description provided for @resultAnswersUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan jawaban belum tersedia.'**
  String get resultAnswersUnavailable;

  /// No description provided for @resultRecommendation.
  ///
  /// In id, this message translates to:
  /// **'Lihat Rekomendasi'**
  String get resultRecommendation;

  /// No description provided for @resultRiskLevel.
  ///
  /// In id, this message translates to:
  /// **'Tingkat Risiko'**
  String get resultRiskLevel;

  /// No description provided for @resultRiskBurnout.
  ///
  /// In id, this message translates to:
  /// **'Risiko Burnout'**
  String get resultRiskBurnout;

  /// No description provided for @resultStressLabel.
  ///
  /// In id, this message translates to:
  /// **'Tingkat stres'**
  String get resultStressLabel;

  /// No description provided for @resultRiskSemantics.
  ///
  /// In id, this message translates to:
  /// **'Tingkat risiko burnout: {risk}'**
  String resultRiskSemantics(Object risk);

  /// No description provided for @resultExampleFactorSleep.
  ///
  /// In id, this message translates to:
  /// **'Durasi tidur kurang stabil'**
  String get resultExampleFactorSleep;

  /// No description provided for @resultExampleFactorActivity.
  ///
  /// In id, this message translates to:
  /// **'Beban aktivitas cukup tinggi'**
  String get resultExampleFactorActivity;

  /// No description provided for @resultExampleFactorStress.
  ///
  /// In id, this message translates to:
  /// **'Tingkat stres yang meningkat'**
  String get resultExampleFactorStress;

  /// No description provided for @resultFactorSleepSuboptimal.
  ///
  /// In id, this message translates to:
  /// **'Durasi tidur kurang optimal ({hours} jam)'**
  String resultFactorSleepSuboptimal(Object hours);

  /// No description provided for @resultFactorActivityStressHigh.
  ///
  /// In id, this message translates to:
  /// **'Beban aktivitas dan stres harian tinggi'**
  String get resultFactorActivityStressHigh;

  /// No description provided for @resultFactorScreenIntensive.
  ///
  /// In id, this message translates to:
  /// **'Paparan layar intensif ({hours} jam)'**
  String resultFactorScreenIntensive(Object hours);

  /// No description provided for @resultFactorCoffeeHigh.
  ///
  /// In id, this message translates to:
  /// **'Konsumsi kafein tinggi ({cups} cangkir)'**
  String resultFactorCoffeeHigh(Object cups);

  /// No description provided for @resultFactorCoffeeModerateHigh.
  ///
  /// In id, this message translates to:
  /// **'Konsumsi kafein cukup tinggi ({cups} cangkir)'**
  String resultFactorCoffeeModerateHigh(Object cups);

  /// No description provided for @resultFactorMeditationPositive.
  ///
  /// In id, this message translates to:
  /// **'Praktik relaksasi / meditasi sangat baik'**
  String get resultFactorMeditationPositive;

  /// No description provided for @resultFactorBalancedActivityRest.
  ///
  /// In id, this message translates to:
  /// **'Aktivitas dan pola istirahat seimbang'**
  String get resultFactorBalancedActivityRest;

  /// No description provided for @resultFactorStressHigh.
  ///
  /// In id, this message translates to:
  /// **'Tingkat stres tergolong tinggi'**
  String get resultFactorStressHigh;

  /// No description provided for @resultFactorSleepLow.
  ///
  /// In id, this message translates to:
  /// **'Durasi tidur kurang ({hours} jam)'**
  String resultFactorSleepLow(Object hours);

  /// No description provided for @resultFactorScreenHigh.
  ///
  /// In id, this message translates to:
  /// **'Waktu layar cukup tinggi ({hours} jam)'**
  String resultFactorScreenHigh(Object hours);

  /// No description provided for @resultFactorRestWorkBalanced.
  ///
  /// In id, this message translates to:
  /// **'Pola istirahat dan beban kerja terkendali'**
  String get resultFactorRestWorkBalanced;

  /// No description provided for @resultFactorFatigueRhythm.
  ///
  /// In id, this message translates to:
  /// **'Evaluasi kelelahan kerja & ritme harian'**
  String get resultFactorFatigueRhythm;

  /// No description provided for @resultFactorRestStressAnalysis.
  ///
  /// In id, this message translates to:
  /// **'Analisis waktu istirahat dan stres'**
  String get resultFactorRestStressAnalysis;

  /// No description provided for @navHome.
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get navHome;

  /// No description provided for @navSurvey.
  ///
  /// In id, this message translates to:
  /// **'Survei'**
  String get navSurvey;

  /// No description provided for @navHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat'**
  String get navHistory;

  /// No description provided for @navProfile.
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @userAvatarSemantics.
  ///
  /// In id, this message translates to:
  /// **'Avatar pengguna'**
  String get userAvatarSemantics;

  /// No description provided for @profileTitle.
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get profileTitle;

  /// No description provided for @profileEdit.
  ///
  /// In id, this message translates to:
  /// **'Edit Profil'**
  String get profileEdit;

  /// No description provided for @profilePersonalization.
  ///
  /// In id, this message translates to:
  /// **'Personalisasi Profil'**
  String get profilePersonalization;

  /// No description provided for @profilePreferences.
  ///
  /// In id, this message translates to:
  /// **'Preferensi'**
  String get profilePreferences;

  /// No description provided for @profileHelp.
  ///
  /// In id, this message translates to:
  /// **'Bantuan'**
  String get profileHelp;

  /// No description provided for @profileAbout.
  ///
  /// In id, this message translates to:
  /// **'Tentang Aplikasi'**
  String get profileAbout;

  /// No description provided for @profileLogout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get profileLogout;

  /// No description provided for @profileLogoutError.
  ///
  /// In id, this message translates to:
  /// **'Gagal keluar. Silakan coba lagi.'**
  String get profileLogoutError;

  /// No description provided for @profileDefaultUser.
  ///
  /// In id, this message translates to:
  /// **'Pengguna'**
  String get profileDefaultUser;

  /// No description provided for @profileEditTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Profil'**
  String get profileEditTitle;

  /// No description provided for @profileChangePhoto.
  ///
  /// In id, this message translates to:
  /// **'Ubah Foto'**
  String get profileChangePhoto;

  /// No description provided for @profileOpeningGallery.
  ///
  /// In id, this message translates to:
  /// **'Membuka galeri...'**
  String get profileOpeningGallery;

  /// No description provided for @profileUseDefaultAvatar.
  ///
  /// In id, this message translates to:
  /// **'Gunakan avatar bawaan'**
  String get profileUseDefaultAvatar;

  /// No description provided for @profilePhotoError.
  ///
  /// In id, this message translates to:
  /// **'Foto belum dapat dibuka. Izinkan akses galeri atau coba foto lain.'**
  String get profilePhotoError;

  /// No description provided for @profileName.
  ///
  /// In id, this message translates to:
  /// **'Nama'**
  String get profileName;

  /// No description provided for @profileNameHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan nama kamu'**
  String get profileNameHint;

  /// No description provided for @profileNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama tidak boleh kosong.'**
  String get profileNameRequired;

  /// No description provided for @profileEmail.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profileEmailCannotChange.
  ///
  /// In id, this message translates to:
  /// **'Email tidak dapat diubah.'**
  String get profileEmailCannotChange;

  /// No description provided for @profileNamePhotoSync.
  ///
  /// In id, this message translates to:
  /// **'Nama dan foto profil disinkronkan secara aman ke akun Anda.'**
  String get profileNamePhotoSync;

  /// No description provided for @profileSaveChanges.
  ///
  /// In id, this message translates to:
  /// **'Simpan Perubahan'**
  String get profileSaveChanges;

  /// No description provided for @profileCancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get profileCancel;

  /// No description provided for @profileSaved.
  ///
  /// In id, this message translates to:
  /// **'Profil berhasil diperbarui dan disimpan.'**
  String get profileSaved;

  /// No description provided for @profilePreferencesIntro.
  ///
  /// In id, this message translates to:
  /// **'Sesuaikan tampilan tema, bahasa, serta jadwal pengingat check-in harian dan motivasi untuk mendukung kesehatan mentalmu.'**
  String get profilePreferencesIntro;

  /// No description provided for @profileAppearance.
  ///
  /// In id, this message translates to:
  /// **'Tampilan'**
  String get profileAppearance;

  /// No description provided for @profileChooseTheme.
  ///
  /// In id, this message translates to:
  /// **'Pilih tema yang paling nyaman untukmu.'**
  String get profileChooseTheme;

  /// No description provided for @profileThemeLight.
  ///
  /// In id, this message translates to:
  /// **'Terang'**
  String get profileThemeLight;

  /// No description provided for @profileThemeDark.
  ///
  /// In id, this message translates to:
  /// **'Gelap'**
  String get profileThemeDark;

  /// No description provided for @profileThemeSystem.
  ///
  /// In id, this message translates to:
  /// **'Sistem'**
  String get profileThemeSystem;

  /// No description provided for @profileLanguageTitle.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get profileLanguageTitle;

  /// No description provided for @profileChooseLanguage.
  ///
  /// In id, this message translates to:
  /// **'Pilih bahasa yang digunakan pada aplikasi.'**
  String get profileChooseLanguage;

  /// No description provided for @profileLanguageIndonesian.
  ///
  /// In id, this message translates to:
  /// **'Indonesia'**
  String get profileLanguageIndonesian;

  /// No description provided for @profileLanguageIndonesianSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Bahasa Indonesia'**
  String get profileLanguageIndonesianSubtitle;

  /// No description provided for @profileLanguageEnglish.
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get profileLanguageEnglish;

  /// No description provided for @profileLanguageEnglishSubtitle.
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get profileLanguageEnglishSubtitle;

  /// No description provided for @profileNotifications.
  ///
  /// In id, this message translates to:
  /// **'Pengingat & Notifikasi'**
  String get profileNotifications;

  /// No description provided for @profileNotificationDescription.
  ///
  /// In id, this message translates to:
  /// **'Pilih mode notifikasi yang ingin kamu aktifkan untuk mendukung rutinitas harianmu.'**
  String get profileNotificationDescription;

  /// No description provided for @profileDailyCheckIn.
  ///
  /// In id, this message translates to:
  /// **'Pengingat Harian (Check-in)'**
  String get profileDailyCheckIn;

  /// No description provided for @profileDailyCheckInDescription.
  ///
  /// In id, this message translates to:
  /// **'Pengingat otomatis setiap pagi (09:00) untuk evaluasi tingkat burnout.'**
  String get profileDailyCheckInDescription;

  /// No description provided for @profileDailyReminderEnabled.
  ///
  /// In id, this message translates to:
  /// **'Pengingat harian dijadwalkan setiap 09:00 WIB'**
  String get profileDailyReminderEnabled;

  /// No description provided for @profileDailyReminderDisabled.
  ///
  /// In id, this message translates to:
  /// **'Pengingat harian dinonaktifkan'**
  String get profileDailyReminderDisabled;

  /// No description provided for @profileWellbeingMotivation.
  ///
  /// In id, this message translates to:
  /// **'Motivasi Sederhana'**
  String get profileWellbeingMotivation;

  /// No description provided for @profileWellbeingMotivationDescription.
  ///
  /// In id, this message translates to:
  /// **'Kutipan penyemangat & afirmasi relaksasi setiap siang (14:00).'**
  String get profileWellbeingMotivationDescription;

  /// No description provided for @profileMotivationEnabled.
  ///
  /// In id, this message translates to:
  /// **'Motivasi harian dijadwalkan setiap 14:00 WIB'**
  String get profileMotivationEnabled;

  /// No description provided for @profileMotivationDisabled.
  ///
  /// In id, this message translates to:
  /// **'Motivasi harian dinonaktifkan'**
  String get profileMotivationDisabled;

  /// No description provided for @profileTestReminder.
  ///
  /// In id, this message translates to:
  /// **'Tes Reminder'**
  String get profileTestReminder;

  /// No description provided for @profileTestMotivation.
  ///
  /// In id, this message translates to:
  /// **'Tes Motivasi'**
  String get profileTestMotivation;

  /// No description provided for @profileTestReminderSuccess.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi Reminder Harian berhasil dikirim!'**
  String get profileTestReminderSuccess;

  /// No description provided for @profileTestMotivationSuccess.
  ///
  /// In id, this message translates to:
  /// **'Notifikasi Motivasi berhasil dikirim!'**
  String get profileTestMotivationSuccess;

  /// No description provided for @profileNotificationTestHint.
  ///
  /// In id, this message translates to:
  /// **'Gunakan tombol tes di atas untuk mencoba pratinjau notifikasi secara instan pada perangkat.'**
  String get profileNotificationTestHint;

  /// No description provided for @profileAboutTitle.
  ///
  /// In id, this message translates to:
  /// **'Tentang Aplikasi'**
  String get profileAboutTitle;

  /// No description provided for @profileMotto.
  ///
  /// In id, this message translates to:
  /// **'Kenali dirimu. Jaga keseimbanganmu.'**
  String get profileMotto;

  /// No description provided for @profileVersion.
  ///
  /// In id, this message translates to:
  /// **'Versi {version}'**
  String profileVersion(Object version);

  /// No description provided for @profileAboutHeading.
  ///
  /// In id, this message translates to:
  /// **'Tentang AntiBurnout'**
  String get profileAboutHeading;

  /// No description provided for @profileAboutDescription.
  ///
  /// In id, this message translates to:
  /// **'AntiBurnout membantu pengguna mengenali kondisi diri melalui asesmen mandiri, melihat riwayat hasil, dan menemukan panduan umum untuk menjaga keseimbangan aktivitas sehari-hari.'**
  String get profileAboutDescription;

  /// No description provided for @profileFeatureAssessment.
  ///
  /// In id, this message translates to:
  /// **'Asesmen mandiri'**
  String get profileFeatureAssessment;

  /// No description provided for @profileFeatureAssessmentDescription.
  ///
  /// In id, this message translates to:
  /// **'Refleksikan kebiasaan dan kondisi melalui pertanyaan singkat.'**
  String get profileFeatureAssessmentDescription;

  /// No description provided for @profileFeatureHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat asesmen'**
  String get profileFeatureHistory;

  /// No description provided for @profileFeatureHistoryDescription.
  ///
  /// In id, this message translates to:
  /// **'Telusuri kembali hasil dan ringkasan asesmen sebelumnya.'**
  String get profileFeatureHistoryDescription;

  /// No description provided for @profileFeatureGuidance.
  ///
  /// In id, this message translates to:
  /// **'Panduan keseharian'**
  String get profileFeatureGuidance;

  /// No description provided for @profileFeatureGuidanceDescription.
  ///
  /// In id, this message translates to:
  /// **'Temukan ide untuk istirahat, relaksasi, dan dukungan sosial.'**
  String get profileFeatureGuidanceDescription;

  /// No description provided for @profileAboutDisclaimer.
  ///
  /// In id, this message translates to:
  /// **'Hasil asesmen bukan diagnosis medis. Aplikasi ini tidak menggantikan konsultasi dengan tenaga profesional.'**
  String get profileAboutDisclaimer;

  /// No description provided for @profileDevelopedBy.
  ///
  /// In id, this message translates to:
  /// **'Dikembangkan oleh Tim AntiBurnout'**
  String get profileDevelopedBy;

  /// No description provided for @profileHelpTitle.
  ///
  /// In id, this message translates to:
  /// **'Bantuan'**
  String get profileHelpTitle;

  /// No description provided for @profileHelpIntro.
  ///
  /// In id, this message translates to:
  /// **'Temukan jawaban tentang penggunaan aplikasi. Ketuk pertanyaan untuk membaca penjelasannya.'**
  String get profileHelpIntro;

  /// No description provided for @profileFaqTitle.
  ///
  /// In id, this message translates to:
  /// **'Pertanyaan yang sering diajukan'**
  String get profileFaqTitle;

  /// No description provided for @profileFaq1Question.
  ///
  /// In id, this message translates to:
  /// **'Bagaimana cara menggunakan AntiBurnout?'**
  String get profileFaq1Question;

  /// No description provided for @profileFaq1Answer.
  ///
  /// In id, this message translates to:
  /// **'Mulai dari Beranda untuk melihat ringkasan kondisi dan motivasi harian. Gunakan tab Survei untuk mengisi asesmen, Riwayat untuk membuka hasil sebelumnya, dan Profil untuk mengatur informasi diri.'**
  String get profileFaq1Answer;

  /// No description provided for @profileFaq2Question.
  ///
  /// In id, this message translates to:
  /// **'Bagaimana cara memulai survei?'**
  String get profileFaq2Question;

  /// No description provided for @profileFaq2Answer.
  ///
  /// In id, this message translates to:
  /// **'Buka tab Survei atau ketuk Mulai Survei di Beranda. Baca pengantar, lalu pilih jawaban yang paling sesuai dengan kondisimu. Tinjau kembali jawaban sebelum mengirim. Layanan pengiriman dan prediksi masih dalam pengembangan.'**
  String get profileFaq2Answer;

  /// No description provided for @profileFaq3Question.
  ///
  /// In id, this message translates to:
  /// **'Di mana saya bisa melihat hasil sebelumnya?'**
  String get profileFaq3Question;

  /// No description provided for @profileFaq3Answer.
  ///
  /// In id, this message translates to:
  /// **'Buka tab Riwayat, lalu ketuk salah satu asesmen untuk melihat detailnya. Pencarian dan filter dapat membantu menemukan riwayat. Data yang ditampilkan saat ini merupakan contoh untuk pratinjau UI.'**
  String get profileFaq3Answer;

  /// No description provided for @profileFaq4Question.
  ///
  /// In id, this message translates to:
  /// **'Apakah hasil asesmen merupakan diagnosis medis?'**
  String get profileFaq4Question;

  /// No description provided for @profileFaq4Answer.
  ///
  /// In id, this message translates to:
  /// **'Tidak. Hasil asesmen bukan diagnosis medis dan tidak menggantikan konsultasi dengan tenaga profesional. Gunakan informasi ini sebagai bahan refleksi untuk lebih mengenali kondisi diri.'**
  String get profileFaq4Answer;

  /// No description provided for @profileFaq5Question.
  ///
  /// In id, this message translates to:
  /// **'Bagaimana membaca faktor dan ringkasan jawaban?'**
  String get profileFaq5Question;

  /// No description provided for @profileFaq5Answer.
  ///
  /// In id, this message translates to:
  /// **'Faktor dan ringkasan membantu menjelaskan tampilan hasil asesmen. Pada versi pratinjau ini, isinya adalah data statis. Ringkasan jawaban tidak menunjukkan besarnya kontribusi model prediksi.'**
  String get profileFaq5Answer;

  /// No description provided for @profileFaq6Question.
  ///
  /// In id, this message translates to:
  /// **'Bagaimana cara mengubah nama dan foto?'**
  String get profileFaq6Question;

  /// No description provided for @profileFaq6Answer.
  ///
  /// In id, this message translates to:
  /// **'Buka Profil, lalu Edit Profil. Ubah nama atau pilih foto dari galeri, kemudian ketuk Simpan Perubahan. Perubahan diingat selama sesi aplikasi dan belum disimpan ke server.'**
  String get profileFaq6Answer;

  /// No description provided for @profileFaq7Question.
  ///
  /// In id, this message translates to:
  /// **'Bagaimana cara mengubah tema aplikasi?'**
  String get profileFaq7Question;

  /// No description provided for @profileFaq7Answer.
  ///
  /// In id, this message translates to:
  /// **'Buka Profil, lalu Preferensi. Pilih Terang atau Gelap untuk mengubah tampilan aplikasi, atau Sistem untuk mengikuti tema perangkat. Pengingat masih berupa pratinjau dan belum mengirim notifikasi.'**
  String get profileFaq7Answer;

  /// No description provided for @profileBackToProfile.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke profil'**
  String get profileBackToProfile;

  /// No description provided for @profileBackToHome.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke beranda'**
  String get profileBackToHome;

  /// No description provided for @personalizationTitle.
  ///
  /// In id, this message translates to:
  /// **'Personalisasi Profil'**
  String get personalizationTitle;

  /// No description provided for @personalizationIntroTitle.
  ///
  /// In id, this message translates to:
  /// **'Kenali dirimu lebih dekat'**
  String get personalizationIntroTitle;

  /// No description provided for @personalizationIntroBody.
  ///
  /// In id, this message translates to:
  /// **'Isi sekali untuk melengkapi surveimu.\nPerbarui kapan pun kondisimu berubah.'**
  String get personalizationIntroBody;

  /// No description provided for @personalizationTabPersonal.
  ///
  /// In id, this message translates to:
  /// **'Data Diri'**
  String get personalizationTabPersonal;

  /// No description provided for @personalizationTabActivity.
  ///
  /// In id, this message translates to:
  /// **'Aktivitas'**
  String get personalizationTabActivity;

  /// No description provided for @personalizationTabAdditional.
  ///
  /// In id, this message translates to:
  /// **'Tambahan'**
  String get personalizationTabAdditional;

  /// No description provided for @personalizationSectionBasic.
  ///
  /// In id, this message translates to:
  /// **'Informasi dasar'**
  String get personalizationSectionBasic;

  /// No description provided for @personalizationSectionActivity.
  ///
  /// In id, this message translates to:
  /// **'Aktivitas & kebiasaan'**
  String get personalizationSectionActivity;

  /// No description provided for @personalizationSectionAdditional.
  ///
  /// In id, this message translates to:
  /// **'Informasi tambahan'**
  String get personalizationSectionAdditional;

  /// No description provided for @personalizationSaved.
  ///
  /// In id, this message translates to:
  /// **'Personalisasi profil berhasil disimpan.'**
  String get personalizationSaved;

  /// No description provided for @personalizationUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Personalisasi belum tersedia.'**
  String get personalizationUnavailable;

  /// No description provided for @personalizationRetry.
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get personalizationRetry;

  /// No description provided for @personalizationContinue.
  ///
  /// In id, this message translates to:
  /// **'Selanjutnya'**
  String get personalizationContinue;

  /// No description provided for @personalizationSave.
  ///
  /// In id, this message translates to:
  /// **'Simpan Personalisasi'**
  String get personalizationSave;

  /// No description provided for @personalizationPrevious.
  ///
  /// In id, this message translates to:
  /// **'Sebelumnya'**
  String get personalizationPrevious;

  /// No description provided for @personalizationProgress.
  ///
  /// In id, this message translates to:
  /// **'Langkah {current} dari {total}'**
  String personalizationProgress(int current, int total);

  /// No description provided for @personalizationLoginRequired.
  ///
  /// In id, this message translates to:
  /// **'Silakan masuk terlebih dahulu.'**
  String get personalizationLoginRequired;

  /// No description provided for @personalizationLoadError.
  ///
  /// In id, this message translates to:
  /// **'Personalisasi gagal dimuat. Silakan coba lagi.'**
  String get personalizationLoadError;

  /// No description provided for @personalizationBirthDateInvalid.
  ///
  /// In id, this message translates to:
  /// **'Pilih tanggal lahir antara 1 Januari 1900 dan hari ini.'**
  String get personalizationBirthDateInvalid;

  /// No description provided for @personalizationSaveError.
  ///
  /// In id, this message translates to:
  /// **'Personalisasi gagal disimpan. Silakan coba lagi.'**
  String get personalizationSaveError;

  /// No description provided for @personalizationTellAboutYou.
  ///
  /// In id, this message translates to:
  /// **'Ceritakan sedikit tentang dirimu.'**
  String get personalizationTellAboutYou;

  /// No description provided for @personalizationBirthDate.
  ///
  /// In id, this message translates to:
  /// **'Tanggal Lahir'**
  String get personalizationBirthDate;

  /// No description provided for @personalizationGender.
  ///
  /// In id, this message translates to:
  /// **'Jenis kelamin'**
  String get personalizationGender;

  /// No description provided for @personalizationCountry.
  ///
  /// In id, this message translates to:
  /// **'Negara tempat tinggal'**
  String get personalizationCountry;

  /// No description provided for @personalizationSelectCountry.
  ///
  /// In id, this message translates to:
  /// **'Pilih negara'**
  String get personalizationSelectCountry;

  /// No description provided for @personalizationEducation.
  ///
  /// In id, this message translates to:
  /// **'Pendidikan terakhir yang diselesaikan'**
  String get personalizationEducation;

  /// No description provided for @personalizationSelectEducation.
  ///
  /// In id, this message translates to:
  /// **'Pilih jenjang pendidikan'**
  String get personalizationSelectEducation;

  /// No description provided for @personalizationGenderFemale.
  ///
  /// In id, this message translates to:
  /// **'Perempuan'**
  String get personalizationGenderFemale;

  /// No description provided for @personalizationGenderMale.
  ///
  /// In id, this message translates to:
  /// **'Laki-laki'**
  String get personalizationGenderMale;

  /// No description provided for @personalizationOther.
  ///
  /// In id, this message translates to:
  /// **'Lainnya'**
  String get personalizationOther;

  /// No description provided for @personalizationCountrySingapore.
  ///
  /// In id, this message translates to:
  /// **'Singapura'**
  String get personalizationCountrySingapore;

  /// No description provided for @personalizationCountryPhilippines.
  ///
  /// In id, this message translates to:
  /// **'Filipina'**
  String get personalizationCountryPhilippines;

  /// No description provided for @personalizationEducationPrimary.
  ///
  /// In id, this message translates to:
  /// **'SD / sederajat'**
  String get personalizationEducationPrimary;

  /// No description provided for @personalizationEducationJunior.
  ///
  /// In id, this message translates to:
  /// **'SMP / sederajat'**
  String get personalizationEducationJunior;

  /// No description provided for @personalizationEducationSenior.
  ///
  /// In id, this message translates to:
  /// **'SMA / SMK / sederajat'**
  String get personalizationEducationSenior;

  /// No description provided for @personalizationEducationDiploma.
  ///
  /// In id, this message translates to:
  /// **'Diploma'**
  String get personalizationEducationDiploma;

  /// No description provided for @personalizationEducationBachelor.
  ///
  /// In id, this message translates to:
  /// **'D4 / S1'**
  String get personalizationEducationBachelor;

  /// No description provided for @personalizationEducationMaster.
  ///
  /// In id, this message translates to:
  /// **'S2'**
  String get personalizationEducationMaster;

  /// No description provided for @personalizationEducationDoctorate.
  ///
  /// In id, this message translates to:
  /// **'S3'**
  String get personalizationEducationDoctorate;

  /// No description provided for @personalizationDateHint.
  ///
  /// In id, this message translates to:
  /// **'Pilih tanggal lahir (DD/MM/YYYY)'**
  String get personalizationDateHint;

  /// No description provided for @personalizationRemoveDate.
  ///
  /// In id, this message translates to:
  /// **'Hapus tanggal lahir'**
  String get personalizationRemoveDate;

  /// No description provided for @personalizationSelectDate.
  ///
  /// In id, this message translates to:
  /// **'Pilih tanggal lahir'**
  String get personalizationSelectDate;

  /// No description provided for @personalizationDateCancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get personalizationDateCancel;

  /// No description provided for @personalizationDateConfirm.
  ///
  /// In id, this message translates to:
  /// **'Pilih'**
  String get personalizationDateConfirm;

  /// No description provided for @personalizationActivityOccupation.
  ///
  /// In id, this message translates to:
  /// **'Pekerjaan / aktivitas utama'**
  String get personalizationActivityOccupation;

  /// No description provided for @personalizationSelectOccupation.
  ///
  /// In id, this message translates to:
  /// **'Pilih aktivitas utama'**
  String get personalizationSelectOccupation;

  /// No description provided for @personalizationOccupationStudent.
  ///
  /// In id, this message translates to:
  /// **'Pelajar / Mahasiswa'**
  String get personalizationOccupationStudent;

  /// No description provided for @personalizationOccupationEmployee.
  ///
  /// In id, this message translates to:
  /// **'Karyawan'**
  String get personalizationOccupationEmployee;

  /// No description provided for @personalizationOccupationEntrepreneur.
  ///
  /// In id, this message translates to:
  /// **'Wirausaha'**
  String get personalizationOccupationEntrepreneur;

  /// No description provided for @personalizationOccupationFreelancer.
  ///
  /// In id, this message translates to:
  /// **'Freelancer'**
  String get personalizationOccupationFreelancer;

  /// No description provided for @personalizationOccupationHomemaker.
  ///
  /// In id, this message translates to:
  /// **'Mengurus rumah tangga'**
  String get personalizationOccupationHomemaker;

  /// No description provided for @personalizationOccupationUnemployed.
  ///
  /// In id, this message translates to:
  /// **'Belum bekerja'**
  String get personalizationOccupationUnemployed;

  /// No description provided for @personalizationEmploymentStatus.
  ///
  /// In id, this message translates to:
  /// **'Status pekerjaan'**
  String get personalizationEmploymentStatus;

  /// No description provided for @personalizationSelectEmploymentStatus.
  ///
  /// In id, this message translates to:
  /// **'Pilih status pekerjaan'**
  String get personalizationSelectEmploymentStatus;

  /// No description provided for @personalizationEmploymentFullTime.
  ///
  /// In id, this message translates to:
  /// **'Penuh waktu'**
  String get personalizationEmploymentFullTime;

  /// No description provided for @personalizationEmploymentPartTime.
  ///
  /// In id, this message translates to:
  /// **'Paruh waktu'**
  String get personalizationEmploymentPartTime;

  /// No description provided for @personalizationEmploymentContract.
  ///
  /// In id, this message translates to:
  /// **'Kontrak'**
  String get personalizationEmploymentContract;

  /// No description provided for @personalizationEmploymentIntern.
  ///
  /// In id, this message translates to:
  /// **'Magang'**
  String get personalizationEmploymentIntern;

  /// No description provided for @personalizationEmploymentSelfEmployed.
  ///
  /// In id, this message translates to:
  /// **'Bekerja mandiri'**
  String get personalizationEmploymentSelfEmployed;

  /// No description provided for @personalizationEmploymentUnemployed.
  ///
  /// In id, this message translates to:
  /// **'Tidak bekerja'**
  String get personalizationEmploymentUnemployed;

  /// No description provided for @personalizationWorkLocation.
  ///
  /// In id, this message translates to:
  /// **'Lokasi kerja'**
  String get personalizationWorkLocation;

  /// No description provided for @personalizationWorkHome.
  ///
  /// In id, this message translates to:
  /// **'Rumah'**
  String get personalizationWorkHome;

  /// No description provided for @personalizationWorkOffice.
  ///
  /// In id, this message translates to:
  /// **'Kantor'**
  String get personalizationWorkOffice;

  /// No description provided for @personalizationSmoking.
  ///
  /// In id, this message translates to:
  /// **'Apakah kamu merokok?'**
  String get personalizationSmoking;

  /// No description provided for @personalizationAlcohol.
  ///
  /// In id, this message translates to:
  /// **'Apakah kamu mengonsumsi alkohol?'**
  String get personalizationAlcohol;

  /// No description provided for @personalizationYes.
  ///
  /// In id, this message translates to:
  /// **'Ya'**
  String get personalizationYes;

  /// No description provided for @personalizationNo.
  ///
  /// In id, this message translates to:
  /// **'Tidak'**
  String get personalizationNo;

  /// No description provided for @personalizationOptionalIntro.
  ///
  /// In id, this message translates to:
  /// **'Isi jika kamu merasa nyaman.'**
  String get personalizationOptionalIntro;

  /// No description provided for @personalizationMonthlyIncome.
  ///
  /// In id, this message translates to:
  /// **'Pendapatan bulanan (IDR)'**
  String get personalizationMonthlyIncome;

  /// No description provided for @personalizationIncomeHint.
  ///
  /// In id, this message translates to:
  /// **'Isi jumlah atau biarkan kosong'**
  String get personalizationIncomeHint;

  /// No description provided for @personalizationFamilyHistory.
  ///
  /// In id, this message translates to:
  /// **'Riwayat kondisi kesehatan mental'**
  String get personalizationFamilyHistory;

  /// No description provided for @personalizationFamilyHistoryDescription.
  ///
  /// In id, this message translates to:
  /// **'Apakah ada anggota keluarga yang pernah mengalami gangguan kesehatan mental?'**
  String get personalizationFamilyHistoryDescription;

  /// No description provided for @personalizationProfessionalSupport.
  ///
  /// In id, this message translates to:
  /// **'Dukungan profesional'**
  String get personalizationProfessionalSupport;

  /// No description provided for @personalizationProfessionalSupportDescription.
  ///
  /// In id, this message translates to:
  /// **'Apakah kamu mengikuti terapi atau konseling untuk kesehatan mental?'**
  String get personalizationProfessionalSupportDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
