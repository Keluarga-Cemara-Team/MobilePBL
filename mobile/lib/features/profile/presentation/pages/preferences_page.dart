import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/preferences_controller.dart';
import '../widgets/profile_subpage_scaffold.dart';

class PreferencesPage extends ConsumerWidget {
  const PreferencesPage({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final preferences = ref.watch(preferencesControllerProvider);
    final controller = ref.read(preferencesControllerProvider.notifier);

    return ProfileSubpageScaffold(
      title: l10n.profilePreferences,
      onBack: onBack,
      children: [
        ProfileInfoCard(
          text: l10n.profilePreferencesIntro,
          icon: Icons.tune_rounded,
        ),
        SizedBox(height: context.ui(28)),
        Text(
          l10n.profileAppearance,
          style: AppTextStyles.title(context)
              .copyWith(fontSize: context.ui(18)),
        ),
        SizedBox(height: context.ui(8)),
        Text(
          l10n.profileChooseTheme,
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
              for (final option in [
                (
                  ThemeMode.light,
                  Icons.light_mode_outlined,
                  l10n.profileThemeLight,
                ),
                (
                  ThemeMode.dark,
                  Icons.dark_mode_outlined,
                  l10n.profileThemeDark,
                ),
                (
                  ThemeMode.system,
                  Icons.brightness_auto_outlined,
                  l10n.profileThemeSystem,
                ),
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
          l10n.profileLanguageTitle,
          style: AppTextStyles.title(context)
              .copyWith(fontSize: context.ui(18)),
        ),
        SizedBox(height: context.ui(8)),
        Text(
          l10n.profileChooseLanguage,
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
                label: l10n.profileLanguageIndonesian,
                sublabel: l10n.profileLanguageIndonesianSubtitle,
                selected: preferences.language == AppLanguage.indonesian,
                onTap: () => controller.setLanguage(AppLanguage.indonesian),
              ),
            ),
            SizedBox(width: context.ui(12)),
            Expanded(
              child: _LanguageOptionCard(
                key: const ValueKey('language-option-en'),
                icon: Icons.translate_rounded,
                label: l10n.profileLanguageEnglish,
                sublabel: l10n.profileLanguageEnglishSubtitle,
                selected: preferences.language == AppLanguage.english,
                onTap: () => controller.setLanguage(AppLanguage.english),
              ),
            ),
          ],
        ),
        SizedBox(height: context.ui(30)),
        Text(
          l10n.profileNotifications,
          style: AppTextStyles.title(context)
              .copyWith(fontSize: context.ui(18)),
        ),
        SizedBox(height: context.ui(8)),
        Text(
          l10n.profileNotificationDescription,
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
                  l10n.profileDailyCheckIn,
                  style: AppTextStyles.subtitle(context).copyWith(
                    color: AppColors.of(context).navy,
                    fontSize: context.ui(16),
                  ),
                ),
                subtitle: Text(
                  l10n.profileDailyCheckInDescription,
                  style: AppTextStyles.subtitle(context)
                      .copyWith(fontSize: context.ui(14)),
                ),
                value: preferences.dailyReminder,
                onChanged: (val) async {
                  await controller.setDailyReminder(val);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          val
                              ? l10n.profileDailyReminderEnabled
                              : l10n.profileDailyReminderDisabled,
                        ),
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
                  l10n.profileWellbeingMotivation,
                  style: AppTextStyles.subtitle(context).copyWith(
                    color: AppColors.of(context).navy,
                    fontSize: context.ui(16),
                  ),
                ),
                subtitle: Text(
                  l10n.profileWellbeingMotivationDescription,
                  style: AppTextStyles.subtitle(context)
                      .copyWith(fontSize: context.ui(14)),
                ),
                value: preferences.wellbeingTips,
                onChanged: (val) async {
                  await controller.setWellbeingTips(val);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          val
                              ? l10n.profileMotivationEnabled
                              : l10n.profileMotivationDisabled,
                        ),
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
                      SnackBar(
                        content: Text(l10n.profileTestReminderSuccess),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.notifications_active_outlined, size: 16),
                label: Text(
                  l10n.profileTestReminder,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            SizedBox(width: context.ui(10)),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  await controller.testSendMotivation();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.profileTestMotivationSuccess),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.lightbulb_outline, size: 16),
                label: Text(
                  l10n.profileTestMotivation,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.ui(12)),
        Text(
          l10n.profileNotificationTestHint,
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
