import 'package:currency_rate_calculator/Currency/Model_Page/Currency_Rate_Model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CurrencyRepository {
  final Dio _dio = Dio();

  final String baseUrl = dotenv.env['BASE_URL']!;
  final String accessKey = dotenv.env['ACCESS_KEY']!;

  Future<CurrencyModel> convertCurrency({
    required String from,
    required String to,
    required String amount,
  }) async {
    if (baseUrl.isEmpty || accessKey.isEmpty) {
      throw Exception("API baseUrl or accessKey is not defined!");
    }

    final response = await _dio.get(
      baseUrl,
      queryParameters: {
        "from": from,
        "to": to,
        "amount": amount,
        "access_key": accessKey,
      },
    );

    return CurrencyModel.fromJson(response.data);
  }
}
