import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/date_selection.dart';
import 'date_range_state.dart';

class DateRangeCubit extends Cubit<DateRangeState> {
  DateRangeCubit() : super(const DateRangeInitial());

  void setStartDate(DateTime date) {
    emit(DateRangeUpdated(
      state.selection.copyWith(startDate: date),
    ));
  }

  void setEndDate(DateTime date) {
    emit(DateRangeUpdated(
      state.selection.copyWith(endDate: date),
    ));
  }

  void setStartHalf(HalfDayType type) {
    emit(DateRangeUpdated(
      state.selection.copyWith(startHalf: type),
    ));
  }

  void setEndHalf(HalfDayType type) {
    emit(DateRangeUpdated(
      state.selection.copyWith(endHalf: type),
    ));
  }
}
