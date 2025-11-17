class CurrencyItem {
  final String code;
  final String name;
  final String flag;

  CurrencyItem({required this.code, required this.name, required this.flag});
}

final List<CurrencyItem> currencies = [
  CurrencyItem(code: "INR", name: "Indian Rupee", flag: "🇮🇳"),
  CurrencyItem(code: "USD", name: "United States Dollar", flag: "🇺🇸"),
  CurrencyItem(code: "EUR", name: "Euro", flag: "🇪🇺"),
  CurrencyItem(code: "GBP", name: "British Pound", flag: "🇬🇧"),
  CurrencyItem(code: "AED", name: "UAE Dirham", flag: "🇦🇪"),
  CurrencyItem(code: "JPY", name: "Japanese Yen", flag: "🇯🇵"),
  CurrencyItem(code: "AUD", name: "Australian Dollar", flag: "🇦🇺"),
  CurrencyItem(code: "CAD", name: "Canadian Dollar", flag: "🇨🇦"),
  CurrencyItem(code: "CHF", name: "Swiss Franc", flag: "🇨🇭"),
  CurrencyItem(code: "SGD", name: "Singapore Dollar", flag: "🇸🇬"),
];
