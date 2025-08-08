import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/date_range_cubit.dart';
import '../cubit/date_range_state.dart';
import '../widgets/half_day_selector.dart';
import 'selected_days_screen.dart';

class DateRangeScreen extends StatelessWidget {
  const DateRangeScreen({super.key});

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final cubit = context.read<DateRangeCubit>();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sel = cubit.state.selection;

    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? today
          : (sel.startDate ?? today), // Default to start date if available
      firstDate: isStart
          ? today
          : (sel.startDate ?? today), // Prevent selecting before start date
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isStart) {
        if (sel.endDate != null &&
            picked.isAtSameMomentAs(
              DateTime(sel.endDate!.year, sel.endDate!.month, sel.endDate!.day),
            )) {
          _showSnack(context, "Start date and end date cannot be the same.");
          return;
        }
        cubit.setStartDate(picked);
      } else {
        if (sel.startDate != null &&
            picked.isAtSameMomentAs(
              DateTime(sel.startDate!.year, sel.startDate!.month, sel.startDate!.day),
            )) {
          _showSnack(context, "Start date and end date cannot be the same.");
          return;
        }
        cubit.setEndDate(picked);
      }
    }
  }


  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DateRangeCubit(),
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            title: const Text("Select Date Range"),
            elevation: 0,
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          body: BlocBuilder<DateRangeCubit, DateRangeState>(
            builder: (context, state) {
              final sel = state.selection;
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildDateCard(
                      title: "Start Date",
                      dateText: sel.startDate != null
                          ? DateFormat('dd MMMM yyyy').format(sel.startDate!) // e.g. "08 Aug 2025"
                          : "Tap to choose",
                      onTap: () => _pickDate(context, true),
                      halfDayWidget: HalfDaySelector(
                        selected: sel.startHalf,
                        isStart: true,
                        onChanged: (type) => context.read<DateRangeCubit>().setStartHalf(type),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildDateCard(
                      title: "End Date",
                      dateText: sel.endDate != null
                          ? DateFormat('dd MMMM yyyy').format(sel.endDate!) // e.g. "15 Aug 2025"
                          : "Tap to choose",
                      onTap: () => _pickDate(context, false),
                      halfDayWidget: HalfDaySelector(
                        selected: sel.endHalf,
                        isStart: false,
                        onChanged: (type) => context.read<DateRangeCubit>().setEndHalf(type),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: (sel.startDate != null && sel.endDate != null)
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SelectedDaysScreen(selection: sel),
                            ),
                          );
                        }
                            : null,
                        child: const Text(
                          "Show Selected Days",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDateCard({
    required String title,
    required String dateText,
    required VoidCallback onTap,
    required Widget halfDayWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    dateText,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          halfDayWidget,
        ],
      ),
    );
  }
}
