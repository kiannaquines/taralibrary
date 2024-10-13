import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:typed_data'; // Import this for using Int64List

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (
        NotificationResponse notificationResponse,
      ) async {
        debugPrint(
          'Notification clicked with payload: ${notificationResponse.payload}',
        );
      },
    );
  }

  NotificationDetails notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'taralibrary_channel_id',
        'TaraLibrary Notifications',
        channelDescription: 'Notification channel for TaraLibrary app.',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
        ongoing: false,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        showProgress: true,
        vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      ),
    );
  }

  Future<bool> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted =
        await androidImplementation?.requestNotificationsPermission();
    return granted ?? false;
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    try {
      bool permissionGranted = await requestPermissions();

      if (!permissionGranted) {
        return;
      }

      await notificationsPlugin.show(
        id,
        title ?? 'TaraLibrary Notification',
        body ?? 'Notification Body',
        notificationDetails(),
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }
}
