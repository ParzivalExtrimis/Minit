import 'package:hive_flutter/hive_flutter.dart';
import 'package:minit/models/taskModel.dart';

class BoxInterface {
  static Box<TaskModel>? taskBox;

  static Future<void> initializeHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter());

    if (!Hive.isBoxOpen("BoxInterface.taskBox")) {
      taskBox = await Hive.openBox<TaskModel>("BoxInterface.taskBox");
    }

    //await BoxInterface.taskBox!.clear();
  }
}
