import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_template/src/core/utils/app_logger.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._internal();

  static final NotificationService instance = NotificationService._internal();

  factory NotificationService() => instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _dailyChannel =
      AndroidNotificationChannel(
        'daily_notification_channel',
        'Daily Notifications',
        description: 'Daily repeated notifications',
        importance: Importance.high,
      );

  static const AndroidNotificationChannel _weeklyChannel =
      AndroidNotificationChannel(
        'weekly_notification_channel',
        'Weekly Notifications',
        description: 'Weekly repeated notifications',
        importance: Importance.high,
      );

  /// INIT
  Future<void> init() async {
    AppLogger.info(
      "Initializing notification service",
      tag: "NotificationService",
    );

    //! Initialize timezone database
    tz_data.initializeTimeZones();

    AppLogger.success(
      "Timezone database initialized",
      tag: "NotificationService",
    );

    //! Get local timezone
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();

    final String currentTimeZone = timezoneInfo.localizedName!.name;

    AppLogger.info(
      "Current timezone detected",
      tag: "NotificationService",
      json: {"timezone": currentTimeZone},
    );

    //! Set local timezone
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    AppLogger.success("Local timezone configured", tag: "NotificationService");

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const darwinSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _plugin.initialize(settings: initializationSettings);

    AppLogger.success(
      "Flutter local notifications initialized",
      tag: "NotificationService",
    );

    //! Permission
    final permissionGranted = await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    AppLogger.info(
      "Notification permission result",
      tag: "NotificationService",
      json: {"granted": permissionGranted},
    );

    //! Create channels
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_dailyChannel);

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_weeklyChannel);

    AppLogger.success(
      "Notification channels created",
      tag: "NotificationService",
    );
  }

  /// COMMON NOTIFICATION DETAILS
  NotificationDetails _notificationDetails({
    required AndroidNotificationChannel channel,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.high,
        priority: Priority.high,
        largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      ),
    );
  }

  /// SIMPLE NOTIFICATION
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: _notificationDetails(channel: _dailyChannel),
    );
  }

  /// DAILY REPEATED NOTIFICATION
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    String? payload,
  }) async {
    final scheduledDate = _nextDailyInstance(time);

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: _notificationDetails(channel: _dailyChannel),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    AppLogger.info(
      "Scheduling daily notification",
      tag: "NotificationService",
      json: {
        "id": id,
        "title": title,
        "hour": time.hour,
        "minute": time.minute,
        "scheduled_at": scheduledDate.toString(),
      },
    );
  }

  /// WEEKLY REPEATED NOTIFICATION
  ///
  /// weekday:
  /// DateTime.monday
  /// DateTime.tuesday
  /// etc...
  Future<void> scheduleWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required int weekday,
    required TimeOfDay time,
    String? payload,
  }) async {
    final scheduledDate = _nextWeeklyInstance(weekday, time);

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: _notificationDetails(channel: _weeklyChannel),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );

    AppLogger.info(
      "Scheduling weekly notification",
      tag: "NotificationService",
      json: {
        "id": id,
        "title": title,
        "weekday": weekday,
        "hour": time.hour,
        "minute": time.minute,
        "scheduled_at": scheduledDate.toString(),
      },
    );
  }

  /// CANCEL SINGLE NOTIFICATION
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id: id);
    AppLogger.warning(
      "Cancelling notification",
      tag: "NotificationService",
      json: {"id": id},
    );
  }

  /// CANCEL ALL NOTIFICATIONS
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
    AppLogger.warning(
      "Cancelling all notifications",
      tag: "NotificationService",
    );
  }

  /// PENDING NOTIFICATIONS
  Future<List<PendingNotificationRequest>> pendingNotifications() async {
    return await _plugin.pendingNotificationRequests();
  }

  /// NEXT DAILY TIME
  tz.TZDateTime _nextDailyInstance(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  /// NEXT WEEKLY TIME
  tz.TZDateTime _nextWeeklyInstance(int weekday, TimeOfDay time) {
    tz.TZDateTime scheduledDate = _nextDailyInstance(time);

    while (scheduledDate.weekday != weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}
