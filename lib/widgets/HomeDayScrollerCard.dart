// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:minit/models/dateTimeModel.dart';
import 'package:minit/utils/shaders.dart';

class HomeDayScrollerCard extends StatelessWidget {
  const HomeDayScrollerCard({
    super.key,
    required this.onSelectDay,
    required this.isSelectedDay,
    required this.date,
  });
  final Function(DateTimeModel) onSelectDay;
  final bool isSelectedDay;

  final DateTimeModel date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 20),
      child: Card(
        child: InkWell(
            onTap: () => onSelectDay(date),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: isSelectedDay
                  ? const EdgeInsets.all(20)
                  : const EdgeInsets.all(18),
              child: Column(
                children: [
                  Text(
                    date.dayName.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          foreground: Paint()
                            ..shader = isSelectedDay
                                ? gradientTextShader
                                : plainBlackTextShader,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      date.dayNumber.toString(),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            foreground: Paint()
                              ..shader = isSelectedDay
                                  ? gradientTextShader
                                  : plainBlackTextShader,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
