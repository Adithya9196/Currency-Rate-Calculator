import 'dart:convert';

CurrencyModel currencyModelFromJson(String str) =>
    CurrencyModel.fromJson(json.decode(str));

String currencyModelToJson(CurrencyModel data) =>
    json.encode(data.toJson());

class CurrencyModel {
  String base;
  String amount;
  Map<String, double> result;
  int ms;

  CurrencyModel({
    required this.base,
    required this.amount,
    required this.result,
    required this.ms,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    final resultMap = <String, double>{};
    json["result"].forEach((key, value) {
      resultMap[key] = value.toDouble();
    });

    return CurrencyModel(
      base: json["base"],
      amount: json["amount"].toString(),
      result: resultMap,
      ms: json["ms"],
    );
  }

  Map<String, dynamic> toJson() => {
    "base": base,
    "amount": amount,
    "result": result,
    "ms": ms,
  };
}
