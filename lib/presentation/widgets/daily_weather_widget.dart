import 'package:breeze/app/util/mouse_drag_scroll_behavior.dart';
import 'package:breeze/data/formatters/date_formatter.dart';
import 'package:breeze/data/model/daily_weather_info.dart';
import 'package:flutter/material.dart';

class DailyWeatherWidget extends StatelessWidget {
  final DailyWeatherInfo? dailyWeather;
  
  const DailyWeatherWidget({
    super.key,
    required this.dailyWeather
  });

  @override
  Widget build(BuildContext context) {
    final weatherPoints = dailyWeather?.points ?? const <DailyPoint>[];
    final itemCount = weatherPoints.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Прогноз на 7 дней",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: itemCount == 0
                  ? const Center(child: Text('Нет данных'))
                  : ScrollConfiguration(
                    behavior: MouseDragScrollBehavior(),
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: itemCount,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final weatherInfo = weatherPoints[index];
                          return SizedBox(
                            width: 90,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormatter.formatDay(weatherInfo.date.toString(), index: index),
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  weatherInfo.temperature2mMean != null ? '${weatherInfo.temperature2mMean} °C' : '-',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}