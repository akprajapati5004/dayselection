import 'package:flutter/material.dart';
import '../models/date_selection.dart';

class HalfDaySelector extends StatelessWidget {
  final HalfDayType selected;
  final ValueChanged<HalfDayType> onChanged;
  final bool isStart;

  const HalfDaySelector({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.isStart,
  });

  @override
  Widget build(BuildContext context) {
    final items = isStart
        ? const [
      DropdownMenuItem(
        value: HalfDayType.none,
        child: Text("Full Day"),
      ),
      DropdownMenuItem(
        value: HalfDayType.secondHalf,
        child: Text("Second Half"),
      ),
    ]
        : const [
      DropdownMenuItem(
        value: HalfDayType.none,
        child: Text("Full Day"),
      ),
      DropdownMenuItem(
        value: HalfDayType.firstHalf,
        child: Text("First Half"),
      ),
    ];

    return DropdownButton<HalfDayType>(
      value: selected,
      onChanged: (HalfDayType? newValue) {
        if (newValue != null) {
          onChanged(newValue);
        }
      },
      items: items,
    );
  }
}
