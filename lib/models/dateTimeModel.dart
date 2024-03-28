// ignore_for_file: file_names

import 'package:intl/intl.dart';

class DateTimeModel {
  final DateTime date;

  DateTimeModel({required this.date});
  DateTimeModel.now() : date = DateTime.now();

  String get dayName {
    return DateFormat.E().format(date);
  }

  int get dayNumber {
    return int.parse(DateFormat.d().format(date));
  }

  String get hourMinute {
    return DateFormat.Hm().format(date);
  }

  DateTimeModel addDays(int days) {
    return DateTimeModel(date: date.add(Duration(days: days)));
  }
}
