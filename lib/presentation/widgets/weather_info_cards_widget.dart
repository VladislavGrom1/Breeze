import 'package:breeze/data/model/current_weather_info.dart';
import 'package:breeze/presentation/widgets/apparent_weather_widget.dart';
import 'package:breeze/presentation/widgets/humidity_weather_widget.dart';
import 'package:breeze/presentation/widgets/pressure_weather_widget.dart';
import 'package:breeze/presentation/widgets/wind_weather_widget.dart';
import 'package:flutter/material.dart';

const double _minCardWidth = 180;
const double _cardSpacing = 10;
 
class WeatherInfoCardsWidget extends StatelessWidget {
  final CurrentWeatherInfo? currentWeatherInfo;
 
  const WeatherInfoCardsWidget({super.key, required this.currentWeatherInfo});
 
  @override
  Widget build(BuildContext context) {
    final cards = [
      WindWeatherWidget(currentWeatherInfo: currentWeatherInfo),
      ApparentWeatherWidget(currentWeatherInfo: currentWeatherInfo),
      PressureWeatherWidget(currentWeatherInfo: currentWeatherInfo),
      HumidityWeatherWidget(currentWeatherInfo: currentWeatherInfo),
    ];
 
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _columnsFor(constraints.maxWidth, cards.length);
 
        if (columns >= cards.length) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final card in cards) ...[
                  Expanded(child: card),
                  if (card != cards.last) const SizedBox(width: _cardSpacing),
                ],
              ],
            ),
          );
        }

        final cardWidth = (constraints.maxWidth - (columns - 1) * _cardSpacing) / columns;
 
        return Wrap(
          spacing: _cardSpacing,
          runSpacing: _cardSpacing,
          children: [
            for (final card in cards) SizedBox(width: cardWidth, child: card),
          ],
        );
      },
    );
  }
 
  int _columnsFor(double availableWidth, int cardCount) {
    for (var columns = cardCount; columns >= 1; columns--) {
      final requiredWidth = columns * _minCardWidth + (columns - 1) * _cardSpacing;
      if (availableWidth >= requiredWidth) return columns;
    }
    return 1;
  }
}
