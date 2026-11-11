import 'package:mobile/l10n/app_localizations.dart';

import '../../assessment/domain/entities/assessment.dart';

String localizeResultFactor(AppLocalizations l10n, String label) {
  final sleepSuboptimal = RegExp(
    r'^Durasi tidur kurang optimal \((.+) jam\)$',
  ).firstMatch(label);
  if (sleepSuboptimal != null) {
    return l10n.resultFactorSleepSuboptimal(sleepSuboptimal.group(1)!);
  }

  final screenHours = RegExp(
    r'^(?:Paparan layar intensif|Waktu layar cukup tinggi) \((.+) jam\)$',
  ).firstMatch(label);
  if (screenHours != null) {
    return label.startsWith('Paparan')
        ? l10n.resultFactorScreenIntensive(screenHours.group(1)!)
        : l10n.resultFactorScreenHigh(screenHours.group(1)!);
  }

  final sleepLow = RegExp(
    r'^Durasi tidur kurang \((.+) jam\)$',
  ).firstMatch(label);
  if (sleepLow != null) {
    return l10n.resultFactorSleepLow(sleepLow.group(1)!);
  }

  final coffee = RegExp(
    r'^Konsumsi kafein (?:cukup )?tinggi \((.+) cangkir\)$',
  ).firstMatch(label);
  if (coffee != null) {
    return label.contains('cukup')
        ? l10n.resultFactorCoffeeModerateHigh(coffee.group(1)!)
        : l10n.resultFactorCoffeeHigh(coffee.group(1)!);
  }

  return switch (label) {
    'Durasi tidur kurang stabil' => l10n.resultExampleFactorSleep,
    'Beban aktivitas cukup tinggi' => l10n.resultExampleFactorActivity,
    'Tingkat stres yang meningkat' => l10n.resultExampleFactorStress,
    'Beban aktivitas dan stres harian tinggi' =>
      l10n.resultFactorActivityStressHigh,
    'Praktik relaksasi / meditasi sangat baik' =>
      l10n.resultFactorMeditationPositive,
    'Aktivitas dan pola istirahat seimbang' =>
      l10n.resultFactorBalancedActivityRest,
    'Tingkat stres tergolong tinggi' => l10n.resultFactorStressHigh,
    'Pola istirahat dan beban kerja terkendali' =>
      l10n.resultFactorRestWorkBalanced,
    'Evaluasi kelelahan kerja & ritme harian' =>
      l10n.resultFactorFatigueRhythm,
    'Analisis waktu istirahat dan stres' =>
      l10n.resultFactorRestStressAnalysis,
    _ => label,
  };
}

String localizeResultAnswerLabel(AppLocalizations l10n, String label) =>
    switch (label) {
      'Kualitas tidur' || 'sleep_quality' => l10n.sleepQualityReview,
      'Waktu layar' || 'screen_hours' => l10n.screenTimeReview,
      'Durasi tidur' || 'sleep_hours' => l10n.sleepDurationReview,
      'Konsumsi kopi' || 'coffee_cups' => l10n.coffeeReview,
      'Beban aktivitas' || 'activity_load' => l10n.workloadReview,
      'Meditasi' || 'meditation_minutes' => l10n.meditationReview,
      'Suasana hati' || 'mood_rating' => l10n.moodReview,
      'Tingkat stres' || 'stress_level' => l10n.resultStressLabel,
      _ => label,
    };

String localizeResultAnswerValue(
  AppLocalizations l10n,
  AssessmentAnswerSummary answer,
) {
  final normalized = answer.value.trim().toLowerCase();
  if (answer.label == 'Kualitas tidur' || answer.label == 'sleep_quality') {
    return switch (normalized) {
      'buruk' || 'poor' => l10n.sleepPoor,
      'cukup' || 'average' || 'fair' => l10n.sleepFair,
      'baik' || 'good' => l10n.sleepGood,
      'sangat baik' || 'excellent' || 'very good' => l10n.sleepVeryGood,
      _ => answer.value,
    };
  }

  if (answer.label == 'Beban aktivitas' ||
      answer.label == 'activity_load' ||
      answer.label == 'Tingkat stres' ||
      answer.label == 'stress_level') {
    return switch (normalized) {
      'ringan' || 'low' => l10n.workloadLight,
      'sedang' || 'moderate' || 'medium' => l10n.workloadModerate,
      'berat' || 'high' => l10n.workloadHeavy,
      _ => answer.value,
    };
  }

  final quantity = RegExp(
    r'^(.+?)\s+(jam|cangkir|menit)$',
    caseSensitive: false,
  ).firstMatch(answer.value.trim());
  if (quantity != null) {
    final unit = switch (quantity.group(2)!.toLowerCase()) {
      'jam' => l10n.surveyUnitHours,
      'cangkir' => l10n.surveyUnitCups,
      'menit' => l10n.surveyUnitMinutes,
      _ => quantity.group(2)!,
    };
    return '${quantity.group(1)} $unit';
  }

  return answer.value;
}
