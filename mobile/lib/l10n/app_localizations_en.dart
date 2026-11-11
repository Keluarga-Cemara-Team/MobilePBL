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

  @override
  String get surveyTitle => 'Daily Survey';

  @override
  String get surveyIntroTime => 'Time for yourself · 3–5 minutes';

  @override
  String get surveyIntroQuestion => 'How was your day?';

  @override
  String get surveyIntroBody =>
      'Take a moment to reflect on your activities, habits, and feelings today.';

  @override
  String get surveyIntroBenefitTitle => 'Small steps, meaningful benefits';

  @override
  String get surveyIntroSimpleTitle => 'Simple questions';

  @override
  String get surveyIntroSimpleBody =>
      'Tell us about your daily activities and habits.';

  @override
  String get surveyIntroPatternTitle => 'Understand your daily patterns';

  @override
  String get surveyIntroPatternBody =>
      'Reflect and keep track of your wellbeing.';

  @override
  String get surveyIntroDisclaimer =>
      'There are no right or wrong answers. Answer based on how you feel.';

  @override
  String get surveyStart => 'Start Survey';

  @override
  String get surveyBackToIntro => 'Back to survey introduction';

  @override
  String get surveyUnavailable => 'Survey is unavailable';

  @override
  String get surveyLoadFailed => 'Could not load survey';

  @override
  String get surveyUnavailableBody =>
      'Questions and assessment services are unavailable. Please try again later.';

  @override
  String get surveyRetry => 'Try Again';

  @override
  String get surveyBackToIntroButton => 'Back to Introduction';

  @override
  String get surveyAnswerPrompt => 'Answer based on how you feel.';

  @override
  String get surveySubmitAnswers => 'Submit Answers';

  @override
  String get surveyWriteAnswer => 'Write your answer';

  @override
  String get surveyReviewTitle => 'Review your answers';

  @override
  String get surveyReviewSubtitle =>
      'Make sure your answers are correct before submitting.';

  @override
  String get surveyReviewTip => 'Results are a risk estimate, not a diagnosis.';

  @override
  String surveyStepLabel(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get surveyBack => 'Back';

  @override
  String get surveyContinue => 'Continue';

  @override
  String get surveySubmitViewResults => 'Submit & View Results';

  @override
  String get surveyEditAnswer => 'Edit';

  @override
  String get surveyActivityEasy => 'Activities feel manageable';

  @override
  String get surveyActivityOverwhelming =>
      'They feel demanding, but still manageable';

  @override
  String get surveyActivityDifficult =>
      'The workload feels difficult to manage';

  @override
  String get surveyZeroHours => '0 hours';

  @override
  String surveyMaximumHours(int hours) {
    return '$hours hours';
  }

  @override
  String get surveyOutOf100 => 'out of 100';

  @override
  String get surveyVeryUncomfortable => 'Very uncomfortable';

  @override
  String get surveyVeryComfortable => 'Very comfortable';

  @override
  String get surveyOwnDuration => 'Or enter a duration';

  @override
  String get surveyUnitHours => 'hours';

  @override
  String get surveyUnitCups => 'cups';

  @override
  String get surveyUnitMinutes => 'minutes';

  @override
  String get surveyMinutesValidation =>
      'Enter a whole number of minutes greater than or equal to 0.';

  @override
  String get surveyErrorLoadQuestions =>
      'Could not load survey questions. Try again.';

  @override
  String get surveyErrorServiceUnavailable =>
      'Assessment service is unavailable. Your answers were not submitted.';

  @override
  String get surveyErrorSubmit => 'Could not submit answers. Try again.';

  @override
  String get sleepQualityLabel => 'How was your sleep\nlast night?';

  @override
  String get sleepQualitySubtitle => 'Choose the sleep quality that best fits.';

  @override
  String get sleepQualityTip =>
      'Sleep duration and sleep quality are two different things.';

  @override
  String get sleepQualityReview => 'Sleep quality';

  @override
  String get sleepPoor => 'Poor';

  @override
  String get sleepFair => 'Fair';

  @override
  String get sleepGood => 'Good';

  @override
  String get sleepVeryGood => 'Very good';

  @override
  String get screenTimeLabel => 'How long have you used\na screen today?';

  @override
  String get screenTimeSubtitle => 'Include phone, laptop, and TV use.';

  @override
  String get screenTimeTip => 'Take screen breaks to rest your eyes and mind.';

  @override
  String get screenTimeReview => 'Screen time';

  @override
  String get sleepDurationLabel => 'How long did you sleep\nlast night?';

  @override
  String get sleepDurationSubtitle =>
      'Use the slider or buttons to set your sleep duration.';

  @override
  String get sleepDurationTip =>
      'Enough sleep supports your mental health and productivity.';

  @override
  String get sleepDurationReview => 'Sleep duration';

  @override
  String get coffeeLabel => 'How many cups of coffee have you\nhad today?';

  @override
  String get coffeeSubtitle =>
      'Use the buttons to increase or decrease the amount.';

  @override
  String get coffeeTip =>
      'Moderate caffeine can boost energy, but too much may trigger anxiety.';

  @override
  String get coffeeReview => 'Coffee';

  @override
  String get workloadLabel =>
      'How overwhelmed do you feel by\ntoday’s activities?';

  @override
  String get workloadSubtitle => 'Choose the option closest to how you feel.';

  @override
  String get workloadTip =>
      'Balancing daily activities is important for your physical and mental health.';

  @override
  String get workloadReview => 'Stress';

  @override
  String get workloadLight => 'Light';

  @override
  String get workloadModerate => 'Moderate';

  @override
  String get workloadHeavy => 'Heavy';

  @override
  String get meditationLabel => 'How many minutes did you\nmeditate today?';

  @override
  String get meditationSubtitle => 'Choose a duration or enter a number.';

  @override
  String get meditationTip =>
      'Just 15 minutes of meditation can recharge you and clear your mind.';

  @override
  String get meditationReview => 'Meditation';

  @override
  String get moodLabel => 'How would you rate your day\noverall?';

  @override
  String get moodSubtitle => 'Use the slider to choose a score.';

  @override
  String get moodTip =>
      'A short end-of-day reflection can help you recognize what makes you stressed or happy.';

  @override
  String get moodReview => 'Mood';

  @override
  String get historyTitle => 'Survey History';

  @override
  String get historyDescription => 'Your previous burnout assessment results.';

  @override
  String get historySearchHint => 'Search history...';

  @override
  String get historyFilterAll => 'All';

  @override
  String get historyEmpty => 'No assessment history yet.';

  @override
  String get historyNoResults => 'No history found.';

  @override
  String get historyLoadError => 'Could not load history. Try again.';

  @override
  String get historyRetry => 'Try again';

  @override
  String get historyLatest => 'Latest assessment result';

  @override
  String get historyPrevious => 'Previous assessment result';

  @override
  String get historyRiskTitle => 'Burnout Risk';

  @override
  String get historyDetails => 'Details';
}
