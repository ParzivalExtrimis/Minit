// ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:minit/models/taskModel.dart';
import 'package:minit/utils/shaders.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CountdownWidget extends StatefulWidget {
  const CountdownWidget({super.key, required this.task});
  final TaskModel task;
  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget>
    with WidgetsBindingObserver {
  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  SleekCircularSlider? _slider;

  @override
  void initState() {
    _remainingSeconds = widget.task.remainingSeconds;
    _totalSeconds = widget.task.remainingSeconds;

    _slider = SleekCircularSlider(
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
    super.initState();

    _startCountdown();
  }

  void _setSlideValue(int remainingSeconds) {
    _slider = SleekCircularSlider(
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
      initialValue: ((_totalSeconds - _remainingSeconds) / _totalSeconds) * 100,
    );
  }

  void _startCountdown() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      if (_remainingSeconds <= 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _remainingSeconds--;
        });
        debugPrint('Timer Running: ( Seconds remaining ): $_remainingSeconds');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setSlideValue(_remainingSeconds);
    return _slider ??
        Text(
          'Running',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.black45,
                fontWeight: FontWeight.w300,
              ),
        );
  }
}
