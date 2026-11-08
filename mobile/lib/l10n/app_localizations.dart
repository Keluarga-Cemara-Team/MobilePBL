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
