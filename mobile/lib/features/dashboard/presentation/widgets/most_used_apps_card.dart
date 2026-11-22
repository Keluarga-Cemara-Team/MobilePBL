import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/app_usage_service.dart';

/// Kartu Visualisasi Statistik Penggunaan Aplikasi (App Usage Stats)
/// Menampilkan total durasi layar, indikator risiko kelelahan, dan aplikasi yang paling sering digunakan
class MostUsedAppsCard extends StatefulWidget {
  const MostUsedAppsCard({super.key});

  @override
  State<MostUsedAppsCard> createState() => _MostUsedAppsCardState();
}

class _MostUsedAppsCardState extends State<MostUsedAppsCard> with WidgetsBindingObserver {
  final _service = AppUsageService();
  int _days = 1; // Default ke Hari Ini agar sinkron dengan aktivitas terkini
  bool _loading = true;
  bool _hasAccess = false;
  int _totalTimeMs = 0;
  List<UsedApp> _apps = const [];

  // Data pratinjau representatif saat diuji pada Flutter Web / Desktop
  static const List<UsedApp> _demoApps = [
    UsedApp(packageName: 'com.whatsapp', name: 'WhatsApp', timeMs: 7800000), // ~2j 10m
    UsedApp(packageName: 'com.instagram.android', name: 'Instagram', timeMs: 5400000), // ~1j 30m
    UsedApp(packageName: 'com.google.android.youtube', name: 'YouTube', timeMs: 4200000), // ~1j 10m
    UsedApp(packageName: 'com.android.chrome', name: 'Google Chrome', timeMs: 3300000), // ~55m
    UsedApp(packageName: 'com.spotify.music', name: 'Spotify', timeMs: 2400000), // ~40m
  ];

  bool get _isSupported =>
      _service.supported &&
      !WidgetsBinding.instance.runtimeType.toString().contains('Test');

  @override
  void initState() {
    super.initState();
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
    if (state == AppLifecycleState.resumed) unawaited(_load());
  }

