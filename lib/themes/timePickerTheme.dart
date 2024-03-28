// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:minit/utils/shaders.dart';

final customTimePickerTheme = TimePickerThemeData(
  cancelButtonStyle: TextButton.styleFrom(
    foregroundColor: Colors.black54,
  ),
  confirmButtonStyle: TextButton.styleFrom(
    textStyle: TextStyle(foreground: Paint()..shader = gradientTextShader),
  ),
  dialHandColor: Colors.pink.shade200,
);
