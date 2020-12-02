import 'dart:convert';

import 'package:http/http.dart' as http;

const apiKey = 'A7A9A730-4F5F-419D-80FA-CAD0FA787B62';
const baseUrl = 'https://rest.coinapi.io/v1/exchangerate';

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

  Future getExchangeRate(String fromCurrency, String toCurrency) async{
    String url = baseUrl + '/$fromCurrency' + '/$toCurrency' + '?apikey=$apiKey';
    http.Response response = await http.get(url);
    if(response.statusCode == 200) {
      double rate = jsonDecode(response.body)['rate'];
      return '1 $fromCurrency = ${rate.toStringAsFixed(2)} $toCurrency';
    }
    return '1 $fromCurrency = ? $toCurrency';
  }

  String getFromCurrency(response) {
      if(response.statusCode == 200) {
        return jsonDecode(response.body)['asset_id_base'];
    }
      return null;
  }

  String getResultString(response,toCurrency) {
    if(response.statusCode == 200) {
      var rate = jsonDecode(response.body)['rate'];
      String rateString = (rate is double) ? rate.toStringAsFixed(0): rate.toString();
      String fromCurrency = jsonDecode(response.body)['asset_id_base'];
      return '1 $fromCurrency = $rateString $toCurrency';
    }
    return null;
  }

  Future<Map<String, String>> getAllExchangeRates(String toCurrency) async {
    List<http.Response> responseList = await Future.wait(cryptoList.map((itemId) => http.get(baseUrl + '/$itemId' + '/$toCurrency' + '?apikey=$apiKey')));
    return Map.fromIterable(responseList, key: (response) => getFromCurrency(response), value: (response) => getResultString(response,toCurrency));
  }
  
}
