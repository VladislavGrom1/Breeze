
class CurrentWeatherInfo {
  final DateTime time;
  final int? weatherCode;
  final double? temperature2m;
  final double? apparentTemperature;
  final double? windSpeed10m;
  final double? windDirection10m;
  final double? windGusts10m;
  final double? pressureMsl;
  final double? relativeHumidity2m;

  CurrentWeatherInfo({
    required this.time,
    this.weatherCode,
    this.temperature2m,
    this.apparentTemperature,
    this.windSpeed10m,
    this.windDirection10m,
    this.windGusts10m,
    this.pressureMsl,
    this.relativeHumidity2m
  });

  factory CurrentWeatherInfo.fromJson(Map<String, dynamic> data) {
    return CurrentWeatherInfo(
      time: data['time'] != null ? DateTime.parse(data['time'] as String) : DateTime.now(),
      weatherCode: data["weather_code"], 
      temperature2m: data["temperature_2m"], 
      apparentTemperature: data["apparent_temperature"], 
      windSpeed10m: data["wind_speed_10m"],
      windDirection10m: data["wind_direction_10m"],
      windGusts10m: data["wind_gusts_10m"],
      pressureMsl: data["pressure_msl"],
      relativeHumidity2m: data["relative_humidity_2m"]
    );
  }
}