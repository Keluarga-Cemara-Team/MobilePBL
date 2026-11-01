import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../controllers/preferences_controller.dart';
import '../widgets/profile_subpage_scaffold.dart';

class PreferencesPage extends ConsumerWidget {
  const PreferencesPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(preferencesControllerProvider);
    final controller = ref.read(preferencesControllerProvider.notifier);

    return ProfileSubpageScaffold(
      title: 'Preferensi',
      onBack: onBack,
      children: [
        const ProfileInfoCard(
          text:
              'Sesuaikan tampilan tema, bahasa, serta jadwal pengingat check-in harian dan motivasi untuk mendukung kesehatan mentalmu.',
          icon: Icons.tune_rounded,
        ),
        SizedBox(height: context.ui(28)),
        Text(
          'Tampilan',
          style: AppTextStyles.title(context)
              .copyWith(fontSize: context.ui(18)),
        ),
        SizedBox(height: context.ui(8)),
        Text(
          'Pilih tema yang paling nyaman untukmu.',
          style: AppTextStyles.subtitle(context)
              .copyWith(fontSize: context.ui(14)),
        ),
        SizedBox(height: context.ui(16)),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked =
                constraints.maxWidth < 300 ||
                MediaQuery.textScalerOf(context).scale(14) > 20;
            final options = [
              for (final option in const [
                (ThemeMode.light, Icons.light_mode_outlined, 'Terang'),
                (ThemeMode.dark, Icons.dark_mode_outlined, 'Gelap'),
                (ThemeMode.system, Icons.brightness_auto_outlined, 'Sistem'),
              ])
                _ThemeOptionCard(
                  key: ValueKey('theme-option-${option.$1.name}'),
                  icon: option.$2,
                  label: option.$3,
                  selected: preferences.themeMode == option.$1,
                  stacked: stacked,
                  onTap: () => controller.setThemeMode(option.$1),
                ),
            ];
            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < options.length; i++) ...[
                    if (i > 0) SizedBox(height: context.ui(10)),
                    options[i],
                  ],
                ],
              );
            }
            return Row(
              children: [
                for (var i = 0; i < options.length; i++) ...[
                  if (i > 0) SizedBox(width: context.ui(10)),
                  Expanded(child: options[i]),
                ],
              ],
            );
          },
        ),
        SizedBox(height: context.ui(30)),
        Text(
          'Bahasa / Language',
          style: AppTextStyles.title(context)
              .copyWith(fontSize: context.ui(18)),
        ),
        SizedBox(height: context.ui(8)),
        Text(
          'Pilih bahasa yang digunakan pada aplikasi.',
          style: AppTextStyles.subtitle(context)
              .copyWith(fontSize: context.ui(14)),
        ),
        SizedBox(height: context.ui(16)),
        Row(
          children: [
            Expanded(
              child: _LanguageOptionCard(
                key: const ValueKey('language-option-id'),
                icon: Icons.language_rounded,
                label: 'Indonesia',
                sublabel: 'Bahasa Indonesia',
                selected: preferences.language == AppLanguage.indonesian,
                onTap: () => controller.setLanguage(AppLanguage.indonesian),
              ),
            ),
            SizedBox(width: context.ui(12)),
            Expanded(
              child: _LanguageOptionCard(
                key: const ValueKey('language-option-en'),
                icon: Icons.translate_rounded,
                label: 'English',
                sublabel: 'United States',
                selected: preferences.language == AppLanguage.english,
                onTap: () => controller.setLanguage(AppLanguage.english),
              ),
            ),
          ],
        ),
        SizedBox(height: context.ui(30)),
        Text(
          'Pengingat & Notifikasi',
          style: AppTextStyles.title(context)
              .copyWith(fontSize: context.ui(18)),
        ),
        SizedBox(height: context.ui(8)),
        Text(
          'Pilih mode notifikasi yang ingin kamu aktifkan untuk mendukung rutinitas harianmu.',
          style: AppTextStyles.subtitle(context)
              .copyWith(fontSize: context.ui(14)),
        ),
        SizedBox(height: context.ui(16)),
        Material(
          color: AppColors.of(context).surface,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.ui(16)),
            side: BorderSide(color: AppColors.of(context).border),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: Text(
                  'Reminder Harian (Check-in)',
                  style: AppTextStyles.subtitle(context).copyWith(
                    color: AppColors.of(context).navy,
                    fontSize: context.ui(16),
                  ),
                ),
                subtitle: Text(
                  'Pengingat otomatis setiap pagi (09:00) untuk evaluasi tingkat burnout.',
                  style: AppTextStyles.subtitle(context)
                      .copyWith(fontSize: context.ui(14)),
                ),
                value: preferences.dailyReminder,
                onChanged: (val) async {
                  await controller.setDailyReminder(val);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(val
                            ? 'Pengingat harian dijadwalkan setiap 09:00 WIB'
                            : 'Pengingat harian dinonaktifkan'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                activeThumbColor: AppColors.of(context).primary,
                contentPadding: EdgeInsets.all(context.ui(16)),
              ),
              Divider(height: 1, color: AppColors.of(context).border),
              SwitchListTile(
                title: Text(
                  'Motivasi Sederhana',
                  style: AppTextStyles.subtitle(context).copyWith(
                    color: AppColors.of(context).navy,
                    fontSize: context.ui(16),
                  ),
                ),
                subtitle: Text(
                  'Kutipan penyemangat & afirmasi rileksasi setiap siang (14:00).',
                  style: AppTextStyles.subtitle(context)
                      .copyWith(fontSize: context.ui(14)),
                ),
                value: preferences.wellbeingTips,
                onChanged: (val) async {
                  await controller.setWellbeingTips(val);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(val
                            ? 'Motivasi harian dijadwalkan setiap 14:00 WIB'
                            : 'Motivasi harian dinonaktifkan'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                activeThumbColor: AppColors.of(context).primary,
                contentPadding: EdgeInsets.all(context.ui(16)),
              ),
            ],
          ),
        ),
        SizedBox(height: context.ui(14)),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  await controller.testSendDailyReminder();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notifikasi Reminder Harian berhasil dikirim!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.notifications_active_outlined, size: 16),
                label: const Text('Tes Reminder', style: TextStyle(fontSize: 12)),
              ),
            ),
            SizedBox(width: context.ui(10)),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  await controller.testSendMotivation();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notifikasi Motivasi berhasil dikirim!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.lightbulb_outline, size: 16),
                label: const Text('Tes Motivasi', style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
        SizedBox(height: context.ui(12)),
        Text(
          'Gunakan tombol tes di atas untuk mencoba preview notifikasi secara instan pada perangkat.',
          style: AppTextStyles.subtitle(context)
              .copyWith(fontSize: context.ui(12)),
        ),
      ],
    );
  }
}

