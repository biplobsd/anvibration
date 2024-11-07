import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class NotificationService {
  static Future<void> vibrateHigh() async {
    if (await Vibration.hasVibrator() ?? false) {
      // Intense vibration pattern
      Vibration.vibrate(
        pattern: [0, 1000, 200, 1000, 200, 1000],
        intensities: [0, 255, 0, 255, 0, 255],
      );
    }
  }

  static Future<void> vibrateMedium() async {
    if (await Vibration.hasVibrator() ?? false) {
      // Medium vibration pattern
      Vibration.vibrate(
        pattern: [0, 500, 200, 500],
        intensities: [0, 128, 0, 128], // Medium intensity
      );
    }
  }

  static Future<void> vibrateLow() async {
    if (await Vibration.hasVibrator() ?? false) {
      // Gentle vibration pattern
      Vibration.vibrate(
        pattern: [0, 200, 100, 200],
        intensities: [0, 64, 0, 64], // Low intensity
      );
    }
  }

  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'vibration',
          channelKey: 'high_importance_channel',
          channelName: 'High Importance',
          channelDescription: 'High importance notifications',
          defaultColor: Colors.blue,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          enableVibration: false, // We'll handle vibration separately
        ),
        NotificationChannel(
          channelGroupKey: 'vibration',
          channelKey: 'medium_importance_channel',
          channelName: 'Medium Importance',
          channelDescription: 'Medium importance notifications',
          defaultColor: Colors.blue,
          importance: NotificationImportance.Default,
          channelShowBadge: true,
          playSound: true,
          enableVibration: false,
        ),
        NotificationChannel(
          channelGroupKey: 'vibration',
          channelKey: 'low_importance_channel',
          channelName: 'Low Importance',
          channelDescription: 'Low importance notifications',
          defaultColor: Colors.blue,
          importance: NotificationImportance.Low,
          channelShowBadge: true,
          playSound: true,
          enableVibration: false,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'vibration',
          channelGroupName: 'Vibration',
        ),
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (value) async {
        if (!value) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    // Set up notification listeners
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
    );

    // Handle Firebase messages
    FirebaseMessaging.onMessage.listen(onMessageHandeler);

    FirebaseMessaging.onBackgroundMessage(onMessageHandeler);
  }

  static Future<void> onMessageHandeler(event) async {
    String title = event.notification!.title ?? '';
    int? vibrationLevel = int.tryParse(event.data['vibrationLevel']);
    String body = event.notification!.body ?? '';
    body += 'Vibration Level $vibrationLevel';

    // Show notification and trigger vibration
    await showNotification(
      title: title,
      body: body,
      vibrationLevel: vibrationLevel,
    );
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButton,
    final bool scheduled = false,
    final int? interval,
    final int? vibrationLevel,
  }) async {
    // Determine channel and trigger appropriate vibration
    var channelKey = 'high_importance_channel';

    if (vibrationLevel != null) {
      switch (vibrationLevel) {
        case 0:
          channelKey = 'high_importance_channel';
          vibrateHigh();
          break;
        case 1:
          channelKey = 'medium_importance_channel';
          vibrateMedium();
          break;
        case 2:
          channelKey = 'low_importance_channel';
          vibrateLow();
          break;
        default:
      }
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: channelKey,
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
      ),
      actionButtons: actionButton,
      schedule: scheduled
          ? NotificationInterval(
              interval: Duration(seconds: interval ?? 0),
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
            )
          : null,
    );
  }

  // Existing notification handlers...
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
  }

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }
}
