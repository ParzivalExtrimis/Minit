import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:minit/models/taskModel.dart';
import 'package:minit/services/notification_service.dart';

class ScheduledNotifierInterface {
  static Future<void> scheduleTask(TaskModel task) async {
    await NotificationService.showNotification(
        title: 'Task Pending!',
        body: task.title,
        summary: task.description,
        notificationLayout: NotificationLayout.Inbox,
        notificationCategory: NotificationCategory.Reminder,
        scheduled: true,
        interval: task.secondsToStart > 5 ? task.secondsToStart : 5,
        payload: {
          'navigate': 'true'
        },
        actionButtons: [
          NotificationActionButton(key: 'task_alert', label: 'Let\'s Go!')
        ]);
  }
}
