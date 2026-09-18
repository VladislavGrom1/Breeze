import 'package:breeze/app/constants/weather_type.dart';
import 'package:breeze/app/theme/custom_text_style.dart';
import 'package:breeze/app/util/mouse_drag_scroll_behavior.dart';
import 'package:breeze/data/formatters/date_formatter.dart';
import 'package:breeze/data/model/hourly_weather_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HourlyWeatherWidget extends StatelessWidget {
  final HourlyWeatherInfo? hourlyWeather;
  
  const HourlyWeatherWidget({
    super.key,
    required this.hourlyWeather
  });

  @override
  Widget build(BuildContext context) {
    final weatherPoints = hourlyWeather?.points ?? <HourlyPoint>[];
    final itemCount = weatherPoints.length;

    return Card(
      color: const Color.fromARGB(255, 39, 128, 200),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Погодные условия",
              style: CustomTextStyle.titleMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: itemCount == 0
                  ? const Center(child: Text('Нет данных'))
                  : ScrollConfiguration(
                    behavior: MouseDragScrollBehavior(),
                    child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: itemCount,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final weatherInfo = weatherPoints[index];
                          final weatherType = WeatherType.fromWmo(weatherInfo.weatherCode ?? 0);
                          
                          return SizedBox(
                            width: 90,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormatter.formatHour(weatherInfo.time.toString()),
                                  style: CustomTextStyle.body,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                SvgPicture.asset(
                                  weatherType.iconAsset,
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  weatherInfo.temperature2m != null ? '${weatherInfo.temperature2m} °C' : '-',
                                  style: CustomTextStyle.body,
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