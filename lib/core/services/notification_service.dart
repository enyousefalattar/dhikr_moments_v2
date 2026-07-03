import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'storage_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(initSettings);

    // Request permissions for Android 13+
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    
    await scheduleInactivityReminder();
  }

  static Future<bool> _shouldSkipNotification() async {
    final lastOpen = await StorageService.getLastOpenTime();
    if (lastOpen == null) return false;
    final diff = DateTime.now().difference(lastOpen);
    return diff.inHours < 1;
  }

  static Future<void> scheduleMorningReminder() async {
    if (await _shouldSkipNotification()) return;

    await _notificationsPlugin.zonedSchedule(
      1,
      '🌅 حان وقت أذكار الصباح',
      'استيقظ على ذكر الله وابدأ يومك بالبركة',
      _nextInstanceOfTime(6, 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminders',
          'التذكير اليومي',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> scheduleEveningReminder() async {
    if (await _shouldSkipNotification()) return;

    await _notificationsPlugin.zonedSchedule(
      2,
      '🌙 حان وقت أذكار المساء',
      'اختتم يومك بذكر الله وحصن نفسك',
      _nextInstanceOfTime(18, 0),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminders',
          'التذكير اليومي',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> scheduleInactivityReminder() async {
    // Schedule a reminder after 3 days of inactivity
    await _notificationsPlugin.zonedSchedule(
      3,
      'نشتاق إليك 🌹',
      'عد لذكر الله، قلوبنا تطمئن بذكر الله',
      tz.TZDateTime.now(tz.local).add(const Duration(days: 3)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'inactivity_reminders',
          'تذكير الغياب',
          importance: Importance.low,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelAllReminders() async {
    await _notificationsPlugin.cancelAll();
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
