// ignore_for_file: file_names

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minit/models/dateTimeModel.dart';

final selectedDayProvider =
    StateNotifierProvider<SelectedDayNotifier, DateTimeModel>(
        (ref) => SelectedDayNotifier());

class SelectedDayNotifier extends StateNotifier<DateTimeModel> {
  SelectedDayNotifier() : super(DateTimeModel(date: DateTime.now()));

  void setDateTimeFromDay(DateTimeModel dateTime) {
    state = dateTime;
  }
}
