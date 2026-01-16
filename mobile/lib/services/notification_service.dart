import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// =============================================================================
/// NOTIFICATION SERVICE - Prayer Time Notifications
/// =============================================================================
/// 
/// Menjadwalkan notifikasi:
/// 1. Reminder 10 menit sebelum waktu sholat
/// 2. Adzan tepat waktu sholat
/// 
/// Menggunakan flutter_local_notifications dengan timezone scheduling.
/// =============================================================================

class NotificationService {
  // Singleton
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // Notification IDs
  static const int _reminderIdBase = 1000;  // 1000-1004 for reminders
  static const int _adzanIdBase = 2000;     // 2000-2004 for adzan

  /// Initialize notification service
  Future<void> init() async {
    if (_initialized) return;

    // Initialize timezone
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    // Android settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create notification channel for Android
    await _createNotificationChannel();

    _initialized = true;
    print('🔔 [Notification] Service initialized');
  }

  /// Create Android notification channel
  Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'prayer_times',
      'Waktu Sholat',
      description: 'Pemberitahuan pengingat dan adzan waktu sholat',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Handle notification tap
  void _onNotificationTap(NotificationResponse response) {
    print('🔔 [Notification] Tapped: ${response.payload}');
    // Navigate to prayer times if needed
  }

  /// Request notification permission (Android 13+)
  Future<bool> requestPermission() async {
    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    return true;
  }

  /// Schedule prayer notifications
  /// Called when prayer times are fetched
  Future<void> schedulePrayerNotifications({
    required Map<String, DateTime> prayerTimes,
  }) async {
    if (!_initialized) await init();

    // Cancel existing notifications first
    await cancelAllPrayerNotifications();

    int reminderIndex = 0;
    int adzanIndex = 0;

    for (final entry in prayerTimes.entries) {
      final prayerName = entry.key;
      final prayerTime = entry.value;
      final now = DateTime.now();

      // Skip if prayer time already passed
      if (prayerTime.isBefore(now)) {
        continue;
      }

      // 1. Schedule reminder 10 minutes before
      final reminderTime = prayerTime.subtract(const Duration(minutes: 10));
      if (reminderTime.isAfter(now)) {
        await _scheduleNotification(
          id: _reminderIdBase + reminderIndex,
          title: 'Pengingat Sholat',
          body: '10 menit lagi menuju sholat $prayerName.',
          scheduledTime: reminderTime,
          payload: 'reminder_$prayerName',
        );
        reminderIndex++;
      }

      // 2. Schedule adzan notification
      await _scheduleNotification(
        id: _adzanIdBase + adzanIndex,
        title: 'Waktu Sholat $prayerName',
        body: 'Adzan $prayerName telah masuk.',
        scheduledTime: prayerTime,
        payload: 'adzan_$prayerName',
      );
      adzanIndex++;
    }

    print('🔔 [Notification] Scheduled $reminderIndex reminders, $adzanIndex adzans');
  }

  /// Schedule a single notification
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    try {
      final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'prayer_times',
            'Waktu Sholat',
            channelDescription: 'Pemberitahuan pengingat dan adzan waktu sholat',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            playSound: true,
            enableVibration: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: null,
        payload: payload,
      );

      print('🔔 [Notification] Scheduled: $title at ${scheduledTime.toString()}');
    } catch (e) {
      print('❌ [Notification] Schedule error: $e');
    }
  }

  /// Cancel all prayer notifications
  Future<void> cancelAllPrayerNotifications() async {
    // Cancel reminders (1000-1004)
    for (int i = 0; i < 5; i++) {
      await _notifications.cancel(_reminderIdBase + i);
    }
    
    // Cancel adzans (2000-2004)
    for (int i = 0; i < 5; i++) {
      await _notifications.cancel(_adzanIdBase + i);
    }
    
    print('🔔 [Notification] All prayer notifications cancelled');
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Show immediate notification (for testing)
  Future<void> showTestNotification() async {
    if (!_initialized) await init();

    await _notifications.show(
      0,
      'Uji Pemberitahuan',
      'Pemberitahuan berfungsi dengan baik!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_times',
          'Waktu Sholat',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}
