abstract class TrendEvent {}

class LoadTrendEvent extends TrendEvent {
  final String fromCurrency;
  final String toCurrency;

  LoadTrendEvent({required this.fromCurrency, required this.toCurrency});
}
