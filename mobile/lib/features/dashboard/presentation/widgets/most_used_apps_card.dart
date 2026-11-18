import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/l10n/app_localizations.dart';

import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/app_usage_service.dart';

class MostUsedAppsCard extends StatefulWidget {
  const MostUsedAppsCard({super.key});

  @override
  State<MostUsedAppsCard> createState() => _MostUsedAppsCardState();
}

class _MostUsedAppsCardState extends State<MostUsedAppsCard> with WidgetsBindingObserver {
  final _service = AppUsageService();
  int _days = 7;
  bool _loading = true;
  bool _hasAccess = false;
  List<UsedApp> _apps = const [];

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
    if (!_service.supported) {
      if (mounted) setState(() { _hasAccess = false; _loading = false; });
      return;
    }
    if (mounted) setState(() => _loading = true);
    try {
      final access = await _service.hasAccess();
      final apps = access ? await _service.mostUsed(days: _days) : const <UsedApp>[];
      if (mounted) setState(() { _hasAccess = access; _apps = apps; _loading = false; });
    } on PlatformException {
      if (mounted) setState(() { _hasAccess = false; _apps = const []; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _apps = const []; _loading = false; });
    }
  }

  String _duration(AppLocalizations l10n, int ms) {
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
    final primary = _apps.isEmpty ? null : _apps.first;
    final maxTime = _apps.isEmpty ? 1 : _apps.first.timeMs;
    return Container(
      padding: EdgeInsets.all(context.ui(18)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(context.ui(22)),
        border: Border.all(color: colors.border),
        boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 18, offset: const Offset(0, 7))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(child: Text(l10n.mostUsedAppsTitle, style: TextStyle(fontSize: context.ui(18), height: 1.2, fontWeight: FontWeight.w700, color: colors.navy))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: context.ui(9)),
            decoration: BoxDecoration(color: colors.disabledSurface.withValues(alpha: 0.55), borderRadius: BorderRadius.circular(context.ui(12))),
            child: DropdownButton<int>(value: _days, underline: const SizedBox.shrink(), isDense: true, iconSize: context.ui(18), style: TextStyle(fontSize: context.ui(12), color: colors.navy, fontWeight: FontWeight.w600), items: [
              DropdownMenuItem(value: 7, child: Text(l10n.usageLastSevenDays)),
              DropdownMenuItem(value: 30, child: Text(l10n.usageLastThirtyDays)),
            ], onChanged: (value) { if (value != null) { setState(() => _days = value); unawaited(_load()); } }),
          ),
        ]),
        SizedBox(height: context.ui(12)),
        if (!_service.supported)
          _message(l10n.usageUnsupported, colors.body)
        else if (_loading)
          const Center(child: Padding(padding: EdgeInsets.all(18), child: CircularProgressIndicator()))
        else if (!_hasAccess)
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _message(l10n.usagePermissionExplanation, colors.body),
            SizedBox(height: context.ui(10)),
            Align(alignment: Alignment.centerLeft, child: FilledButton(onPressed: () async { await _service.openSettings(); }, child: Text(l10n.usageGrantAccess))),
          ])
        else if (_apps.isEmpty)
          _message(l10n.usageNoData, colors.body)
        else ...[
          Container(
            padding: EdgeInsets.all(context.ui(14)),
            decoration: BoxDecoration(color: colors.disabledSurface.withValues(alpha: 0.45), borderRadius: BorderRadius.circular(context.ui(16))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(children: [
                _appIcon(primary!, 46, colors),
                SizedBox(width: context.ui(10)),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(primary!.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700, color: colors.navy)), Text(l10n.usageMostUsed, style: TextStyle(fontSize: context.ui(12), color: colors.body))]),),
                Text('#1', style: TextStyle(color: colors.primary, fontWeight: FontWeight.w700)),
              ]),
              SizedBox(height: context.ui(10)),
              Text(_duration(l10n, primary!.timeMs), style: TextStyle(fontSize: context.ui(23), fontWeight: FontWeight.w800, color: colors.navy)),
              SizedBox(height: context.ui(8)),
              ClipRRect(borderRadius: BorderRadius.circular(8), child: const LinearProgressIndicator(value: 1, minHeight: 7)),
              SizedBox(height: context.ui(6)),
              Text(l10n.usageTotalTime, style: TextStyle(fontSize: context.ui(12), color: colors.body)),
            ]),
          ),
          if (_apps.length > 1) ...[
            SizedBox(height: context.ui(14)),
            Text(l10n.usageAppRanking, style: TextStyle(fontSize: context.ui(15), fontWeight: FontWeight.w700, color: colors.navy)),
            SizedBox(height: context.ui(6)),
            for (var i = 1; i < _apps.length; i++) ...[
              Padding(padding: EdgeInsets.only(top: context.ui(10)), child: Row(children: [
                SizedBox(width: context.ui(22), child: Text('${i + 1}.', style: TextStyle(color: colors.body, fontSize: context.ui(12)))),
                _appIcon(_apps[i], 30, colors),
                SizedBox(width: context.ui(9)),
                Expanded(child: Text(_apps[i].name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w600, color: colors.navy))),
                SizedBox(width: context.ui(8)),
                Text(_duration(l10n, _apps[i].timeMs), style: TextStyle(fontSize: context.ui(12), color: colors.body)),
              ])),
              SizedBox(height: context.ui(6)),
              ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: (_apps[i].timeMs / maxTime).clamp(0.0, 1.0), minHeight: 6, color: [colors.primary, const Color(0xFFB08AF7), const Color(0xFFE66BA5), const Color(0xFFF5A623)][i % 4], backgroundColor: colors.disabledSurface)),
            ],
          ],
          SizedBox(height: context.ui(10)),
          Text(l10n.usageDeviceDataNote, style: TextStyle(fontSize: context.ui(11), color: colors.body)),
        ],
      ]),
    );
  }

  Widget _message(String text, Color color) => Padding(padding: EdgeInsets.symmetric(vertical: context.ui(8)), child: Text(text, style: TextStyle(color: color)));

  Widget _appIcon(UsedApp app, double size, AppPalette colors) {
    final scaled = context.ui(size);
    return Container(
      width: scaled,
      height: scaled,
      decoration: BoxDecoration(color: colors.disabledSurface.withValues(alpha: 0.65), borderRadius: BorderRadius.circular(context.ui(10))),
      clipBehavior: Clip.antiAlias,
      child: app.iconBytes == null
          ? Icon(Icons.apps_rounded, size: scaled * 0.58, color: colors.primary)
          : Image.memory(app.iconBytes!, fit: BoxFit.cover, errorBuilder: (_, _, _) => Icon(Icons.apps_rounded, size: scaled * 0.58, color: colors.primary)),
    );
  }
}
