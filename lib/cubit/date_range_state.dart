import '../models/date_selection.dart';

abstract class DateRangeState {
  final DateSelection selection;
  const DateRangeState(this.selection);
}

class DateRangeInitial extends DateRangeState {
  const DateRangeInitial() : super(const DateSelection());
}

class DateRangeUpdated extends DateRangeState {
  const DateRangeUpdated(super.selection);
}
