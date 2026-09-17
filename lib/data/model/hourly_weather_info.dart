class HourlyPoint {
  final DateTime time;
  final int? weatherCode;
  final double? temperature2m;
  final double? apparentTemperature;
  final int? relativeHumidity2m;

  const HourlyPoint({
    required this.time,
    this.weatherCode,
    this.temperature2m,
    this.apparentTemperature,
    this.relativeHumidity2m,
  });
}

class HourlyWeatherInfo {
  final List<HourlyPoint> points;

  const HourlyWeatherInfo(this.points);

  factory HourlyWeatherInfo.fromJson(Map<String, dynamic> data) {
    final times = (data['time'] as List?)?.cast<String>() ?? const <String>[];
    final codes = (data['weather_code'] as List?)?.cast<num?>() ?? const <num?>[];
    final temps = (data['temperature_2m'] as List?)?.cast<num?>() ?? const <num?>[];
    final feels = (data['apparent_temperature'] as List?)?.cast<num?>() ?? const <num?>[];
    final hums = (data['relative_humidity_2m'] as List?)?.cast<num?>() ?? const <num?>[];

    final points = List<HourlyPoint>.generate(times.length, (i) {
      return HourlyPoint(
        time: DateTime.parse(times[i]),
        weatherCode: i < codes.length ? codes[i]?.toInt() : null,
        temperature2m: i < temps.length ? temps[i]?.toDouble() : null,
        apparentTemperature: i < feels.length ? feels[i]?.toDouble() : null,
        relativeHumidity2m: i < hums.length ? hums[i]?.toInt() : null,
      );
    });

    return HourlyWeatherInfo(points);
  }
}