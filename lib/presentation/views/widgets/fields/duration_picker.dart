import 'package:flutter/material.dart';

class DurationPicker extends StatefulWidget {
  final Function(Duration) onDurationSelected;
  final Duration initialDuration;

  const DurationPicker({
    super.key,
    required this.onDurationSelected,
    this.initialDuration = const Duration(hours: 0, minutes: 0),
  });

  @override
  State<DurationPicker> createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  late int selectedHours;
  late int selectedMinutes;

  @override
  void initState() {
    super.initState();
    selectedHours = widget.initialDuration.inHours;
    selectedMinutes = widget.initialDuration.inMinutes % 60;
  }

  void _updateDuration() {
    widget.onDurationSelected(Duration(hours: selectedHours, minutes: selectedMinutes));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        DropdownButton<int>(
            value: selectedHours,
            items: List.generate(100, (index) => index)
                .map((value) => DropdownMenuItem(
              value: value,
              child: Text('$value hr'),
            )).toList(),
            onChanged: (value) {
              setState(() {
                selectedHours = value!;
                _updateDuration();
              });
            },
        ),
        const SizedBox(width: 16),
        DropdownButton<int>(
          value: selectedMinutes,
          items: List.generate(60, (index) => index)
              .map((value) => DropdownMenuItem(
            value: value,
            child: Text('$value min'),
          ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedMinutes = value!;
              _updateDuration();
            });
          },
        ),
      ],
    );
  }
}