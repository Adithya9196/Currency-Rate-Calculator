import 'package:currency_rate_calculator/Currency/Data/currency_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'currency_event.dart';
import 'currency_state.dart';
import 'package:currency_rate_calculator/Currency/Data/currency_repository.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyRepository repository;

  CurrencyItem fromCurrency;
  CurrencyItem toCurrency;

  CurrencyBloc({
    required this.repository,
    required this.fromCurrency,
    required this.toCurrency,
  }) : super(CurrencyInitial()) {

    on<ConvertCurrencyEvent>((event, emit) async {
      emit(CurrencyLoading());
      try {
        final result = await repository.convertCurrency(
          from: event.from,
          to: event.to,
          amount: event.amount,
        );
        emit(CurrencyLoaded(result));
      } catch (e) {
        emit(CurrencyError(e.toString()));
      }
    });

    on<SwapCurrenciesEvent>((event, emit) {
      final temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;

      emit(CurrencySwapped());
    });

    on<SelectFromCurrencyEvent>((event, emit) {
      fromCurrency = event.item;
      emit(CurrencyInitial());
    });

    on<SelectToCurrencyEvent>((event, emit) {
      toCurrency = event.item;
      emit(CurrencyInitial());
    });

  }
}
