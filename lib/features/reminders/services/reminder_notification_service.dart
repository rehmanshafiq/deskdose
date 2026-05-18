import 'package:deskdose/data/models/reminder_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Schedules and cancels local reminders per [ReminderType].
class ReminderNotificationService {
  ReminderNotificationService._();

  static final ReminderNotificationService instance =
      ReminderNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      ),
    );

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    _initialized = true;
  }

  Future<void> syncReminder(ReminderSettings setting) async {
    if (!_initialized) await initialize();

    final id = _notificationId(setting.type);
    if (!setting.isEnabled) {
      await _plugin.cancel(id: id);
      return;
    }

    final content = _contentFor(setting.type);
    final androidDetails = AndroidNotificationDetails(
      'deskdose_${setting.type.name}',
      _channelName(setting.type),
      channelDescription: 'DeskDose ${setting.type.name} reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _plugin.periodicallyShowWithDuration(
      id: id,
      repeatDurationInterval: Duration(minutes: setting.intervalMinutes),
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        macOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      title: content.title,
      body: content.body,
    );
  }

  Future<void> cancelType(ReminderType type) async {
    await _plugin.cancel(id: _notificationId(type));
  }

  int _notificationId(ReminderType type) => switch (type) {
        ReminderType.workout => 1001,
        ReminderType.water => 1002,
        ReminderType.eye => 1003,
      };

  String _channelName(ReminderType type) => switch (type) {
        ReminderType.workout => 'Workout Reminders',
        ReminderType.water => 'Water Reminders',
        ReminderType.eye => 'Eye Break Reminders',
      };

  ({String title, String body}) _contentFor(ReminderType type) =>
      switch (type) {
        ReminderType.workout => (
            title: '💪 Time to move!',
            body: 'Quick desk workout break',
          ),
        ReminderType.water => (
            title: '💧 Stay hydrated!',
            body: 'Take a sip of water',
          ),
        ReminderType.eye => (
            title: '👁️ 20-20-20 break!',
            body: 'Look away from your screen',
          ),
      };
}
