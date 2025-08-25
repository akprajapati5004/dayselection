import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/date_selection.dart';

class SelectedRangeCalendar extends StatelessWidget {
  final DateSelection selection;

  const SelectedRangeCalendar({super.key, required this.selection});

  @override
  Widget build(BuildContext context) {
    if (selection.startDate == null || selection.endDate == null) {
      return const Center(child: Text("No selection"));
    }

    final start = DateTime(
      selection.startDate!.year,
      selection.startDate!.month,
    );
    final end = DateTime(selection.endDate!.year, selection.endDate!.month);

    final months = <DateTime>[];
    DateTime current = start;
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      months.add(DateTime(current.year, current.month));
      current = DateTime(current.year, current.month + 1);
    }

    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: months.length,
        itemBuilder: (context, index) {
          final month = months[index];
          final lastDay = DateTime(month.year, month.month + 1, 0);
          final days = List.generate(
            lastDay.day,
                (i) => DateTime(month.year, month.month, i + 1),
          );
      
          final firstDayOfMonth = DateTime(month.year, month.month, 1);
          final firstWeekdayOffset = firstDayOfMonth.weekday % 7;
      
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  DateFormat("MMMM yyyy").format(month),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
      
              // Weekday headers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                    .map((day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ))
                    .toList(),
              ),
              const SizedBox(height: 6),
      
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 0.6,
                ),
                itemCount: firstWeekdayOffset + days.length,
                itemBuilder: (context, gridIndex) {
                  if (gridIndex < firstWeekdayOffset) {
                    // Empty cell before first day
                    return const SizedBox.shrink();
                  }
      
                  final dayIndex = gridIndex - firstWeekdayOffset;
                  final date = days[dayIndex];
      
                  Widget cell = _buildEmptyCell(date);
      
                  if (!date.isBefore(selection.startDate!) &&
                      !date.isAfter(selection.endDate!)) {
                    if (date.isAtSameMomentAs(selection.startDate!)) {
                      if (selection.startHalf == HalfDayType.secondHalf) {
                        cell = _buildHalfCell(
                          date,
                          Colors.orange,
                          bottom: true,
                          label: "SH",
                        );
                      } else {
                        cell = _buildFullCell(date, Colors.teal);
                      }
                    } else if (date.isAtSameMomentAs(selection.endDate!)) {
                      if (selection.endHalf == HalfDayType.firstHalf) {
                        cell = _buildHalfCell(
                          date,
                          Colors.purple,
                          top: true,
                          label: "FH",
                        );
                      } else {
                        cell = _buildFullCell(date, Colors.teal);
                      }
                    } else {
                      cell = _buildFullCell(date, Colors.teal.withValues(alpha: 0.7));
                    }
                  }
      
                  return cell;
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCell(DateTime date) {
    return Container(
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text("${date.day}", style: const TextStyle(color: Colors.black87)),
    );
  }

  Widget _buildFullCell(DateTime date, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.all(3),
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.85)]),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            "${date.day}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        _dotIndicator(color),
      ],
    );
  }

  Widget _buildHalfCell(
      DateTime date,
      Color color, {
        bool top = false,
        bool bottom = false,
        String? label,
      }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.all(3),
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade300,
          ),
          child: Stack(
            children: [
              if (top)
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [color, color.withValues(alpha: 0)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              if (bottom)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [color, color.withValues(alpha: 0)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              Center(
                child: Text(
                  "${date.day}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        if (label != null)
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        _dotIndicator(color),
      ],
    );
  }

  Widget _dotIndicator(Color color) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.only(top: 4),
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
    );
  }
}
