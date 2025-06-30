// lib/helpers/notify_helper.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:skd1/models/task.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotifyHelper {
  NotifyHelper._();

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'scheduled_channel';
  static const String _channelName = 'Scheduled Notifications';
  static const String _channelDescription = 'Notification channel for task reminders';

  static bool _isInitialized = false;

  // 1. Flutter Local Notifications'ı Başlat
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      final bool? initialized = await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          print('Notification tapped: ${response.payload}');
        },
      );

      if (initialized == true) {
        _isInitialized = true;
        print('NotifyHelper initialized successfully');
        
        // Android bildirim kanalını oluştur
        await _createNotificationChannel();
        
        // İzinleri iste
        await _requestPermissions();
        
        // Timezone'u yapılandır
        await configureTimezone();
      } else {
        print('Failed to initialize NotifyHelper');
      }
    } catch (e) {
      print('Error initializing NotifyHelper: $e');
    }
  }

  // Android için bildirim kanalı oluştur
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      enableVibration: true,
      enableLights: true,
      ledColor: Color(0xFFFFFFFF),
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    
    print('Notification channel created: $_channelId');
  }

  // 2. Cihazın Yerel Zaman Dilimini Ayarla
  static Future<void> configureTimezone() async {
    try {
      tz.initializeTimeZones();
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      print("Timezone configured successfully: $timeZoneName");
    } catch (e) {
      print('Error configuring timezone: $e');
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  // 3. Bildirim İzinlerini İste
  static Future<void> _requestPermissions() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        // Önce exact alarm iznini kontrol et
        final bool? canScheduleExactAlarms = await androidImplementation.canScheduleExactNotifications();
        print('Can schedule exact alarms: $canScheduleExactAlarms');
        
        if (canScheduleExactAlarms == false) {
          // Kullanıcıyı ayarlara yönlendir
          await androidImplementation.requestExactAlarmsPermission();
        }
        
        // Normal bildirim iznini iste
        final bool? granted = await androidImplementation.requestNotificationsPermission();
        print('Notification permission granted: $granted');
      }
    } catch (e) {
      print('Error requesting permissions: $e');
    }
  }

  // 4. Görev için Zamanlanmış Bildirim Oluştur
  static Future<void> scheduleTaskNotification(Task task) async {
    try {
      // Initialize kontrolü
      if (!_isInitialized) {
        print('NotifyHelper not initialized, initializing now...');
        await initialize();
      }

      if (task.startTime == null || task.startTime!.isEmpty) {
        print('Task start time is null or empty, cannot schedule.');
        return;
      }

      final Map<String, int>? time = _parseTimeString(task.startTime!);
      if (time == null) {
        print('Could not parse time: ${task.startTime}');
        return;
      }

      final tz.TZDateTime scheduledDate = _getScheduledDate(time['hour']!, time['minute']!);

      // Geçmiş tarih kontrolü
      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
        print('Scheduled time is in the past, skipping notification');
        return;
      }

      print('Scheduling notification for task: "${task.title}" at $scheduledDate');

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        color: Color(0xFF9D50DD),
        enableVibration: true,
        enableLights: true,
        ledColor: Color(0xFFFFFFFF),
        ledOnMs: 1000,
        ledOffMs: 500,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      final int notificationId = task.id ?? DateTime.now().millisecondsSinceEpoch % 100000;

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        'Görev Hatırlatması: ${task.title}',
        task.note ?? 'Bu görevi tamamlama zamanı geldi!',
        scheduledDate,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: task.id?.toString(),
      );

      print('Notification scheduled successfully for task id: ${task.id}');
    } catch (e) {
      print('Error scheduling notification: $e');
      rethrow;
    }
  }
  
  // Helper metot: Zaman string'ini ayrıştırır
  static Map<String, int>? _parseTimeString(String timeString) {
    try {
      String cleanTime = timeString.trim().toUpperCase();

      // 12 saatlik format (örn: 03:27 PM)
      RegExp timeRegex12 = RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)$');
      Match? match12 = timeRegex12.firstMatch(cleanTime);
      if (match12 != null) {
        int hour = int.parse(match12.group(1)!);
        int minute = int.parse(match12.group(2)!);
        String period = match12.group(3)!;
        if (period == 'PM' && hour != 12) hour += 12;
        if (period == 'AM' && hour == 12) hour = 0;
        return {'hour': hour, 'minute': minute};
      }

      // 24 saatlik format (örn: 15:22)
      RegExp timeRegex24 = RegExp(r'^(\d{1,2}):(\d{2})$');
      Match? match24 = timeRegex24.firstMatch(cleanTime);
      if (match24 != null) {
        int hour = int.parse(match24.group(1)!);
        int minute = int.parse(match24.group(2)!);
        if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
          return {'hour': hour, 'minute': minute};
        }
      }
    } catch (e) {
      print('Error parsing time string "$timeString": $e');
    }
    return null;
  }

  // Helper metot: Zamanlanmış tarihi hesaplar
  static tz.TZDateTime _getScheduledDate(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  // 5. Belirli bir bildirimi iptal et
  static Future<void> cancelNotificationById(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
      print('Cancelled notification with id: $id');
    } catch (e) {
      print('Error cancelling notification: $e');
    }
  }

  // 6. Tüm bildirimleri iptal et
  static Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      print('All scheduled notifications have been cancelled.');
    } catch (e) {
      print('Error cancelling all notifications: $e');
    }
  }

  // 7. Test bildirimi gönder
  static Future<void> sendTestNotification() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );

      const DarwinNotificationDetails iOSPlatformChannelSpecifics =
          DarwinNotificationDetails();

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _flutterLocalNotificationsPlugin.show(
        -1,
        "Test Bildirimi",
        "Eğer bunu görüyorsan, bildirimler çalışıyor!",
        platformChannelSpecifics,
      );
      print("Test notification sent.");
    } catch (e) {
      print('Error sending test notification: $e');
    }
  }

  // Bildirim durumunu kontrol et
  static Future<bool> checkNotificationPermissions() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final bool? granted = await androidImplementation.areNotificationsEnabled();
        return granted ?? false;
      }
      return false;
    } catch (e) {
      print('Error checking notification permissions: $e');
      return false;
    }
  }
}