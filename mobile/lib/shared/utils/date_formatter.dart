String formatAssessmentDate(
  DateTime date, {
  bool includeTime = false,
  bool english = false,
}) {
  const indonesianMonths = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  const englishMonths = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  final local = date.toLocal();
  final months = english ? englishMonths : indonesianMonths;
  final label = english
      ? '${months[local.month - 1]} ${local.day}, ${local.year}'
      : '${local.day} ${months[local.month - 1]} ${local.year}';
  if (!includeTime) return label;
  final hh = local.hour.toString().padLeft(2, '0');
  final mm = local.minute.toString().padLeft(2, '0');
  return '$label • $hh:$mm';
}