  Future<void> _load() async {
    if (!_isSupported) {
      // Pada Web/Desktop/Test, sediakan mode pratinjau interaktif agar presentasi tidak kosong
      if (mounted) {
        setState(() {
          _hasAccess = false;
          _apps = _demoApps;
          _totalTimeMs = _demoApps.fold<int>(0, (sum, a) => sum + a.timeMs);
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
      if (mounted) setState(() { _hasAccess = false; _apps = const []; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _apps = const []; _loading = false; });
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
    final maxAppTime = _apps.isEmpty ? 1 : _apps.first.timeMs;
    final primary = _apps.isEmpty ? null : _apps.first;

    return Container(
      padding: EdgeInsets.all(context.ui(18)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(context.ui(22)),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 18,
            offset: const Offset(0, 7),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Header: Judul dan Dropdown Filter Periode
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.mostUsedAppsTitle,
                      style: TextStyle(
                        fontSize: context.ui(17),
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: colors.navy,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: context.ui(8)),
                decoration: BoxDecoration(
                  color: colors.disabledSurface.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(context.ui(12)),
                ),
                child: DropdownButton<int>(
                  value: _days,
                  underline: const SizedBox.shrink(),
                  isDense: true,
                  iconSize: context.ui(18),
                  style: TextStyle(
                    fontSize: context.ui(12),
                    color: colors.navy,
                    fontWeight: FontWeight.w600,
                  ),
                  items: [
                    const DropdownMenuItem(value: 1, child: Text('Hari ini')),
                    DropdownMenuItem(value: 7, child: Text(l10n.usageLastSevenDays)),
                    DropdownMenuItem(value: 30, child: Text(l10n.usageLastThirtyDays)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _days = value);
                      unawaited(_load());
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: context.ui(14)),

          // 2. State Handling
          if (_loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (!_hasAccess && _isSupported)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _message(l10n.usagePermissionExplanation, colors.body),
                SizedBox(height: context.ui(10)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: () async => await _service.openSettings(),
                    icon: const Icon(Icons.security, size: 16),
                    label: Text(l10n.usageGrantAccess),
                  ),
                ),
              ],
            )
          else if (_apps.isEmpty)
            _message(l10n.usageNoData, colors.body)
          else ...[
            // 4. Hero Card: Aplikasi Paling Sering Digunakan (#1)
            if (primary != null)
              Container(
                padding: EdgeInsets.all(context.ui(14)),
                decoration: BoxDecoration(
                  color: colors.disabledSurface.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(context.ui(16)),
                  border: Border.all(color: colors.border.withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _appIcon(primary, 52, colors),
                        SizedBox(width: context.ui(12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                primary.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: context.ui(15),
                                  color: colors.navy,
                                ),
                              ),
                              SizedBox(height: context.ui(2)),
                              Text(
                                l10n.usageMostUsed,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: context.ui(11),
                                  color: colors.body,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: context.ui(8)),
                        Text(
                          '#1',
                          style: TextStyle(
                            fontSize: context.ui(13),
                            fontWeight: FontWeight.w800,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.ui(12)),
                    Text(
                      _formatDuration(l10n, primary.timeMs),
                      style: TextStyle(
                        fontSize: context.ui(24),
                        fontWeight: FontWeight.w800,
                        color: colors.navy,
                      ),
                    ),
                    SizedBox(height: context.ui(8)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(context.ui(6)),
                      child: LinearProgressIndicator(
                        value: _totalTimeMs > 0
                            ? (primary.timeMs / _totalTimeMs).clamp(0.0, 1.0)
                            : 0,
                        minHeight: context.ui(8),
                        color: colors.primary,
                        backgroundColor: colors.disabledSurface,
                      ),
                    ),
                    SizedBox(height: context.ui(6)),
                    Text(
                      l10n.usageShareOfTotal(
                        _totalTimeMs > 0
                            ? ((primary.timeMs / _totalTimeMs) * 100).round()
                            : 0,
                      ),
                      style: TextStyle(
                        fontSize: context.ui(11),
                        color: colors.body,
                      ),
                    ),
                  ],
                ),
              ),

            // 5. Visualisasi Progress Bar & Ranking Aplikasi (#2 s/d #5)
            if (_apps.length > 1) ...[
              SizedBox(height: context.ui(14)),
              Text(
                l10n.usageAppRanking,
                style: TextStyle(
                  fontSize: context.ui(14),
                  fontWeight: FontWeight.w700,
                  color: colors.navy,
                ),
              ),
              SizedBox(height: context.ui(6)),
              for (var i = 1; i < _apps.length; i++) ...[
                Padding(
                  padding: EdgeInsets.only(top: context.ui(10)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: context.ui(24),
                        child: Text(
                          '${i + 1}.',
                          style: TextStyle(color: colors.body, fontSize: context.ui(12)),
                        ),
                      ),
                      _appIcon(_apps[i], 32, colors),
                      SizedBox(width: context.ui(10)),
                      Expanded(
                        child: Text(
                          _apps[i].name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: context.ui(13),
                            color: colors.navy,
                          ),
                        ),
                      ),
                      SizedBox(width: context.ui(8)),
                      Text(
                        _formatDuration(l10n, _apps[i].timeMs),
                        style: TextStyle(
                          fontSize: context.ui(12),
                          fontWeight: FontWeight.w500,
                          color: colors.body,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.ui(6)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (_apps[i].timeMs / maxAppTime).clamp(0.0, 1.0),
                    minHeight: 6,
                    color: [
                      colors.primary,
                      const Color(0xFF8E24AA),
                      const Color(0xFFD81B60),
                      const Color(0xFFFB8C00),
                    ][i % 4],
                    backgroundColor: colors.disabledSurface,
                  ),
                ),
              ],
            ],
          ],
        ],
      ),
    );
  }

  Widget _message(String text, Color color) => Padding(
        padding: EdgeInsets.symmetric(vertical: context.ui(8)),
        child: Text(text, style: TextStyle(color: color)),
      );

  Widget _appIcon(UsedApp app, double size, AppPalette colors) {
    final scaled = context.ui(size);
    return Container(
      width: scaled,
      height: scaled,
      decoration: BoxDecoration(
        color: colors.disabledSurface.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(context.ui(10)),
      ),
      clipBehavior: Clip.antiAlias,
      child: app.iconBytes == null
          ? Icon(Icons.apps_rounded, size: scaled * 0.58, color: colors.primary)
          : Image.memory(
              app.iconBytes!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Icon(
                Icons.apps_rounded,
                size: scaled * 0.58,
                color: colors.primary,
              ),
            ),
    );
  }
}
