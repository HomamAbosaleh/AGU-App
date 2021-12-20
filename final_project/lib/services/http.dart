import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

const String openWeatherURL = 'api.openweathermap.org';
const String dataURL = '/data/2.5/weather';
const String weatherApi = "5a5fb541a4bd5913526ebccef75718ab";
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

    final uri = Uri.https(openWeatherURL, dataURL, queryParameters);

    final response = await http.get(uri);

    return response.body;
  }

  Future getWeatherByCity(String city) async {
    final queryParameters = {
      'q': city,
      'units': 'metric',
      'appid': weatherApi,
    };

    final uri = Uri.https(openWeatherURL, dataURL, queryParameters);

    final response = await http.get(uri);

    return response.body;
  }

  Future getCurrency() async {}
}
