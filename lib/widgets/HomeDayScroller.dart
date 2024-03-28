// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minit/models/dateTimeModel.dart';
import 'package:minit/providers/selectedDayProvider.dart';
import 'package:minit/widgets/HomeDayScrollerCard.dart';

class HomeDayScroller extends ConsumerStatefulWidget {
  const HomeDayScroller({super.key});

  @override
  ConsumerState<HomeDayScroller> createState() => _HomeDayScrollerState();
}

class _HomeDayScrollerState extends ConsumerState<HomeDayScroller> {
  late DateTimeModel selectedDate;
  late final DateTimeModel today;

  bool isSelectedDay(DateTimeModel d) {
    return (d.date.day == selectedDate.date.day) &&
        (d.date.month == selectedDate.date.month) &&
        (d.date.year == selectedDate.date.year);
  }

  @override
  void initState() {
    selectedDate = DateTimeModel(date: DateTime.now());
    today = DateTimeModel(date: DateTime.now());
    super.initState();
  }

  void onSelectDay(DateTimeModel date) {
    setState(() {
      selectedDate = date;
    });
    ref.read(selectedDayProvider.notifier).setDateTimeFromDay(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(7, (index) => index - 2)
            .map(
              (e) => HomeDayScrollerCard(
                date: today.addDays(e),
                onSelectDay: onSelectDay,
                isSelectedDay: isSelectedDay(today.addDays(e)),
              ),
            )
            .toList(),
      ),
    );
  }
}
