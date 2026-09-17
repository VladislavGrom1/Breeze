
class CurrentWeatherInfo {
  final DateTime time;
  final int? weatherCode;
  final double? temperature2m;
  final double? apparentTemperature;
  final double? relativeHumidity2m;

  CurrentWeatherInfo({
    required this.time,
    this.weatherCode,
    this.temperature2m,
    this.apparentTemperature,
    this.relativeHumidity2m
  });

  factory CurrentWeatherInfo.fromJson(Map<String, dynamic> data) {
    return CurrentWeatherInfo(
      time: data['time'] != null ? DateTime.parse(data['time'] as String) : DateTime.now(),
      weatherCode: data["weather_code"], 
      temperature2m: data["temperature_2m"], 
      apparentTemperature: data["apparent_temperature"], 
      relativeHumidity2m: data["relative_humidity_2m"]
    );
  }
}