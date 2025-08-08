enum HalfDayType { none, firstHalf, secondHalf }

class DateSelection {
  final DateTime? startDate;
  final DateTime? endDate;
  final HalfDayType startHalf;
  final HalfDayType endHalf;

  const DateSelection({
    this.startDate,
    this.endDate,
    this.startHalf = HalfDayType.none,
    this.endHalf = HalfDayType.none,
  });

  DateSelection copyWith({
    DateTime? startDate,
    DateTime? endDate,
    HalfDayType? startHalf,
    HalfDayType? endHalf,
  }) {
    return DateSelection(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startHalf: startHalf ?? this.startHalf,
      endHalf: endHalf ?? this.endHalf,
    );
  }
}
