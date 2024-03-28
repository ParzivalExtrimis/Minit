// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:minit/utils/shaders.dart';

class GradientElevatedButton extends StatelessWidget {
  const GradientElevatedButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.isLarge = false});
  final double _borderRadius = 30;
  final String text;
  final bool isLarge;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colorGradientList),
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_borderRadius)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: isLarge
              ? Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  )
              : Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
        ),
      ),
    );
  }
}
