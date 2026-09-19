import 'package:breeze/app/constants/weather_type.dart';
import 'package:breeze/app/theme/custom_text_style.dart';
import 'package:breeze/presentation/weather_controller.dart';
import 'package:breeze/presentation/weather_state.dart';
import 'package:breeze/presentation/widgets/daily_weather_widget.dart';
import 'package:breeze/presentation/widgets/hourly_weather_widget.dart';
import 'package:breeze/presentation/widgets/weather_info_cards_widget.dart';
import 'package:flutter/material.dart';

class WeatherInfoPanelWidget extends StatelessWidget {
  final WeatherController weatherController;
  final ScrollController scrollController;
  final EdgeInsets padding;

  final Widget? topBar;

  const WeatherInfoPanelWidget({
    super.key,
    required this.weatherController,
    required this.scrollController,
    this.padding = const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
    this.topBar,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<WeatherState>(
      valueListenable: weatherController.weatherState,
      builder: (context, weatherState, child) {
        final body = switch (weatherState.status) {
          WeatherStatus.initial => _buildInitial(),
          WeatherStatus.loading => const Center(child: CircularProgressIndicator()),
          WeatherStatus.error => Center(
              child: SelectableText('Ошибка: ${weatherState.errorMessage}'),
            ),
          WeatherStatus.loaded => _buildLoaded(weatherState),
        };
        return SafeArea(
          child: topBar == null ? body : Stack(children: [body, topBar!]),
        );
      },
    );
  }

  Widget _buildInitial() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search, size: 80, color: Colors.white),
          Text(
            "Погода",
            style: CustomTextStyle.titleRegular,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            "Выберите локацию для получения информации о погоде",
            style: CustomTextStyle.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoaded(WeatherState weatherState) {
    final temp = weatherState.currentWeather?.temperature2m;
    final maxTemp = weatherState.dailyWeather?.points[0].temperature2mMax ?? "-";
    final minTemp = weatherState.dailyWeather?.points[0].temperature2mMin ?? "-";
    final weatherType = WeatherType.fromWmo(weatherState.currentWeather?.weatherCode ?? 0);

    return Padding(
      padding: padding,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: topBar != null ? 56 : 40),
                Text(
                  weatherState.cityLabel ?? "Нет данных",
                  style: CustomTextStyle.titleRegular,
                  textAlign: TextAlign.center,
                ),
                Text(
                  temp != null ? '$temp°C' : 'Нет данных',
                  style: CustomTextStyle.titleRegular.copyWith(fontSize: 60),
                ),
                Text(
                  weatherType.weatherDesc,
                  style: CustomTextStyle.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Макс.: $maxTemp°C, мин.: $minTemp°C",
                  style: CustomTextStyle.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: HourlyWeatherWidget(hourlyWeather: weatherState.hourlyWeather),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: WeatherInfoCardsWidget(currentWeatherInfo: weatherState.currentWeather),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          SliverToBoxAdapter(
            child: DailyWeatherWidget(dailyWeather: weatherState.dailyWeather),
          ),
        ],
      ),
    );
  }
}
