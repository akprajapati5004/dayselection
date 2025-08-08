import 'package:flutter/material.dart';
import '../models/date_selection.dart';

class DateCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isStart;
  final bool isEnd;
  final HalfDayType halfDayType;
  final VoidCallback onTap;

  const DateCell({
    super.key,
    required this.date,
    required this.isSelected,
    required this.isStart,
    required this.isEnd,
    required this.halfDayType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    if (isStart && halfDayType == HalfDayType.secondHalf) {
      bgColor = Colors.orange;
    } else if (isEnd && halfDayType == HalfDayType.firstHalf) {
      bgColor = Colors.purple;
    } else if (isSelected) {
      bgColor = Colors.blue;
    } else {
      bgColor = Colors.white;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text("${date.day}"),
      ),
    );
  }
}
