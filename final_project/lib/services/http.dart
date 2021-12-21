import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

// Weather
const String openWeatherURL = 'api.openweathermap.org';
const String weatherURL = '/data/2.5/weather';
const String weatherApi = "5a5fb541a4bd5913526ebccef75718ab";

//Currency
const String openExchangeURL = 'openexchangerates.org';
const String currencyURL = '/api/latest.json';
const String currencyURL1 = '/api/currencies.json';
const String currencyApi = "779adfbc70d64a92a923fff4a52fa037";

class Http {
  Future getWeatherByLocation() async {
    Position position = await Geolocator.getLastKnownPosition() ??
        await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low);

    final queryParameters = {
      'lat': position.latitude.toString(),
      'lon': position.longitude.toString(),
      'units': 'metric',
      'appid': weatherApi,
    };

    final uri = Uri.https(openWeatherURL, weatherURL, queryParameters);

    final response = await http.get(uri);

    return jsonDecode(response.body);
  }

  Future getWeatherByCity(String city) async {
    final queryParameters = {
      'q': city,
      'units': 'metric',
      'appid': weatherApi,
    };

    final uri = Uri.https(openWeatherURL, weatherURL, queryParameters);

    final response = await http.get(uri);

    return jsonDecode(response.body);
  }

  getCurrency() async {
    final queryParameters = {
      "app_id": currencyApi,
    };

    final uri = Uri.https(openExchangeURL, currencyURL, queryParameters);

    final response = await http.get(uri);

    print((jsonDecode(response.body))["rates"]["TRY"]);
  }

  Future getCurrencies() async {
    final queryParameters = {
      "app_id": currencyApi,
    };

    final uri = Uri.https(openExchangeURL, currencyURL1, queryParameters);

    final response = await http.get(uri);

    return jsonDecode(response.body);
  }
}
