import 'package:flutter/material.dart';
import 'package:minit/models/taskModel.dart';
import 'package:minit/utils/shaders.dart';
import 'package:minit/widgets/coundown_widgets/CountdownWidget.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CountdownTriggerWidget extends StatelessWidget {
  const CountdownTriggerWidget({
    super.key,
    required this.task,
  });

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return task.isRunning
        ? CountdownWidget(task: task)
        : const ZeroCountSlider();
  }
}

class ZeroCountSlider extends StatelessWidget {
  const ZeroCountSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
        startAngle: 90,
        angleRange: 360,
        customWidths: CustomSliderWidths(
          progressBarWidth: 3.2,
          handlerSize: 0,
          trackWidth: 1.2,
        ),
        customColors: CustomSliderColors(
          trackColor: Colors.grey,
          progressBarColors: colorGradientList,
        ),
        infoProperties: InfoProperties(
          mainLabelStyle: const TextStyle(
            color: Colors.indigo,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      // values
      min: 0,
      max: 100,
      initialValue: 0,
    );
  }
}
