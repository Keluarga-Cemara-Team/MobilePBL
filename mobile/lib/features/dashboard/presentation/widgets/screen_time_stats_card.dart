import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/app_usage_service.dart';

/// Kartu statistik waktu layar (Screen Time Statistics) di Dashboard
/// Menampilkan durasi layar harian, perbandingan batas sehat, indikator risiko kelelahan digital,
/// serta distribusi pemakaian aplikasi untuk mendeteksi potensi burnout.
class ScreenTimeStatsCard extends StatefulWidget {
  const ScreenTimeStatsCard({
    super.key,
    this.initialDays = 1,
  });

  final int initialDays;

  @override
  State<ScreenTimeStatsCard> createState() => _ScreenTimeStatsCardState();
}

class _ScreenTimeStatsCardState extends State<ScreenTimeStatsCard>
    with WidgetsBindingObserver {
  final _service = AppUsageService();
  late int _days;
  bool _loading = true;
  bool _hasAccess = false;
  int _totalTimeMs = 0;
  List<UsedApp> _apps = const [];

  // Data contoh realistis untuk mode pratinjau Web / Desktop / Test
  static const List<UsedApp> _demoApps = [
    UsedApp(packageName: 'com.whatsapp', name: 'WhatsApp', timeMs: 7800000), // ~2j 10m
    UsedApp(packageName: 'com.instagram.android', name: 'Instagram', timeMs: 5400000), // ~1j 30m
    UsedApp(packageName: 'com.google.android.youtube', name: 'YouTube', timeMs: 4200000), // ~1j 10m
    UsedApp(packageName: 'com.android.chrome', name: 'Chrome', timeMs: 3300000), // ~55m
    UsedApp(packageName: 'com.spotify.music', name: 'Spotify', timeMs: 2400000), // ~40m
  ];

  bool get _isSupported =>
      _service.supported &&
      !WidgetsBinding.instance.runtimeType.toString().contains('Test');

  @override
  void initState() {
    super.initState();
    _days = widget.initialDays;
    WidgetsBinding.instance.addObserver(this);
    unawaited(_load());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_load());
    }
  }

  Future<void> _load() async {
    if (!_isSupported) {
      if (mounted) {
        setState(() {
          _hasAccess = false;
          _apps = _demoApps;
          final baseOneDay = _demoApps.fold<int>(0, (sum, a) => sum + a.timeMs);
          _totalTimeMs = baseOneDay * _days;
          _loading = false;
        });
      }
      return;
    }

    if (mounted) setState(() => _loading = true);
    try {
      final access = await _service.hasAccess();
      final apps = access ? await _service.mostUsed(days: _days) : const <UsedApp>[];
      final totalMs = access ? await _service.getTotalUsageTime(days: _days) : 0;

      if (mounted) {
        setState(() {
          _hasAccess = access;
          _apps = apps;
          _totalTimeMs = totalMs > 0 ? totalMs : apps.fold<int>(0, (sum, a) => sum + a.timeMs);
          _loading = false;
        });
      }
    } on PlatformException {
      if (mounted) {
        setState(() {
          _hasAccess = false;
          _apps = const [];
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _apps = const [];
          _loading = false;
        });
      }
    }
  }

  String _formatDuration(AppLocalizations l10n, int ms) {
    final minutes = (ms / 60000).round();
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final remainder = minutes % 60;
      return remainder == 0
          ? l10n.usageHours(hours)
          : l10n.usageHoursMinutes(hours, remainder);
    }
    return l10n.usageMinutes(minutes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = AppColors.of(context);

    // Hitung rata-rata waktu layar harian (jam)
    final dailyHours = _totalTimeMs / (_days * 3600000.0);

    // Kategori risiko kelelahan berdasarkan waktu layar
    final (fatigueTitle, fatigueColor, fatigueIcon) = switch (dailyHours) {
      >= 7.0 => (
          l10n.screenTimeFatigueHigh,
          const Color(0xFFEF4444),
          Icons.warning_amber_rounded,
        ),
      >= 4.0 => (
          l10n.screenTimeFatigueMedium,
          const Color(0xFFF59E0B),
          Icons.schedule_rounded,
        ),
      _ => (
          l10n.screenTimeFatigueLow,
          const Color(0xFF10B981),
          Icons.check_circle_outline_rounded,
        ),
    };

    return Container(
      padding: EdgeInsets.all(context.ui(20)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(context.ui(22)),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header: Ikon, Judul, Subtitle & Tombol Refresh
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(context.ui(10)),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(context.ui(14)),
                ),
                child: Icon(
                  Icons.devices_rounded,
                  size: context.ui(22),
                  color: colors.primary,
                ),
              ),
              SizedBox(width: context.ui(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.screenTimeStatsTitle,
                      style: TextStyle(
                        fontSize: context.ui(18),
                        fontWeight: FontWeight.w700,
                        color: colors.navy,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _loading ? null : () => unawaited(_load()),
                tooltip: 'Refresh',
                icon: Icon(
                  Icons.refresh_rounded,
                  size: context.ui(20),
                  color: colors.body,
                ),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          SizedBox(height: context.ui(14)),

          // 2. Filter Selector Tab (Hari Ini | 7 Hari | 30 Hari)
          _buildPeriodTabs(context, l10n, colors),
          SizedBox(height: context.ui(16)),

          // 3. Content State
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 36),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (!_hasAccess && _isSupported)
            _buildPermissionPrompt(context, l10n, colors)
          else ...[
            // 4. Hero Metric: Total Screen Time & Indikator Rata-Rata
            _buildHeroScreenTime(context, l10n, colors, dailyHours),
            SizedBox(height: context.ui(14)),

            // 5. Indikator Risiko Kelelahan Layar
            _buildFatigueIndicator(context, fatigueTitle, fatigueColor, fatigueIcon),
            SizedBox(height: context.ui(16)),

            // 6. Visualisasi Distribusi Aplikasi Terbanyak
            if (_apps.isNotEmpty) ...[
              _buildAppDistribution(context, l10n, colors),
              SizedBox(height: context.ui(16)),
            ],

            // 7. Kartu Tips Kesehatan Digital / Anti-Burnout
            _buildTipBox(context, l10n, colors),
          ],
        ],
      ),
    );
  }

  Widget _buildPeriodTabs(
    BuildContext context,
    AppLocalizations l10n,
    AppPalette colors,
  ) {
    return Container(
      padding: EdgeInsets.all(context.ui(4)),
      decoration: BoxDecoration(
        color: colors.disabledSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(context.ui(12)),
      ),
      child: Row(
        children: [
          _buildTabItem(context, label: l10n.screenTimeTodayTab, days: 1, colors: colors),
          _buildTabItem(context, label: l10n.screenTimeSevenDaysTab, days: 7, colors: colors),
          _buildTabItem(context, label: l10n.screenTimeThirtyDaysTab, days: 30, colors: colors),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context, {
    required String label,
    required int days,
    required AppPalette colors,
  }) {
    final isSelected = _days == days;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_days != days) {
            setState(() => _days = days);
            unawaited(_load());
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: context.ui(8)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? colors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(context.ui(10)),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: colors.shadow.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: context.ui(12),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? colors.primary : colors.body,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroScreenTime(
    BuildContext context,
    AppLocalizations l10n,
    AppPalette colors,
    double dailyHours,
  ) {
    const healthyTargetHours = 6.0;
    final progress = (dailyHours / healthyTargetHours).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(context.ui(16)),
      decoration: BoxDecoration(
        color: colors.disabledSurface.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(context.ui(16)),
        border: Border.all(color: colors.border.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  _days == 1
                      ? 'Total Waktu Layar Hari Ini'
                      : 'Total Waktu Layar ($_days Hari)',
                  style: TextStyle(
                    fontSize: context.ui(12),
                    fontWeight: FontWeight.w600,
                    color: colors.body,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: context.ui(8)),
              Text(
                l10n.screenTimeHealthyLimit(healthyTargetHours.toStringAsFixed(0)),
                style: TextStyle(
                  fontSize: context.ui(11),
                  fontWeight: FontWeight.w500,
                  color: colors.body.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          SizedBox(height: context.ui(6)),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: context.ui(8),
            runSpacing: context.ui(4),
            children: [
              Text(
                _formatDuration(l10n, _totalTimeMs),
                key: const ValueKey('screen-time-total-value'),
                style: TextStyle(
                  fontSize: context.ui(26),
                  fontWeight: FontWeight.w800,
                  color: colors.navy,
                ),
              ),
              if (_days > 1)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.ui(8),
                    vertical: context.ui(2),
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(context.ui(20)),
                  ),
                  child: Text(
                    l10n.screenTimeDailyAverage(dailyHours.toStringAsFixed(1)),
                    style: TextStyle(
                      fontSize: context.ui(11.5),
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: context.ui(10)),

          // Progress Bar terhadap batas sehat
          ClipRRect(
            borderRadius: BorderRadius.circular(context.ui(6)),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: context.ui(8),
              backgroundColor: colors.disabledSurface,
              valueColor: AlwaysStoppedAnimation<Color>(
                dailyHours >= 7.0
                    ? const Color(0xFFEF4444)
                    : dailyHours >= 4.0
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF10B981),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFatigueIndicator(
    BuildContext context,
    String title,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.ui(14),
        vertical: context.ui(10),
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(context.ui(14)),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: context.ui(22), color: color),
          SizedBox(width: context.ui(10)),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: context.ui(13),
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppDistribution(
    BuildContext context,
    AppLocalizations l10n,
    AppPalette colors,
  ) {
    final topApps = _apps.take(4).toList();
    final topAppsSumMs = topApps.fold<int>(0, (sum, a) => sum + a.timeMs);
    final otherMs = (_totalTimeMs - topAppsSumMs).clamp(0, double.infinity).toInt();

    const segmentColors = [
      Color(0xFF4F46E5), // Indigo
      Color(0xFF8B5CF6), // Purple
      Color(0xFFEC4899), // Pink
      Color(0xFFF97316), // Orange
      Color(0xFF94A3B8), // Slate (Others)
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.screenTimeTopAppsShare,
          style: TextStyle(
            fontSize: context.ui(13),
            fontWeight: FontWeight.w700,
            color: colors.navy,
          ),
        ),
        SizedBox(height: context.ui(8)),

        // Segmented Horizontal Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(context.ui(8)),
          child: SizedBox(
            height: context.ui(10),
            child: Row(
              children: [
                for (var i = 0; i < topApps.length; i++) ...[
                  if (_totalTimeMs > 0 && topApps[i].timeMs > 0)
                    Expanded(
                      flex: (topApps[i].timeMs / _totalTimeMs * 100).round().clamp(1, 100),
                      child: Container(color: segmentColors[i % segmentColors.length]),
                    ),
                ],
                if (_totalTimeMs > 0 && otherMs > 0)
                  Expanded(
                    flex: (otherMs / _totalTimeMs * 100).round().clamp(1, 100),
                    child: Container(color: segmentColors.last),
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: context.ui(10)),

        // Legend Pills
        Wrap(
          spacing: context.ui(8),
          runSpacing: context.ui(6),
          children: [
            for (var i = 0; i < topApps.length; i++) ...[
              _buildLegendPill(
                context,
                name: topApps[i].name,
                percentage: _totalTimeMs > 0
                    ? ((topApps[i].timeMs / _totalTimeMs) * 100).round()
                    : 0,
                color: segmentColors[i % segmentColors.length],
              ),
            ],
            if (otherMs > 0)
              _buildLegendPill(
                context,
                name: l10n.screenTimeOtherApps,
                percentage: _totalTimeMs > 0
                    ? ((otherMs / _totalTimeMs) * 100).round()
                    : 0,
                color: segmentColors.last,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendPill(
    BuildContext context, {
    required String name,
    required int percentage,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: context.ui(8),
          height: context.ui(8),
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        SizedBox(width: context.ui(4)),
        Text(
          '$name $percentage%',
          style: TextStyle(
            fontSize: context.ui(11),
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildTipBox(
    BuildContext context,
    AppLocalizations l10n,
    AppPalette colors,
  ) {
    return Container(
      padding: EdgeInsets.all(context.ui(12)),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(context.ui(12)),
        border: Border.all(color: colors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: context.ui(18),
            color: colors.primary,
          ),
          SizedBox(width: context.ui(8)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.screenTimeTipTitle,
                  style: TextStyle(
                    fontSize: context.ui(12),
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                  ),
                ),
                SizedBox(height: context.ui(2)),
                Text(
                  l10n.screenTimeTip202020,
                  style: TextStyle(
                    fontSize: context.ui(11),
                    color: colors.navy.withValues(alpha: 0.8),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionPrompt(
    BuildContext context,
    AppLocalizations l10n,
    AppPalette colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.usagePermissionExplanation,
          style: TextStyle(fontSize: context.ui(12), color: colors.body),
        ),
        SizedBox(height: context.ui(12)),
        FilledButton.icon(
          onPressed: () async => await _service.openSettings(),
          icon: const Icon(Icons.security, size: 16),
          label: Text(l10n.usageGrantAccess),
          style: FilledButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
          ),
        ),
      ],
    );
  }
}
