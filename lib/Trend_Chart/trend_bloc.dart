import 'package:flutter_bloc/flutter_bloc.dart';
import 'trend_event.dart';
import 'trend_state.dart';

class TrendBloc extends Bloc<TrendEvent, TrendState> {
  TrendBloc() : super(TrendInitial()) {
    on<LoadTrendEvent>((event, emit) async {
      emit(TrendLoading());
      await Future.delayed(Duration(milliseconds: 500));


      final intValues = [100, 110, 105, 115, 120];
      final values = intValues.map((e) => e.toDouble()).toList();
      final dates = ["Day 1", "Day 2", "Day 3", "Day 4", "Day 5"];

      emit(TrendLoaded(values: values, dates: dates));
    });
  }
}
