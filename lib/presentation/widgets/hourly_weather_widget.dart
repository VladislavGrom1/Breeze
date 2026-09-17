import 'package:breeze/data/formatters/date_formatter.dart';
import 'package:flutter/material.dart';

class HourlyWeatherWidget extends StatelessWidget {
  final Map<String, dynamic>? hourlyWeather;
  
  const HourlyWeatherWidget({
    super.key,
    required this.hourlyWeather
  });

  @override
  Widget build(BuildContext context) {
    final dates = hourlyWeather?["time"] as List?;
    final values = hourlyWeather?['temperature_2m'] as List?;
    final itemCount = dates?.length ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Сегодня",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: itemCount == 0
                  ? const Center(child: Text('Нет данных'))
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: itemCount,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final date = dates?[index];
                        final value = values != null && index < values.length
                            ? values[index]
                            : null;
                        return SizedBox(
                          width: 90,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormatter.formatHour(date?.toString() ?? '-'),
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                value != null ? '$value °C' : '-',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}