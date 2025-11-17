abstract class TrendState {}

class TrendInitial extends TrendState {}

class TrendLoading extends TrendState {}

class TrendLoaded extends TrendState {
  final List<double> values;
  final List<String> dates;

  TrendLoaded({required this.values, required this.dates});

  double get min => values.reduce((a, b) => a < b ? a : b);
  double get max => values.reduce((a, b) => a > b ? a : b);
  double get avg => values.reduce((a, b) => a + b) / values.length;
}

class TrendError extends TrendState {
  final String message;
  TrendError({required this.message});
}
