import 'package:flutter/material.dart';

class TimePickerWidget extends StatelessWidget {
  final Function(TimeOfDay) onTimeSelected;
  final String label;

  const TimePickerWidget({
    Key? key,
    required this.onTimeSelected,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          onTimeSelected(pickedTime);
        }
      },
      child: Text(label),
    );
  }
}