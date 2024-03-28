// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minit/hive/box.dart';
import 'package:minit/models/taskModel.dart';
import 'package:minit/services/scheduled_notifier_interface.dart';

final DateTime now = DateTime.now();

// final sampleTasks = [
//   TaskModel(
//     title: 'Do Math Assignments',
//     description: 'Complete Math Assignment, ratio and proportion',
//     startTime: DateTime(now.year, now.month, now.day, 14, 45, 0, 0, 0),
//     durationOptionsIndex: 4,
//     isRunning: false,
//   ),
//   TaskModel(
//     title: 'Get Chores Done',
//     description: 'Do the dishes, clean room',
//     startTime: DateTime(now.year, now.month, now.day, 08, 20, 0, 0, 0),
//     durationOptionsIndex: 3,
//     isRunning: false,
//   ),
//   TaskModel(
//     title: 'Get Groceries',
//     description: 'Go to the store, get letuce, onions, eggs, chicken',
//     startTime: DateTime(now.year, now.month, now.day, 16, 15, 0, 0, 0),
//     durationOptionsIndex: 2,
//     isRunning: false,
//   ),
//   TaskModel(
//     title: 'Buy chocolates',
//     description: 'Get new chocolates for date',
//     startTime: DateTime(now.year, now.month, now.day + 1, 08, 20, 0, 0, 0),
//     durationOptionsIndex: 1,
//     isRunning: false,
//   ),
//   TaskModel(
//     title: 'Get Cleaning supplies',
//     description: 'Buy dish cleaner, 3 bars of soap, and scrubber',
//     startTime: DateTime(now.year, now.month, now.day + 1, 16, 15, 0, 0, 0),
//     durationOptionsIndex: 2,
//     isRunning: false,
//   ),
//   TaskModel(
//     title: 'Watch LIDR Lectures',
//     description: 'Finish watching the last lecture on the geometric logic',
//     startTime: DateTime(now.year, now.month, now.day + 1, 14, 45, 0, 0, 0),
//     durationOptionsIndex: 3,
//     isRunning: false,
//   ),
// ];

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<TaskModel>>(
  (ref) => TaskListNotifier(),
);

// notifier class

class TaskListNotifier extends StateNotifier<List<TaskModel>> {
  TaskListNotifier() : super([]) {
    _populate();
  }

  void _populate() {
    // fetch from db
    if (BoxInterface.taskBox != null) {
      state = BoxInterface.taskBox!.values.toList();
      log(BoxInterface.taskBox!.values.toString(),
          name: 'BoxInterface.taskBox Values - OnInit:');
      log(BoxInterface.taskBox!.keys.toString(),
          name: 'BoxInterface.taskBox Keys - OnInit:');
    }
  }

  Future<void> addTask(TaskModel task) async {
    state = [...state, task];

    // add to hive db
    if (BoxInterface.taskBox != null) {
      log(task.id, name: 'BoxInterface.taskBox Key - OnInsert:');
      log(task.toString(), name: 'BoxInterface.taskBox Value - OnInsert:');

      await BoxInterface.taskBox!.put(task.id, task);

      log(BoxInterface.taskBox!.containsKey(task.id).toString(),
          name: 'BoxInterface.taskBox constains-Key - AfterInsert:');
    } else {
      log('taskListProvider.dart -- Could not initialize "BoxInterface.taskBox". It is NULL!');
    }

    //schedule notification
    ScheduledNotifierInterface.scheduleTask(task);
  }

  Future<void> removeTask(String id) async {
    //TODO: Doesn't cancel notification
    List<TaskModel> newList = [];
    for (TaskModel x in state) {
      if (x.id != id) {
        newList.add(x);
      }
    }
    state = newList;

    // remove from hive db
    if (BoxInterface.taskBox != null) {
      log(id, name: 'BoxInterface.taskBox key - Deleting:');
      log(BoxInterface.taskBox!.get(id).toString(),
          name: 'BoxInterface.taskBox Value - Deleting:');
      await BoxInterface.taskBox!.delete(id);
    } else {
      log('taskListProvider.dart -- Could not initialize "BoxInterface.taskBox". It is NULL!');
    }
  }

  Future<void> startTask(TaskModel task) async {
    // save state in hive
    var storedTask = BoxInterface.taskBox!.get(task.id);

    if (storedTask == null) {
      log(task.id,
          name: 'taskListProvider: task to start was not found in the box');
      return;
    }

    storedTask.startTask();
    await storedTask.save();

    log(BoxInterface.taskBox!.get(task.id).toString(),
        name: 'BoxInterface.taskBox Value - Running:');

    // change value in state - remove old value in state, update with new value from box
    List<TaskModel> newList = [];
    for (TaskModel x in state) {
      if (x.id != task.id) {
        newList.add(x);
      }
    }
    state = newList;
    // add the task back
    state = [...state, storedTask];
  }

  Future<void> pauseTask(TaskModel task, int remainingSeconds) async {
    // for each running task in box. Set remaining seconds
    if (task.isRunning) {
      task.remainingSeconds = remainingSeconds;
      task.save();
    }
  }
}