class _LanguageOptionCard extends StatelessWidget {
  const _LanguageOptionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String sublabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.ui(14)),
      side: BorderSide(color: selected ? colors.primary : colors.border),
    );

    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? colors.blob : colors.surface,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.ui(12),
              vertical: context.ui(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: context.ui(24),
                  color: selected ? colors.primary : colors.body,
                ),
                SizedBox(height: context.ui(8)),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle(context).copyWith(
                    fontSize: context.ui(14),
                    color: selected ? colors.primary : colors.body,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                SizedBox(height: context.ui(2)),
                Text(
                  sublabel,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle(context).copyWith(
                    fontSize: context.ui(11),
                    color: colors.body.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  const _ThemeOptionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.stacked,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool stacked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.ui(14)),
      side: BorderSide(color: selected ? colors.primary : colors.border),
    );
    final text = Text(
      label,
      textAlign: TextAlign.center,
      style: AppTextStyles.subtitle(context).copyWith(
        fontSize: context.ui(14),
        color: selected ? colors.primary : colors.body,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
      ),
    );
    final symbol = Icon(
      icon,
      size: context.ui(24),
      color: selected ? colors.primary : colors.body,
    );
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? colors.blob : colors.surface,
        shape: shape,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.ui(12),
              vertical: context.ui(16),
            ),
            child: stacked
                ? Row(
                    children: [
                      symbol,
                      SizedBox(width: context.ui(12)),
                      Expanded(child: text),
                      if (selected)
                        Icon(
                          Icons.check_rounded,
                          color: colors.primary,
                          size: context.ui(24),
                        ),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      symbol,
                      SizedBox(height: context.ui(8)),
                      text,
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
