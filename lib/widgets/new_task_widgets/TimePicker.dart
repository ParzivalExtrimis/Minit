// ignore_for_file: file_names

import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  const TimePicker(
      {super.key, required this.setDateTime, required this.initialDateTime});

  final Function(DateTime, TimeOfDay) setDateTime;
  final DateTime initialDateTime;

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    _selectedTime = TimeOfDay.fromDateTime(widget.initialDateTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: IconButton.outlined(
            onPressed: () async => await _selectTime(context),
            iconSize: 28,
            icon: const Icon(Icons.alarm),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                style: BorderStyle.solid,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Text(
                _selectedTime.hour.toString().length > 1
                    ? _selectedTime.hour.toString()
                    : '0${_selectedTime.hour.toString()}',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black45,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
          ),
        ),
        Text(
          ':',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                style: BorderStyle.solid,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(9),
              child: Text(
                _selectedTime.minute.toString().length > 1
                    ? _selectedTime.minute.toString()
                    : '0${_selectedTime.minute.toString()}',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black45,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    // ignore: non_constant_identifier_names
    final TimeOfDay? picked_s = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (picked_s != null && picked_s != _selectedTime) {
      setState(() {
        _selectedTime = picked_s;
      });
      widget.setDateTime(widget.initialDateTime, picked_s);
    }
  }
}
