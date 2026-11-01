import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int reminderNotificationId = 1001;
  static const int motivationNotificationId = 1002;

  static const String reminderChannelId = 'antiburnout_daily_reminder';
  static const String reminderChannelName = 'Pengingat Harian';
  static const String reminderChannelDesc =
      'Pengingat harian untuk evaluasi dan check-in tingkat burnout';

  static const String motivationChannelId = 'antiburnout_daily_motivation';
  static const String motivationChannelName = 'Motivasi Sederhana';
  static const String motivationChannelDesc =
      'Kutipan penyemangat harian dan tips kesehatan mental';

  static const List<String> motivationalQuotes = [
    'Istirahat sejenak bukanlah tanda menyerah, melainkan persiapan melangkah lebih jauh. 🌸',
    'Tarik napas dalam-dalam. Kamu sudah berjuang sebaik mungkin hari ini. Tetap semangat! ✨',
    'Batasan diri yang sehat adalah bentuk cinta pada kesehatan mental dan fisikmu. 🌿',
    'Fokuslah pada satu hal yang bisa diselesaikan hari ini, tidak perlu membebani diri sekaligus. 💡',
    'Kesehatan mentalmu sama berharganya dengan produktivitasmu. Jangan lupa minum air dan rileks! 💧',
    'Kamu tidak harus selalu sempurna. Cukup jadi versi terbaik yang bisa kamu lakukan hari ini. 🌟',
    'Ketenangan pikiran adalah fondasi dari segala pencapaian besar. Luangkan waktu untuk bernapas. 🧘',
  ];

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      );

      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (response) {
          debugPrint('Notifikasi diklik: ${response.payload}');
        },
      );

      _isInitialized = true;
      debugPrint('NotificationService berhasil diinisialisasi.');
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
  }

  Future<bool> requestPermissions() async {
    try {
      // Android 13+ (API 33+)
      final androidImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        final granted =
            await androidImplementation.requestNotificationsPermission();
        return granted ?? true;
      }

      // iOS
      final iosImplementation = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      if (iosImplementation != null) {
        final granted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? true;
      }
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
    }
    return true;
  }

  // ==========================================
  // MODE 1: REMINDER HARIAN
  // ==========================================

  NotificationDetails _buildReminderNotificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      reminderChannelId,
      reminderChannelName,
      channelDescription: reminderChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    return const NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }

  /// Jadwalkan pengingat harian (misal tiap jam 09:00 pagi)
  Future<void> scheduleDailyReminder({int hour = 9, int minute = 0}) async {
    await init();
    await requestPermissions();

    final scheduledDate = _nextInstanceOfTime(hour, minute);

    try {
      await _notificationsPlugin.zonedSchedule(
        reminderNotificationId,
        'Saatnya Cek Kondisi Diri 🌱',
        'Bagaimana energimu hari ini? Luangkan 2 menit untuk check-in tingkat stres & burnout.',
        scheduledDate,
        _buildReminderNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'route_daily_reminder',
      );
      debugPrint('Pengingat harian dijadwalkan pada jam $hour:$minute setiap hari.');
    } catch (e) {
      debugPrint('Gagal menjadwalkan pengingat harian: $e');
    }
  }

  /// Batalkan pengingat harian
  Future<void> cancelDailyReminder() async {
    try {
      await _notificationsPlugin.cancel(reminderNotificationId);
      debugPrint('Pengingat harian dibatalkan.');
    } catch (e) {
      debugPrint('Error cancel daily reminder: $e');
    }
  }

  /// Tes kirim Pengingat Harian secara langsung saat ini juga
  Future<void> showImmediateReminder() async {
    await init();
    await requestPermissions();

    try {
      await _notificationsPlugin.show(
        reminderNotificationId,
        'Saatnya Cek Kondisi Diri 🌱 (Pengingat Harian)',
        'Bagaimana energimu hari ini? Luangkan 2 menit untuk check-in tingkat stres & burnout di AntiBurnout.',
        _buildReminderNotificationDetails(),
        payload: 'route_daily_reminder',
      );
      debugPrint('Pengingat harian berhasil dikirim secara langsung.');
    } catch (e) {
      debugPrint('Gagal mengirim notifikasi langsung pengingat harian: $e');
    }
  }

  // ==========================================
  // MODE 2: MOTIVASI SEDERHANA
  // ==========================================

  NotificationDetails _buildMotivationNotificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      motivationChannelId,
      motivationChannelName,
      channelDescription: motivationChannelDesc,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    return const NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }

  /// Jadwalkan motivasi sederhana harian (misal tiap jam 14:00 siang)
  Future<void> scheduleDailyMotivation({int hour = 14, int minute = 0}) async {
    await init();
    await requestPermissions();

    final scheduledDate = _nextInstanceOfTime(hour, minute);
    final randomQuote = motivationalQuotes[Random().nextInt(motivationalQuotes.length)];

    try {
      await _notificationsPlugin.zonedSchedule(
        motivationNotificationId,
        'Inspirasi Hari Ini 💡',
        randomQuote,
        scheduledDate,
        _buildMotivationNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'route_motivation',
      );
      debugPrint('Motivasi harian dijadwalkan pada jam $hour:$minute setiap hari.');
    } catch (e) {
      debugPrint('Gagal menjadwalkan motivasi harian: $e');
    }
  }

  /// Batalkan motivasi harian
  Future<void> cancelDailyMotivation() async {
    try {
      await _notificationsPlugin.cancel(motivationNotificationId);
      debugPrint('Motivasi harian dibatalkan.');
    } catch (e) {
      debugPrint('Error cancel daily motivation: $e');
    }
  }

  /// Tes kirim Motivasi Sederhana secara langsung saat ini juga
  Future<void> showImmediateMotivation() async {
    await init();
    await requestPermissions();

    final randomQuote = motivationalQuotes[Random().nextInt(motivationalQuotes.length)];

    try {
      await _notificationsPlugin.show(
        motivationNotificationId,
        'Inspirasi Singkat 💡 (Motivasi)',
        randomQuote,
        _buildMotivationNotificationDetails(),
        payload: 'route_motivation',
      );
      debugPrint('Motivasi berhasil dikirim secara langsung.');
    } catch (e) {
      debugPrint('Gagal mengirim notifikasi langsung motivasi: $e');
    }
  }

  // ==========================================
  // HELPER METODE
  // ==========================================

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService.instance;
});

