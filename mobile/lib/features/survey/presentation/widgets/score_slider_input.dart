import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Rating tiers reflecting fatigue and mood levels every 20-point milestone (0, 20, 40, 60, 80, 100).
enum MoodScoreTier {
  severeFatigue(
    score: 0,
    emoji: '😫',
    colorLight: Color(0xFFEF4444),
    colorDark: Color(0xFFF87171),
  ),
  fatigued(
    score: 20,
    emoji: '🥱',
    colorLight: Color(0xFFF97316),
    colorDark: Color(0xFFFB923C),
  ),
  neutral(
    score: 40,
    emoji: '😐',
    colorLight: Color(0xFF64748B),
    colorDark: Color(0xFF94A3B8),
  ),
  refreshed(
    score: 60,
    emoji: '🙂',
    colorLight: Color(0xFF0D9488),
    colorDark: Color(0xFF2DD4BF),
  ),
  energetic(
    score: 80,
    emoji: '😄',
    colorLight: Color(0xFF4F46E5),
    colorDark: Color(0xFF818CF8),
  ),
  optimal(
    score: 100,
    emoji: '🥰',
    colorLight: Color(0xFF9333EA),
    colorDark: Color(0xFFC084FC),
  );

  const MoodScoreTier({
    required this.score,
    required this.emoji,
    required this.colorLight,
    required this.colorDark,
  });

  final int score;
  final String emoji;
  final Color colorLight;
  final Color colorDark;

  Color color(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? colorDark : colorLight;
  }

  static MoodScoreTier fromValue(double value) {
    final clamped = value.clamp(0.0, 100.0);
    if (clamped < 20) return MoodScoreTier.severeFatigue;
    if (clamped < 40) return MoodScoreTier.fatigued;
    if (clamped < 60) return MoodScoreTier.neutral;
    if (clamped < 80) return MoodScoreTier.refreshed;
    if (clamped < 95) return MoodScoreTier.energetic;
    return MoodScoreTier.optimal;
  }

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      MoodScoreTier.severeFatigue => l10n.surveyMoodScoreExhausted,
      MoodScoreTier.fatigued => l10n.surveyMoodScoreFatigued,
      MoodScoreTier.neutral => l10n.surveyMoodScoreNeutral,
      MoodScoreTier.refreshed => l10n.surveyMoodScoreRefreshed,
      MoodScoreTier.energetic => l10n.surveyMoodScoreEnergetic,
      MoodScoreTier.optimal => l10n.surveyMoodScoreOptimal,
    };
  }
}

class _EmojiSlot {
  const _EmojiSlot({
    required this.dx,
    required this.dy,
    required this.size,
    required this.rotation,
    required this.phase,
  });

  final double dx;
  final double dy;
  final double size;
  final double rotation;
  final double phase;
}

const _slots = [
  // 0: Top-Left (framing top-left of score)
  _EmojiSlot(dx: -64, dy: -46, size: 24, rotation: -0.18, phase: 0.0),
  // 1: Top-Center (above score)
  _EmojiSlot(dx: -8, dy: -56, size: 28, rotation: 0.05, phase: 1.3),
  // 2: Top-Right (framing top-right of score)
  _EmojiSlot(dx: 52, dy: -46, size: 25, rotation: 0.20, phase: 2.6),
  // 3: Middle-Right (to the right of score)
  _EmojiSlot(dx: 68, dy: 4, size: 23, rotation: 0.12, phase: 3.9),
  // 4: Bottom-Left (to the left of score)
  _EmojiSlot(dx: -68, dy: 8, size: 24, rotation: -0.14, phase: 5.2),
];

/// Interactive score slider with orbiting emoji constellation reflecting fatigue/mood.
class ScoreSliderInput extends StatefulWidget {
  const ScoreSliderInput({
    super.key,
    required this.value,
    required this.maximum,
    required this.onChanged,
    this.minLabel,
    this.maxLabel,
    this.unitLabel,
    this.animate = true,
  });

  final double value;
  final double maximum;
  final ValueChanged<double> onChanged;
  final String? minLabel;
  final String? maxLabel;
  final String? unitLabel;
  final bool animate;

  @override
  State<ScoreSliderInput> createState() => _ScoreSliderInputState();
}

