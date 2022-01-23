import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../model/weather.dart';

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
  Future<Position> getLocation() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  Future getWeatherByLocation() async {
    try {
      Weather weather;
      Position position = await getLocation();

      final queryParameters = {
        'lat': position.latitude.toString(),
        'lon': position.longitude.toString(),
        'units': 'metric',
        'appid': weatherApi,
      };

      final uri = Uri.https(openWeatherURL, weatherURL, queryParameters);

      final response = await http.get(uri);

      final json = jsonDecode(response.body);
      weather = Weather(
          humidity: json["main"]["humidity"],
          highTemp: (json["main"]["temp_max"]).toInt(),
          feelsLike: (json["main"]["feels_like"]).toInt(),
          locationName: json["name"],
          lowTemp: (json["main"]["temp_min"]).toInt(),
          pressure: json["main"]["pressure"],
          temperature: (json["main"]["temp"]).toInt(),
          visibility: (json["visibility"]).toInt(),
          windSpeed: (json["wind"]["speed"]).toDouble(),
          weatherID: json["weather"][0]["id"]);
      return weather;
    } catch (ex) {
      print(ex.toString());
    }
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

  IconData getWeatherIcon(int condition) {
    if (condition < 300) {
      return FontAwesomeIcons.cloudRain;
    } else if (condition < 400) {
      return FontAwesomeIcons.cloudShowersHeavy;
    } else if (condition < 600) {
      return FontAwesomeIcons.umbrella;
    } else if (condition < 700) {
      return FontAwesomeIcons.snowflake;
    } else if (condition < 800) {
      return FontAwesomeIcons.smog;
    } else if (condition == 800) {
      return FontAwesomeIcons.sun;
    } else if (condition < 804) {
      return FontAwesomeIcons.cloud;
    } else {
      return FontAwesomeIcons.question;
    }
  }

  exchange(String name, double amount) async {
    final queryParameters = {
      "app_id": currencyApi,
    };

    final uri = Uri.https(openExchangeURL, currencyURL, queryParameters);

    final response = await http.get(uri);

    final mapOfCurrencies = jsonDecode(response.body);

    if (name == "USD") {
      return (mapOfCurrencies)["rates"]["TRY"] * amount;
    } else {
      return amount / (mapOfCurrencies)["rates"][name] * (mapOfCurrencies)["rates"]["TRY"];
      // print((mapOfCurrencies)["rates"][name]);
      // print((mapOfCurrencies)["rates"]["TRY"]);
    }
  }
}
