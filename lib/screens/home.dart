import 'package:flutter/material.dart';
import 'package:minit/utils/shaders.dart';
import 'package:minit/widgets/new_task_widgets/AddNewTaskWidget.dart';
import 'package:minit/widgets/HomeDayScroller.dart';
import 'package:minit/widgets/TasksScroller.dart';

// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:minit/services/notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'My Tasks',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.w300,
                color: Colors.black87,
              ),
        ),
        actions: [
          iconButton(context),
        ],
      ),
      body: Column(
        children: [
          const HomeDayScroller(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Divider(
              color: Colors.grey.shade300,
            ),
          ),
          const TasksScroller(),
        ],
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   await NotificationService.showNotification(
      //     title: "Minit - Test Notification",
      //     body: 'This is the body of the notification',
      //     payload: {
      //       'Navigate': 'true',
      //     },
      //     actionButtons: [
      //       NotificationActionButton(key: 'start', label: 'Let\'s Go!'),
      //     ],
      //   );
      // }),
    );
  }
}

// icon button
Widget iconButton(BuildContext ctx) {
  return Container(
    decoration: ShapeDecoration(
      shape: const CircleBorder(),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colorGradientList,
      ),
    ),
    child: MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: const CircleBorder(),
      onPressed: () => showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: ctx,
        builder: (context) {
          return const AddNewTaskWidget();
        },
      ),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    ),
  );
}
