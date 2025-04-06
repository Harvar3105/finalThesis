import 'package:flutter/material.dart';

class DateTimePicker extends StatelessWidget{
  final Function(DateTime) onDateSelected;
  final String label;

  const DateTimePicker({super.key, required this.onDateSelected, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          final pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null) {
            final selectedDateTime = DateTime(
              pickedDate.year, pickedDate.month, pickedDate.day,
              pickedTime.hour, pickedTime.minute,
            );
            onDateSelected(selectedDateTime);
          }
        }
      },
      child: Text(label),
    );
  }
}