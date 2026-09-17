class DailyPoint {
  final DateTime date;
  final int? weatherCode;
  final double? temperature2mMax;
  final double? temperature2mMean;
  final double? temperature2mMin;

  const DailyPoint({
    required this.date,
    this.weatherCode,
    this.temperature2mMax,
    this.temperature2mMean,
    this.temperature2mMin,
  });
}

class DailyWeatherInfo {
  final List<DailyPoint> points;

  const DailyWeatherInfo(this.points);

  factory DailyWeatherInfo.fromJson(Map<String, dynamic> data) {
    final times = (data['time'] as List?)?.cast<String>() ?? const <String>[];
    final codes = (data['weather_code'] as List?)?.cast<num?>() ?? const <num?>[];
    final maxs = (data['temperature_2m_max'] as List?)?.cast<num?>() ?? const <num?>[];
    final means = (data['temperature_2m_mean'] as List?)?.cast<num?>() ?? const <num?>[];
    final mins = (data['temperature_2m_min'] as List?)?.cast<num?>() ?? const <num?>[];

    final points = List<DailyPoint>.generate(times.length, (i) {
      return DailyPoint(
        date: DateTime.parse(times[i]),
        weatherCode: i < codes.length ? codes[i]?.toInt() : null,
        temperature2mMax: i < maxs.length ? maxs[i]?.toDouble() : null,
        temperature2mMean: i < means.length ? means[i]?.toDouble() : null,
        temperature2mMin: i < mins.length ? mins[i]?.toDouble() : null,
      );
    });

    return DailyWeatherInfo(points);
  }
}