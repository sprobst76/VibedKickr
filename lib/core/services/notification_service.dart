import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:logger/logger.dart';

final _logger = Logger(
  printer: PrettyPrinter(methodCount: 0, printEmojis: false),
);

/// Service für lokale Benachrichtigungen (Morgen-Training Erinnerungen)
class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static const _morningWorkoutChannelId = 'morning_workout';
  static const _morningWorkoutNotificationId = 1001;

  // SharedPreferences Keys
  static const _keyEnabled = 'morning_workout_notification_enabled';
  static const _keyHour = 'morning_workout_notification_hour';
  static const _keyMinute = 'morning_workout_notification_minute';
  static const _keyDays = 'morning_workout_notification_days';

  /// Initialisiere das Notification-System
  static Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open',
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      linux: linuxSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
    _logger.i('NotificationService initialized');

    // Restore scheduled notifications
    await _restoreScheduledNotifications();
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    _logger.i('Notification tapped: ${response.payload}');
    // Navigation wird vom App-Router gehandhabt
  }

  /// Berechtigung anfordern (Android 13+)
  static Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    return true; // Auf anderen Plattformen keine Berechtigung nötig
  }

  /// Morgen-Training Erinnerung planen
  static Future<void> scheduleMorningReminder({
    required TimeOfDay time,
    required List<int> daysOfWeek, // 1=Mo..7=So
  }) async {
    if (!_initialized) await initialize();

    // Erst alle existierenden löschen
    await cancelMorningReminder();

    const androidDetails = AndroidNotificationDetails(
      _morningWorkoutChannelId,
      'Morgen-Training Erinnerung',
      channelDescription: 'Erinnerung an dein tägliches Morgen-Training',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
    );

    const linuxDetails = LinuxNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      linux: linuxDetails,
    );

    // Für jeden ausgewählten Tag eine wiederkehrende Benachrichtigung planen
    for (final day in daysOfWeek) {
      final scheduledDate = _nextInstanceOfDayAndTime(day, time);

      await _plugin.zonedSchedule(
        _morningWorkoutNotificationId + day,
        'Guten Morgen Training',
        'Zeit für dein 10-Minuten Morgen-Training!',
        scheduledDate,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        payload: 'morning_workout',
      );
    }

    // Einstellungen speichern
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnabled, true);
    await prefs.setInt(_keyHour, time.hour);
    await prefs.setInt(_keyMinute, time.minute);
    await prefs.setStringList(
      _keyDays,
      daysOfWeek.map((d) => d.toString()).toList(),
    );

    _logger.i(
      'Morning reminder scheduled: ${time.hour}:${time.minute.toString().padLeft(2, '0')} '
      'on days $daysOfWeek',
    );
  }

  /// Morgen-Training Erinnerung abbrechen
  static Future<void> cancelMorningReminder() async {
    for (int day = 1; day <= 7; day++) {
      await _plugin.cancel(_morningWorkoutNotificationId + day);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnabled, false);

    _logger.i('Morning reminder cancelled');
  }

  /// Einstellungen laden
  static Future<MorningNotificationSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_keyEnabled) ?? false;
    final hour = prefs.getInt(_keyHour) ?? 6;
    final minute = prefs.getInt(_keyMinute) ?? 30;
    final daysStrings = prefs.getStringList(_keyDays) ?? ['1', '2', '3', '4', '5'];
    final days = daysStrings.map((s) => int.parse(s)).toList();

    return MorningNotificationSettings(
      enabled: enabled,
      time: TimeOfDay(hour: hour, minute: minute),
      daysOfWeek: days,
    );
  }

  /// Gespeicherte Benachrichtigungen wiederherstellen (nach App-Neustart)
  static Future<void> _restoreScheduledNotifications() async {
    final settings = await getSettings();
    if (settings.enabled) {
      await scheduleMorningReminder(
        time: settings.time,
        daysOfWeek: settings.daysOfWeek,
      );
    }
  }

  /// Berechnet den nächsten Zeitpunkt für einen bestimmten Wochentag + Uhrzeit
  static tz.TZDateTime _nextInstanceOfDayAndTime(int day, TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // Zum richtigen Wochentag vorspulen
    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Falls der Zeitpunkt in der Vergangenheit liegt, nächste Woche nehmen
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }
}

/// Einstellungen für die Morgen-Training Benachrichtigung
class MorningNotificationSettings {
  final bool enabled;
  final TimeOfDay time;
  final List<int> daysOfWeek; // 1=Mo..7=So

  const MorningNotificationSettings({
    required this.enabled,
    required this.time,
    required this.daysOfWeek,
  });
}
