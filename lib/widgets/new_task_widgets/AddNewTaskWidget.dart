// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minit/models/dateTimeModel.dart';
import 'package:minit/models/durationModel.dart';
import 'package:minit/models/taskModel.dart';
import 'package:minit/providers/selectedDayProvider.dart';
import 'package:minit/providers/taskListProvider.dart';
import 'package:minit/widgets/new_task_widgets/GradientElevatedButton.dart';
import 'package:minit/widgets/new_task_widgets/GradientTextFormInputBox.dart';
import 'package:minit/widgets/new_task_widgets/SelectDurationSlider.dart';
import 'package:minit/widgets/new_task_widgets/TimePicker.dart';

class AddNewTaskWidget extends ConsumerStatefulWidget {
  const AddNewTaskWidget({super.key});

  @override
  ConsumerState<AddNewTaskWidget> createState() => _AddNewTaskWidgetState();
}

class _AddNewTaskWidgetState extends ConsumerState<AddNewTaskWidget> {
  final _formKey = GlobalKey<FormState>();
  double _keyBoardArea = 0;

  static const Duration fiveMinutes = Duration(minutes: 5);
  static final TimeOfDay initialTime = TimeOfDay.fromDateTime(
      DateTime.now().add(fiveMinutes)); // initial time set to 5 mons from now

// input retrievers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _startTime = DateTime.now().add(fiveMinutes);
  int _durationIndex = 0;

  late final DateTimeModel _contextDay;

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  Future<void> _showInvalidTimeSelected(BuildContext ctx, int hour, int min) {
    return showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Invalid time selected"),
          content: Text(
              "The time selected ( $hour:$min ) has already passed. Please select a different time."),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  _setDateTime(DateTime contextDay, TimeOfDay time) {
    debugPrint(
        'Time selected as a double: ${toDouble(time)}. \n Current time as a double: ${toDouble(TimeOfDay.now())}');

    _startTime = DateTime(
      contextDay.year,
      contextDay.month,
      contextDay.day,
      time.hour,
      time.minute,
    );
  }

  _setDurationIndex(int index) {
    _durationIndex = index;
  }

  @override
  void initState() {
    _contextDay = ref.read(selectedDayProvider);
    _setDateTime(_contextDay.date, initialTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _keyBoardArea = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      maintainBottomViewPadding: false,
      minimum: const EdgeInsets.all(5),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 15 + _keyBoardArea),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // move the inputboxes into a custom widget
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 30, 18, 12),
                  child: GradientTextFormInputBox(
                    'Title',
                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title cannot be empty';
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
                  child: GradientTextFormInputBox(
                    'Description',
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    validator: (value) => null,
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                  child: SelectDurationSlider(
                    setDuration: _setDurationIndex,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TimePicker(
                    initialDateTime: DateTime(
                        _contextDay.date.year,
                        _contextDay.date.month,
                        _contextDay.date.day,
                        initialTime.hour,
                        initialTime.minute),
                    setDateTime: _setDateTime,
                  ),
                ),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate returns true if the form is valid, or false otherwise.
                          Navigator.of(context).pop();
                        },
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 14, horizontal: 6),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      // submit button
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 8),
                      child: GradientElevatedButton(
                        text: 'Submit',
                        isLarge: true,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String title = _titleController.text;
                            String description = _descriptionController.text;

                            if (_startTime.compareTo(DateTime.now()) <= 0) {
                              return await _showInvalidTimeSelected(
                                  context, _startTime.hour, _startTime.minute);
                            }

                            TaskModel task = TaskModel.autoId(
                              title: title,
                              description:
                                  description.isNotEmpty ? description : title,
                              startTime: _startTime,
                              remainingSeconds:
                                  DurationModel(_durationIndex).getInSeconds,
                              isRunning: false,
                            );

                            ref.read(taskListProvider.notifier).addTask(task);
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
