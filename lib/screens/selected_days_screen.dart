import 'package:flutter/material.dart';
import '../models/date_selection.dart';
import '../widgets/selected_range_calendar.dart';

class SelectedDaysScreen extends StatelessWidget {
  final DateSelection selection;

  const SelectedDaysScreen({super.key, required this.selection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Selected Days"),
        elevation: 0,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SelectedRangeCalendar(selection: selection),
      ),
    );
  }
}
