import 'package:flutter/material.dart';

final List<Color> colorGradientList = [
  Colors.indigo.shade200,
  Colors.purple.shade200,
  Colors.pink.shade200
];

final List<Color> colorBrightGradientList = [
  Colors.indigo,
  Colors.purple,
  Colors.pink
];

final Shader gradientTextShader = LinearGradient(
  colors: colorGradientList,
).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

final Shader gradientBrightTextShader = LinearGradient(
  colors: colorBrightGradientList,
).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

final Shader plainBlackTextShader = const LinearGradient(
  colors: [Colors.black54, Colors.black54],
).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

final Shader plainWhiteTextShader = const LinearGradient(
  colors: [Colors.white, Colors.white],
).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
