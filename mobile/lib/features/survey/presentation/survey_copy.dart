import 'package:mobile/l10n/app_localizations.dart';

import '../domain/entities/survey_question.dart';

extension SurveyQuestionCopy on SurveyQuestion {
  String localizedLabel(AppLocalizations l10n) => switch (id) {
    'sleep_quality' => l10n.sleepQualityLabel,
    'screen_hours' => l10n.screenTimeLabel,
    'sleep_hours' => l10n.sleepDurationLabel,
    'coffee_cups' => l10n.coffeeLabel,
    'activity_load' => l10n.workloadLabel,
    'meditation_minutes' => l10n.meditationLabel,
    'mood_rating' => l10n.moodLabel,
    _ => label,
  };

  String localizedSubtitle(AppLocalizations l10n) => switch (id) {
    'sleep_quality' => l10n.sleepQualitySubtitle,
    'screen_hours' => l10n.screenTimeSubtitle,
    'sleep_hours' => l10n.sleepDurationSubtitle,
    'coffee_cups' => l10n.coffeeSubtitle,
    'activity_load' => l10n.workloadSubtitle,
    'meditation_minutes' => l10n.meditationSubtitle,
    'mood_rating' => l10n.moodSubtitle,
    _ => subtitle,
  };

  String localizedTip(AppLocalizations l10n) => switch (id) {
    'sleep_quality' => l10n.sleepQualityTip,
    'screen_hours' => l10n.screenTimeTip,
    'sleep_hours' => l10n.sleepDurationTip,
    'coffee_cups' => l10n.coffeeTip,
    'activity_load' => l10n.workloadTip,
    'meditation_minutes' => l10n.meditationTip,
    'mood_rating' => l10n.moodTip,
    _ => tip,
  };

  String localizedReviewLabel(AppLocalizations l10n) => switch (id) {
    'sleep_quality' => l10n.sleepQualityReview,
    'screen_hours' => l10n.screenTimeReview,
    'sleep_hours' => l10n.sleepDurationReview,
    'coffee_cups' => l10n.coffeeReview,
    'activity_load' => l10n.workloadReview,
    'meditation_minutes' => l10n.meditationReview,
    'mood_rating' => l10n.moodReview,
    _ => reviewLabel,
  };

  String localizedOption(AppLocalizations l10n, int index) => switch (id) {
    'sleep_quality' => switch (index) {
      0 => l10n.sleepPoor,
      1 => l10n.sleepFair,
      2 => l10n.sleepGood,
      3 => l10n.sleepVeryGood,
      _ => options[index],
    },
    'activity_load' => switch (index) {
      0 => l10n.workloadLight,
      1 => l10n.workloadModerate,
      2 => l10n.workloadHeavy,
      _ => options[index],
    },
    _ => options[index],
  };

  String localizedUnit(AppLocalizations l10n) => switch (unit) {
    'jam' => l10n.surveyUnitHours,
    'cangkir' => l10n.surveyUnitCups,
    'menit' => l10n.surveyUnitMinutes,
    _ => unit,
  };

  String localizedAnswer(AppLocalizations l10n, String? answer) {
    if (answer == null) return '—';
    final index = options.indexOf(answer);
    return index < 0 ? answer : localizedOption(l10n, index);
  }
}

String localizedSurveyError(AppLocalizations l10n, String message) =>
    switch (message) {
      'Pertanyaan survei gagal dimuat. Coba lagi.' =>
        l10n.surveyErrorLoadQuestions,
      'Layanan asesmen belum tersedia. Jawaban belum dikirim.' =>
        l10n.surveyErrorServiceUnavailable,
      'Jawaban gagal dikirim. Coba lagi.' => l10n.surveyErrorSubmit,
      _ => message,
    };
