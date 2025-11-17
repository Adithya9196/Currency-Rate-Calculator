import 'package:currency_rate_calculator/Currency/Data/currency_list.dart';

abstract class CurrencyEvent {}

class ConvertCurrencyEvent extends CurrencyEvent {
  final String from;
  final String to;
  final String amount;

  ConvertCurrencyEvent({
    required this.from,
    required this.to,
    required this.amount,
  });
}

class SwapCurrenciesEvent extends CurrencyEvent {}

class SelectFromCurrencyEvent extends CurrencyEvent {
  final CurrencyItem item;
  SelectFromCurrencyEvent(this.item);
}

class SelectToCurrencyEvent extends CurrencyEvent {
  final CurrencyItem item;
  SelectToCurrencyEvent(this.item);
}
