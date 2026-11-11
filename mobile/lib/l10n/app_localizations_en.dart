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

  @override
  String get resultTitle => 'Prediction Result';

  @override
  String get resultLoadError => 'The assessment result could not be loaded.';

  @override
  String get resultNotFound =>
      'Assessment result not found. Open a result from History or complete a survey first.';

  @override
  String resultDescription(Object risk) {
    return 'The assessment indicates a $risk level of burnout risk.';
  }

  @override
  String resultAssessmentDate(Object date) {
    return 'Assessment $date';
  }

  @override
  String get resultDisclaimer =>
      'This is not a medical diagnosis, but an initial indication that may help you better understand your wellbeing.';

  @override
  String get resultSampleData => 'Sample data';

  @override
  String get resultFactorsTitle => 'Contributing Factors';

  @override
  String get resultFactorsUnavailable =>
      'Model factors are not available for this assessment.';

  @override
  String get resultExampleFactorsCaption =>
      'Factors shown in this sample assessment result.';

  @override
  String get resultModelFactorsCaption =>
      'Factors included in the model result for this assessment.';

  @override
  String get resultAnswerSummaryTitle => 'Answer Summary';

  @override
  String get resultExampleAnswersCaption =>
      'Answers from this sample assessment.';

  @override
  String get resultAnswersCaption =>
      'Survey answers, separate from the prediction model\'s contributing factors.';

  @override
  String get resultAnswersUnavailable => 'Answer summary is not available.';

  @override
  String get resultRecommendation => 'View Recommendations';

  @override
  String get resultRiskLevel => 'Risk Level';

  @override
  String get resultRiskBurnout => 'Burnout Risk';

  @override
  String get resultStressLabel => 'Stress level';

  @override
  String resultRiskSemantics(Object risk) {
    return 'Burnout risk level: $risk';
  }

  @override
  String get resultExampleFactorSleep => 'Irregular sleep duration';

  @override
  String get resultExampleFactorActivity => 'High activity load';

  @override
  String get resultExampleFactorStress => 'Increasing stress level';

  @override
  String resultFactorSleepSuboptimal(Object hours) {
    return 'Suboptimal sleep duration ($hours hours)';
  }

  @override
  String get resultFactorActivityStressHigh =>
      'High daily activity and stress load';

  @override
  String resultFactorScreenIntensive(Object hours) {
    return 'Intensive screen exposure ($hours hours)';
  }

  @override
  String resultFactorCoffeeHigh(Object cups) {
    return 'High caffeine intake ($cups cups)';
  }

  @override
  String resultFactorCoffeeModerateHigh(Object cups) {
    return 'Fairly high caffeine intake ($cups cups)';
  }

  @override
  String get resultFactorMeditationPositive =>
      'Very good relaxation / meditation practice';

  @override
  String get resultFactorBalancedActivityRest =>
      'Balanced activity and rest patterns';

  @override
  String get resultFactorStressHigh => 'High stress level';

  @override
  String resultFactorSleepLow(Object hours) {
    return 'Short sleep duration ($hours hours)';
  }

  @override
  String resultFactorScreenHigh(Object hours) {
    return 'High screen time ($hours hours)';
  }

  @override
  String get resultFactorRestWorkBalanced => 'Balanced rest and workload';

  @override
  String get resultFactorFatigueRhythm =>
      'Work fatigue and daily rhythm evaluation';

  @override
  String get resultFactorRestStressAnalysis => 'Rest and stress analysis';

  @override
  String get navHome => 'Home';

  @override
  String get navSurvey => 'Survey';

  @override
  String get navHistory => 'History';

  @override
  String get navProfile => 'Profile';

  @override
  String get userAvatarSemantics => 'User avatar';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEdit => 'Edit Profile';

  @override
  String get profilePersonalization => 'Profile Personalization';

  @override
  String get profilePreferences => 'Preferences';

  @override
  String get profileHelp => 'Help';

  @override
  String get profileAbout => 'About App';

  @override
  String get profileLogout => 'Log Out';

  @override
  String get profileLogoutError => 'Could not log out. Please try again.';

  @override
  String get profileDefaultUser => 'User';

  @override
  String get profileEditTitle => 'Edit Profile';

  @override
  String get profileChangePhoto => 'Change Photo';

  @override
  String get profileOpeningGallery => 'Opening gallery...';

  @override
  String get profileUseDefaultAvatar => 'Use default avatar';

  @override
  String get profilePhotoError =>
      'Could not open the photo. Allow gallery access or try another photo.';

  @override
  String get profileName => 'Name';

  @override
  String get profileNameHint => 'Enter your name';

  @override
  String get profileNameRequired => 'Name cannot be empty.';

  @override
  String get profileEmail => 'Email';

  @override
  String get profileEmailCannotChange => 'Email cannot be changed.';

  @override
  String get profileNamePhotoSync =>
      'Your name and profile photo are securely synced to your account.';

  @override
  String get profileSaveChanges => 'Save Changes';

  @override
  String get profileCancel => 'Cancel';

  @override
  String get profileSaved => 'Profile updated and saved.';

  @override
  String get profilePreferencesIntro =>
      'Adjust the theme, language, daily check-in reminders, and motivational notifications to support your mental wellbeing.';

  @override
  String get profileAppearance => 'Appearance';

  @override
  String get profileChooseTheme =>
      'Choose the theme that feels most comfortable.';

  @override
  String get profileThemeLight => 'Light';

  @override
  String get profileThemeDark => 'Dark';

  @override
  String get profileThemeSystem => 'System';

  @override
  String get profileLanguageTitle => 'Language';

  @override
  String get profileChooseLanguage => 'Choose the language used in the app.';

  @override
  String get profileLanguageIndonesian => 'Indonesian';

  @override
  String get profileLanguageIndonesianSubtitle => 'Bahasa Indonesia';

  @override
  String get profileLanguageEnglish => 'English';

  @override
  String get profileLanguageEnglishSubtitle => 'English';

  @override
  String get profileNotifications => 'Reminders & Notifications';

  @override
  String get profileNotificationDescription =>
      'Choose the notifications you want to enable for your daily routine.';

  @override
  String get profileDailyCheckIn => 'Daily Reminder (Check-in)';

  @override
  String get profileDailyCheckInDescription =>
      'Automatic reminder every morning (09:00) to check your burnout level.';

  @override
  String get profileDailyReminderEnabled =>
      'Daily reminder scheduled for 09:00 WIB';

  @override
  String get profileDailyReminderDisabled => 'Daily reminder disabled';

  @override
  String get profileWellbeingMotivation => 'Daily Motivation';

  @override
  String get profileWellbeingMotivationDescription =>
      'An encouraging quote and relaxing affirmation every afternoon (14:00).';

  @override
  String get profileMotivationEnabled =>
      'Daily motivation scheduled for 14:00 WIB';

  @override
  String get profileMotivationDisabled => 'Daily motivation disabled';

  @override
  String get profileTestReminder => 'Test Reminder';

  @override
  String get profileTestMotivation => 'Test Motivation';

  @override
  String get profileTestReminderSuccess => 'Daily reminder notification sent!';

  @override
  String get profileTestMotivationSuccess => 'Motivation notification sent!';

  @override
  String get profileNotificationTestHint =>
      'Use the buttons above to preview notifications instantly on this device.';

  @override
  String get profileAboutTitle => 'About App';

  @override
  String get profileMotto => 'Understand yourself. Keep your balance.';

  @override
  String profileVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get profileAboutHeading => 'About AntiBurnout';

  @override
  String get profileAboutDescription =>
      'AntiBurnout helps you understand your wellbeing through self-assessments, review past results, and find general guidance for balancing daily activities.';

  @override
  String get profileFeatureAssessment => 'Self-assessment';

  @override
  String get profileFeatureAssessmentDescription =>
      'Reflect on your habits and wellbeing through a few short questions.';

  @override
  String get profileFeatureHistory => 'Assessment history';

  @override
  String get profileFeatureHistoryDescription =>
      'Review previous assessment results and summaries.';

  @override
  String get profileFeatureGuidance => 'Everyday guidance';

  @override
  String get profileFeatureGuidanceDescription =>
      'Find ideas for rest, relaxation, and social support.';

  @override
  String get profileAboutDisclaimer =>
      'Assessment results are not a medical diagnosis. This app does not replace consultation with a healthcare professional.';

  @override
  String get profileDevelopedBy => 'Developed by the AntiBurnout Team';

  @override
  String get profileHelpTitle => 'Help';

  @override
  String get profileHelpIntro =>
      'Find answers about using the app. Tap a question to read its explanation.';

  @override
  String get profileFaqTitle => 'Frequently asked questions';

  @override
  String get profileFaq1Question => 'How do I use AntiBurnout?';

  @override
  String get profileFaq1Answer =>
      'Start on Home to see your wellbeing summary and daily motivation. Use Survey to complete an assessment, History to open previous results, and Profile to manage your information.';

  @override
  String get profileFaq2Question => 'How do I start a survey?';

  @override
  String get profileFaq2Answer =>
      'Open Survey or tap Start Assessment on Home. Read the introduction, then choose the answers that best match how you feel. Review your answers before submitting. Submission and prediction services are still in development.';

  @override
  String get profileFaq3Question => 'Where can I see previous results?';

  @override
  String get profileFaq3Answer =>
      'Open History and tap an assessment to view its details. Search and filters can help you find an entry. The results currently shown are sample data for the UI preview.';

  @override
  String get profileFaq4Question =>
      'Are assessment results a medical diagnosis?';

  @override
  String get profileFaq4Answer =>
      'No. Assessment results are not a medical diagnosis and do not replace consultation with a healthcare professional. Use this information for reflection and to better understand your wellbeing.';

  @override
  String get profileFaq5Question =>
      'How should I read the factors and answer summary?';

  @override
  String get profileFaq5Answer =>
      'The factors and summary explain what appears on the assessment result screen. In this preview version, the content is static sample data. The answer summary does not show how much each factor contributes to the prediction model.';

  @override
  String get profileFaq6Question => 'How do I change my name and photo?';

  @override
  String get profileFaq6Answer =>
      'Open Profile, then Edit Profile. Change your name or choose a photo from the gallery, then tap Save Changes. Changes are kept for the current app session and are not yet saved to the server.';

  @override
  String get profileFaq7Question => 'How do I change the app theme?';

  @override
  String get profileFaq7Answer =>
      'Open Profile, then Preferences. Choose Light or Dark, or choose System to follow your device theme. Reminders are still a preview and do not send notifications yet.';

  @override
  String get profileBackToProfile => 'Back to profile';

  @override
  String get profileBackToHome => 'Back to home';

  @override
  String get personalizationTitle => 'Profile Personalization';

  @override
  String get personalizationIntroTitle => 'Get to know yourself better';

  @override
  String get personalizationIntroBody =>
      'Fill this in once to complete your survey.\nUpdate it whenever your circumstances change.';

  @override
  String get personalizationTabPersonal => 'Personal';

  @override
  String get personalizationTabActivity => 'Activity';

  @override
  String get personalizationTabAdditional => 'Additional';

  @override
  String get personalizationSectionBasic => 'Basic information';

  @override
  String get personalizationSectionActivity => 'Activities & habits';

  @override
  String get personalizationSectionAdditional => 'Additional information';

  @override
  String get personalizationSaved => 'Profile personalization saved.';

  @override
  String get personalizationUnavailable => 'Personalization is unavailable.';

  @override
  String get personalizationRetry => 'Try Again';

  @override
  String get personalizationContinue => 'Continue';

  @override
  String get personalizationSave => 'Save Personalization';

  @override
  String get personalizationPrevious => 'Previous';

  @override
  String personalizationProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get personalizationLoginRequired => 'Please sign in first.';

  @override
  String get personalizationLoadError =>
      'Could not load personalization. Please try again.';

  @override
  String get personalizationBirthDateInvalid =>
      'Choose a birth date between January 1, 1900 and today.';

  @override
  String get personalizationSaveError =>
      'Could not save personalization. Please try again.';

  @override
  String get personalizationTellAboutYou => 'Tell us a little about yourself.';

  @override
  String get personalizationBirthDate => 'Date of birth';

  @override
  String get personalizationGender => 'Gender';

  @override
  String get personalizationCountry => 'Country of residence';

  @override
  String get personalizationSelectCountry => 'Select a country';

  @override
  String get personalizationEducation => 'Highest level of education completed';

  @override
  String get personalizationSelectEducation => 'Select an education level';

  @override
  String get personalizationGenderFemale => 'Female';

  @override
  String get personalizationGenderMale => 'Male';

  @override
  String get personalizationOther => 'Other';

  @override
  String get personalizationCountrySingapore => 'Singapore';

  @override
  String get personalizationCountryPhilippines => 'Philippines';

  @override
  String get personalizationEducationPrimary => 'Elementary / equivalent';

  @override
  String get personalizationEducationJunior => 'Junior high / equivalent';

  @override
  String get personalizationEducationSenior =>
      'Senior high / vocational / equivalent';

  @override
  String get personalizationEducationDiploma => 'Diploma';

  @override
  String get personalizationEducationBachelor => 'Bachelor\'s degree';

  @override
  String get personalizationEducationMaster => 'Master\'s degree';

  @override
  String get personalizationEducationDoctorate => 'Doctoral degree';

  @override
  String get personalizationDateHint => 'Select a birth date (DD/MM/YYYY)';

  @override
  String get personalizationRemoveDate => 'Clear date of birth';

  @override
  String get personalizationSelectDate => 'Select date of birth';

  @override
  String get personalizationDateCancel => 'Cancel';

  @override
  String get personalizationDateConfirm => 'Select';

  @override
  String get personalizationActivityOccupation => 'Occupation / main activity';

  @override
  String get personalizationSelectOccupation => 'Select your main activity';

  @override
  String get personalizationOccupationStudent => 'Student';

  @override
  String get personalizationOccupationEmployee => 'Employee';

  @override
  String get personalizationOccupationEntrepreneur => 'Entrepreneur';

  @override
  String get personalizationOccupationFreelancer => 'Freelancer';

  @override
  String get personalizationOccupationHomemaker => 'Homemaker';

  @override
  String get personalizationOccupationUnemployed => 'Not currently working';

  @override
  String get personalizationEmploymentStatus => 'Employment status';

  @override
  String get personalizationSelectEmploymentStatus =>
      'Select your employment status';

  @override
  String get personalizationEmploymentFullTime => 'Full-time';

  @override
  String get personalizationEmploymentPartTime => 'Part-time';

  @override
  String get personalizationEmploymentContract => 'Contract';

  @override
  String get personalizationEmploymentIntern => 'Internship';

  @override
  String get personalizationEmploymentSelfEmployed => 'Self-employed';

  @override
  String get personalizationEmploymentUnemployed => 'Unemployed';

  @override
  String get personalizationWorkLocation => 'Work location';

  @override
  String get personalizationWorkHome => 'Home';

  @override
  String get personalizationWorkOffice => 'Office';

  @override
  String get personalizationSmoking => 'Do you smoke?';

  @override
  String get personalizationAlcohol => 'Do you consume alcohol?';

  @override
  String get personalizationYes => 'Yes';

  @override
  String get personalizationNo => 'No';

  @override
  String get personalizationOptionalIntro =>
      'Fill this in only if you feel comfortable.';

  @override
  String get personalizationMonthlyIncome => 'Monthly income (IDR)';

  @override
  String get personalizationIncomeHint => 'Enter an amount or leave blank';

  @override
  String get personalizationFamilyHistory => 'Mental health history';

  @override
  String get personalizationFamilyHistoryDescription =>
      'Has anyone in your family experienced a mental health condition?';

  @override
  String get personalizationProfessionalSupport => 'Professional support';

  @override
  String get personalizationProfessionalSupportDescription =>
      'Are you receiving therapy or counseling for your mental health?';
}
