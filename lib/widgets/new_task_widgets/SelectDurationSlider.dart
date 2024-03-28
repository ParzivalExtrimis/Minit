// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:minit/models/durationModel.dart';
import 'package:minit/utils/shaders.dart';

class SelectDurationSlider extends StatefulWidget {
  const SelectDurationSlider({
    super.key,
    this.sliderHeight = 62,
    this.max = 7,
    this.min = 0,
    this.fullWidth = false,
    required this.setDuration,
  });

  final double sliderHeight;
  final int min;
  final int max;
  final bool fullWidth;

  final Function(int) setDuration;

  @override
  State<SelectDurationSlider> createState() => _SelectDurationSliderState();
}

class _SelectDurationSliderState extends State<SelectDurationSlider> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    double paddingFactor = 0.4;

    if (widget.fullWidth) paddingFactor = 0.4;

    return Container(
      width: widget.fullWidth ? double.infinity : (widget.sliderHeight) * 5.5,
      height: (widget.sliderHeight),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular((widget.sliderHeight * 0.3)),
        ),
        gradient: LinearGradient(
            colors: colorGradientList,
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.00),
            stops: const [0.3, 0.6, 0.9],
            tileMode: TileMode.clamp),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(widget.sliderHeight * paddingFactor, 2,
            widget.sliderHeight * paddingFactor, 2),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: widget.sliderHeight * 0.1,
            ),
            Expanded(
              child: Center(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white.withOpacity(1),
                    inactiveTrackColor: Colors.white.withOpacity(0.5),

                    trackHeight: 4.0,
                    thumbColor: Colors.black45,
                    thumbShape: CustomSliderThumbRect(
                      thumbRadius: widget.sliderHeight * 0.4,
                      thumbHeight: widget.sliderHeight * 0.9,
                      min: widget.min,
                      max: widget.max,
                    ),
                    overlayColor: Colors.white.withOpacity(0.4),
                    //valueIndicatorColor: Colors.white,
                    activeTickMarkColor: Colors.white,
                    inactiveTickMarkColor: Colors.red.withOpacity(0.7),
                  ),
                  child: Slider(
                      value: _value,
                      divisions: 6,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                        widget.setDuration(
                            (_value * (widget.max - widget.min)).round());
                      }),
                ),
              ),
            ),
            SizedBox(
              width: widget.sliderHeight * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSliderThumbRect extends SliderComponentShape {
  final double thumbRadius;
  final double thumbHeight;
  final int min;
  final int max;

  const CustomSliderThumbRect({
    required this.thumbRadius,
    required this.thumbHeight,
    required this.min,
    required this.max,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: center, width: thumbHeight * 1.8, height: thumbHeight * 0.75),
      Radius.circular(thumbRadius * 0.6),
    );

    final paint = Paint()
      ..color = sliderTheme.activeTrackColor! //Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = TextSpan(
      style: TextStyle(
          fontSize: thumbHeight * 0.3,
          fontWeight: FontWeight.w700,
          color: sliderTheme.thumbColor,
          height: 1),
      text: getValue(value),
    );
    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawRRect(rRect, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return DurationModel((0 + (max - min) * value).round()).durationString;
    //return durationValues[(0 + (max - min) * value).round()];
  }
}
