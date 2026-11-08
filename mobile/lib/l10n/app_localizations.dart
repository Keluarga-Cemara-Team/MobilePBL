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
