import 'package:currency_rate_calculator/Currency/Model_Page/Currency_Rate_Model.dart';

abstract class CurrencyState {}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencyLoaded extends CurrencyState {
  final CurrencyModel data;

  CurrencyLoaded(this.data);
}

class CurrencyError extends CurrencyState {
  final String message;

  CurrencyError(this.message);
}

class CurrencySwapped extends CurrencyState {}
