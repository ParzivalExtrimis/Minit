// ignore_for_file: file_names

const List<int> durationInMinutes = [10, 15, 30, 45, 60, 90, 120, 150];

class DurationModel {
  int? index;
  int minutes;

  DurationModel(int index)
      : index = index % durationInMinutes.length,
        minutes = durationInMinutes[index];

  DurationModel.fromSeconds(int seconds)
      : index = 0,
        minutes = 10 {
    minutes = (seconds / 60).ceil();
  }

  int get getInSeconds {
    return minutes * 60;
  }

  String get durationString {
    if (minutes < 60) {
      return '$minutes min';
    }
    return '${(minutes / 60).floor()} hr ${(minutes % 60)} min';
  }
}
