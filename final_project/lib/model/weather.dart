class Weather {
  final int humidity;
  final int temperature;
  final int highTemp;
  final int lowTemp;
  final int visibility;
  final int pressure;
  final int feelsLike;
  final double windSpeed;
  final String locationName;
  final int weatherID;

  Weather({
    required this.humidity,
    required this.temperature,
    required this.highTemp,
    required this.lowTemp,
    required this.visibility,
    required this.pressure,
    required this.feelsLike,
    required this.locationName,
    required this.windSpeed,
    required this.weatherID,
  });
}
