// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:minit/utils/shaders.dart';

class GradientTextFormInputBox extends StatelessWidget {
  GradientTextFormInputBox(
    this.title, {
    super.key,
    required this.validator,
    this.keyboardType = TextInputType.multiline,
    this.maxLines = 1,
    required this.controller,
  });

  final _inputBorderRadius = BorderRadius.circular(12);
  final String title;
  final Function(String?) validator;
  final TextEditingController controller;

  final TextInputType keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      controller: controller,
      decoration: InputDecoration(
        label: Text(title),
        alignLabelWithHint: true,
        focusedBorder: GradientOutlineInputBorder(
          gradient: LinearGradient(colors: colorBrightGradientList),
          borderRadius: _inputBorderRadius,
          width: 2,
        ),
        floatingLabelStyle:
            TextStyle(foreground: Paint()..shader = gradientBrightTextShader),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black45,
            width: 2,
          ),
          borderRadius: _inputBorderRadius,
          gapPadding: 4,
        ),
      ),
      validator: (value) => validator(value),
    );
  }
}
