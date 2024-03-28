// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minit/models/dateTimeModel.dart';
import 'package:minit/models/taskModel.dart';
import 'package:minit/providers/selectedDayProvider.dart';
import 'package:minit/providers/taskListProvider.dart';
import 'package:minit/widgets/TaskScrollerCard.dart';

class TasksScroller extends ConsumerStatefulWidget {
  const TasksScroller({super.key});
  @override
  ConsumerState<TasksScroller> createState() => _TasksScrollerState();
}

class _TasksScrollerState extends ConsumerState<TasksScroller> {
  List<TaskModel> taskList = [];
  List<TaskModel> daysTaskList = [];
  DateTimeModel selectedDay = DateTimeModel.now();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    taskList = ref.watch(taskListProvider);
    selectedDay = ref.watch(selectedDayProvider);

    daysTaskList.clear();

    daysTaskList = List.of(taskList.where(
      (task) =>
          (task.startTime.year == selectedDay.date.year) &&
          (task.startTime.month == selectedDay.date.month) &&
          (task.startTime.day == selectedDay.date.day),
    ));

    return SizedBox(
      height: size.height * 0.6,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: daysTaskList.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(18),
                child: Text(
                  'Nothing planned yet!',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black45,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              )
            : Column(
                children: daysTaskList
                    .map(
                      (e) => TaskSCrollerCard(task: e),
                    )
                    .toList()),
      ),
    );
  }
}
