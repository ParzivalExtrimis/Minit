// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:minit/models/durationModel.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'taskModel.g.dart';

const uuid = Uuid();

@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime startTime;

  @HiveField(4)
  int remainingSeconds;

  @HiveField(5)
  bool isRunning;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.remainingSeconds,
    required this.isRunning,
  });

  TaskModel.autoId({
    required this.title,
    required this.description,
    required this.startTime,
    required this.remainingSeconds,
    required this.isRunning,
  }) : id = uuid.v1();

  int get secondsToStart {
    final now = DateTime.now();
    // checking for tasks set to past. Has been prevented on frontend.
    //Keeping it here just in case I change that accidentally

    if (startTime.compareTo(now) < 0) {
      debugPrint("Task scheduled for a time prior to now");
      return 0;
    }
    return startTime.difference(now).inSeconds;
  }

  String? get duration {
    return DurationModel.fromSeconds(remainingSeconds).durationString;
  }

  void startTask() {
    isRunning = true;
  }

  void setRemainingTime(int seconds) {
    remainingSeconds = seconds;
  }

  void stopTask() {
    isRunning = false;
  }

  @override
  String toString() {
    return ''' \n
      id : $id,
      title : $title,
      description : $description,
      startTime : $startTime,
      remainingSeconds: $remainingSeconds,
      isRunning : $isRunning
    ''';
  }
}
