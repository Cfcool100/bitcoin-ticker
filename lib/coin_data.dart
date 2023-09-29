import 'dart:convert';
import 'key.dart';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future getRateCoin(String selectedCurrency) async {
    const apiKey = myKey;
    const url = 'https://rest.coinapi.io/v1/exchangerate';

    Map<String, String> cryptoPrices = {};
    for (String cryptoCoin in cryptoList) {
      http.Response response = await http
          .get(Uri.parse('$url/$cryptoCoin/$selectedCurrency?apikey=$apiKey'));
      if (response.statusCode == 200) {
        var decode = jsonDecode(response.body);
        double price = decode['rate'];

        cryptoPrices[cryptoCoin] = price.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return cryptoPrices;
  }
}
