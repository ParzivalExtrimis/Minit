import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:minit/main.dart';
import 'package:minit/screens/home.dart';

class NotificationService {
  static final AwesomeNotifications _notifier = AwesomeNotifications();

  static Future<void> init() async {
    await _notifier.initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'high_importance_channel',
          channelName: 'Task Alert Notification Channel',
          channelDescription:
              'Channel for notifications regarding due tasks that are scheduled.',
          channelShowBadge: true,
          defaultColor: const Color.fromARGB(255, 248, 163, 157),
          importance: NotificationImportance.High,
          ledColor: Colors.white,
          playSound: true,
          enableVibration: true,
          criticalAlerts: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Default Channel Group',
        )
      ],
      debug: true,
    );

    await _notifier.isNotificationAllowed().then((isAllowed) async {
      if (!isAllowed) {
        await _notifier.requestPermissionToSendNotifications();
      }
    });

    await _notifier.setListeners(
      onNotificationCreatedMethod: _onNotificationCreatedMethod,
      onNotificationDisplayedMethod: _onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: _onDismissActionReceivedMethod,
      onActionReceivedMethod: _onActionReceivedMethod,
    );
  }

  static Future<void> _onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod invoked.');
  }

  static Future<void> _onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod invoked.');
  }

  static Future<void> _onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod invoked.');
  }

  static Future<void> _onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod invoked.');
    final payload = receivedAction.payload ?? {};
    if (payload['navigate'] == "true") {
      App.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    }
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actiontype = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? notificationCategory,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
  }) async {
    assert(!scheduled || (scheduled && interval != null));
    await _notifier.createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        summary: summary,
        payload: payload,
        category: notificationCategory,
        autoDismissible: false,
        bigPicture: bigPicture,
        actionType: actiontype,
        notificationLayout: notificationLayout,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
              interval: interval,
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
            )
          : null,
    );
  }
}
