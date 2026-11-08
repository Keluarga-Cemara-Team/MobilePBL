// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dashboardHello => 'Hello,';

  @override
  String get dashboardSubtitle =>
      'Take care of your mental health, starting today.';

  @override
  String get openProfile => 'Open profile';

  @override
  String get latestAssessmentHeading => 'LATEST ASSESSMENT';

  @override
  String get startSurvey => 'Start Assessment';

  @override
  String get startSurveySubtitle => 'Take a new burnout assessment';

  @override
  String get myHistory => 'My History';

  @override
  String get myHistorySubtitle => 'View previous assessment results';

  @override
  String get latestAssessmentEmpty => 'No assessment yet';

  @override
  String get startSurveyPrompt =>
      'Start an assessment to understand your daily wellbeing.';

  @override
  String get viewDetails => 'View Details ›';

  @override
  String get burnoutRisk => 'Burnout Risk';

  @override
  String get riskLow => 'Low';

  @override
  String get riskMedium => 'Moderate';

  @override
  String get riskHigh => 'High';

  @override
  String get motivationTitle => 'Today’s Motivation';

  @override
  String get riskStatisticsTitle => 'Risk Statistics';

  @override
  String get assessmentHistorySummary => 'Summary of all assessment history';

  @override
  String get samplePreview => 'Preview with sample data';

  @override
  String get includesSampleData => 'Includes sample data';

  @override
  String assessmentsTotal(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count assessments in total',
      one: '1 assessment in total',
      zero: 'No assessments',
    );
    return '$_temp0';
  }

  @override
  String get lastSevenDaysChart => 'Last 7 Days';

  @override
  String get weeklyEmpty => 'No assessments in the last 7 days.';

  @override
  String get weeklyBarDescription =>
      'Each bar represents one assessment. Tap to view its risk level.';

  @override
  String get weeklyChartOrderNote =>
      'Ordered from newest to oldest. Bar height shows the risk category, not a medical score.';

  @override
  String get swipeForDates => 'Swipe to see other dates.';

  @override
  String dayAssessmentCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count assessments',
      one: '1 assessment',
      zero: 'No assessments',
    );
    return '$_temp0';
  }

  @override
  String emptyDateSemantics(Object date) {
    return '$date, no assessments';
  }

  @override
  String riskTooltip(Object risk, Object time) {
    return '$risk · $time';
  }

  @override
  String riskSemantics(Object date, Object risk) {
    return '$date, $risk risk';
  }

  @override
  String weekRange(Object end, Object start) {
    return '$start – $end';
  }

  @override
  String get motivation01 =>
      'Getting enough sleep supports your mental health and productivity.';

  @override
  String get motivation02 => 'Small steps still matter. Move at your own pace.';

  @override
  String get motivation03 => 'A short rest gives you room to begin again.';

  @override
  String get motivation04 =>
      'You do not have to finish everything at once. Start with what matters most.';

  @override
  String get motivation05 =>
      'Give yourself credit for what you have done today.';

  @override
  String get motivation06 =>
      'Make a little time for something you enjoy, even on a busy day.';

  @override
  String get motivation07 =>
      'When you feel overwhelmed, it is okay to ask someone you trust for help.';

  @override
  String get motivation08 =>
      'Give yourself permission to pause and reset your priorities.';

  @override
  String get motivation09 =>
      'A difficult day does not erase the progress you have made.';

  @override
  String get motivation10 =>
      'It is okay to set boundaries when your time and energy are limited.';

  @override
  String get motivation11 =>
      'Make time to connect with someone who makes you feel heard.';

  @override
  String get motivation12 =>
      'Begin again with one small step. Nothing has to be perfect.';

  @override
  String get mondayShort => 'Mon';

  @override
  String get tuesdayShort => 'Tue';

  @override
  String get wednesdayShort => 'Wed';

  @override
  String get thursdayShort => 'Thu';

  @override
  String get fridayShort => 'Fri';

  @override
  String get saturdayShort => 'Sat';

  @override
  String get sundayShort => 'Sun';
}