class _ScoreSliderInputState extends State<ScoreSliderInput>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  MoodScoreTier? _currentTier;

  bool get _isTest =>
      WidgetsBinding.instance.runtimeType.toString().contains('Test');

  @override
  void initState() {
    super.initState();
    _currentTier = MoodScoreTier.fromValue(widget.value);
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    if (widget.animate && !_isTest) {
      _floatController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant ScoreSliderInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final updatedTier = MoodScoreTier.fromValue(widget.value);
    if (updatedTier != _currentTier) {
      _currentTier = updatedTier;
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  void _onSliderChanged(double newValue) {
    final newTier = MoodScoreTier.fromValue(newValue);
    if (newTier != _currentTier) {
      _currentTier = newTier;
      HapticFeedback.selectionClick();
    }
    widget.onChanged((newValue * 2).round() / 2);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tier = MoodScoreTier.fromValue(widget.value);
    final tierColor = tier.color(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: context.ui(250),
          height: context.ui(140),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Subtle radial backdrop glow
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: context.ui(140),
                height: context.ui(140),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      tierColor.withValues(alpha: 0.14),
                      tierColor.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),

              // Central Score display
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: AppTextStyles.title(context).copyWith(
                      color: tierColor,
                      fontSize: context.ui(48),
                      fontWeight: FontWeight.w800,
                    ),
                    child: Text(
                      widget.value.round().toString(),
                      key: const ValueKey('mood-score-number'),
                    ),
                  ),
                  SizedBox(height: context.ui(2)),
                  Text(
                    widget.unitLabel ?? l10n.surveyOutOf100,
                    style: AppTextStyles.subtitle(context).copyWith(
                      fontSize: context.ui(13),
                      color: AppColors.of(context).body.withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(height: context.ui(6)),
                  _MoodBadge(tier: tier),
                ],
              ),

              // Orbiting emoji constellation
              for (var i = 0; i < _slots.length; i++)
                _buildOrbitingEmoji(context, i, _slots[i], tier),
            ],
          ),
        ),
        SizedBox(height: context.ui(18)),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: context.ui(6),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: context.ui(9)),
            overlayShape: RoundSliderOverlayShape(overlayRadius: context.ui(18)),
            activeTrackColor: tierColor,
            thumbColor: tierColor,
            inactiveTrackColor: AppColors.of(context).blob,
            overlayColor: tierColor.withValues(alpha: 0.16),
          ),
          child: Slider(
            value: widget.value.clamp(0.0, widget.maximum),
            min: 0,
            max: widget.maximum,
            onChanged: _onSliderChanged,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                widget.minLabel ?? l10n.surveyVeryUncomfortable,
                style: AppTextStyles.subtitle(context)
                    .copyWith(fontSize: context.ui(10)),
              ),
            ),
            Expanded(
              child: Text(
                widget.maxLabel ?? l10n.surveyVeryComfortable,
                textAlign: TextAlign.end,
                style: AppTextStyles.subtitle(context)
                    .copyWith(fontSize: context.ui(10)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrbitingEmoji(
    BuildContext context,
    int index,
    _EmojiSlot slot,
    MoodScoreTier tier,
  ) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final floatY = _floatController.isAnimating
            ? math.sin(_floatController.value * 2 * math.pi + slot.phase) *
                context.ui(2.6)
            : 0.0;
        return Transform.translate(
          offset: Offset(
            context.ui(slot.dx),
            context.ui(slot.dy) + floatY,
          ),
          child: Transform.rotate(
            angle: slot.rotation,
            child: child,
          ),
        );
      },
      child: IgnorePointer(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOutBack,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: KeyedSubtree(
            key: ValueKey('emoji_${tier.name}_$index'),
            child: Text(
              tier.emoji,
              style: TextStyle(
                fontSize: context.ui(slot.size),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodBadge extends StatelessWidget {
  const _MoodBadge({required this.tier});

  final MoodScoreTier tier;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = tier.color(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(
        horizontal: context.ui(10),
        vertical: context.ui(3),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(context.ui(16)),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Text(
          tier.localizedLabel(l10n),
          key: ValueKey('mood_label_${tier.name}'),
          style: AppTextStyles.subtitle(context).copyWith(
            fontSize: context.ui(11),
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
