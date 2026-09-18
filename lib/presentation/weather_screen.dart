import 'dart:async';
import 'package:breeze/app/constants/weather_type.dart';
import 'package:breeze/app/service_provider.dart';
import 'package:breeze/app/theme/custom_text_style.dart';
import 'package:breeze/presentation/city_search_state.dart';
import 'package:breeze/presentation/weather_controller.dart';
import 'package:breeze/presentation/weather_state.dart';
import 'package:breeze/presentation/widgets/apparent_weather_widget.dart';
import 'package:breeze/presentation/widgets/daily_weather_widget.dart';
import 'package:breeze/presentation/widgets/hourly_weather_widget.dart';
import 'package:breeze/presentation/widgets/humidity_weather_widget.dart';
import 'package:breeze/presentation/widgets/pressure_weather_widget.dart';
import 'package:breeze/presentation/widgets/wind_weather_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> with TickerProviderStateMixin{
  late final WeatherController _weatherController;
  late final AnimationController _animationController;
  final _searchController = TextEditingController();
  final _searchScrollController = ScrollController();
  final _weatherScrollController = ScrollController();
  bool _initialized = false;
  Timer? _debounce;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final repository = ServiceProvider.of(context);
      _weatherController = WeatherController(repository);
      _animationController = AnimationController(vsync: this);
      _initialized = true;
      _weatherController.getSavedLocations();
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    if (value.isEmpty) {
      _weatherController.getSavedLocations();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 200), () {
      _weatherController.searchCities(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _weatherController.dispose();
    _searchController.dispose();
    _searchScrollController.dispose();
    _weatherScrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 119, 178, 225),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: Lottie.asset(
                  'assets/animations/sunrise.json',
                  controller: _animationController,
                  onLoaded: (composition) {
                    _animationController
                      ..duration = composition.duration
                      ..repeat(period: composition.duration * 1.5);
                  },
                  fit: BoxFit.contain
                ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchLocationsWidget(),
              _buildLocationWeatherInfoWidget(),
            ],
          ),
        ] 
      ),
    );
  }

  Widget _buildSearchLocationsWidget() {
    return Expanded(
      flex: 1,
      child: Material(
        color: const Color.fromARGB(255, 25, 41, 61).withValues(alpha: 0.5),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 20,
          ),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color.fromARGB(255, 51, 63, 70),
                  label: Text(
                    "Поиск",
                    style: CustomTextStyle.titleMedium.copyWith(
                      fontSize: 20,
                      color: Colors.grey
                    ),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController, 
                    builder: (context, value, _) {
                      if(_searchController.text.isEmpty){
                        return SizedBox.shrink();
                      }
                      return IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        }, 
                      );
                    },
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 20
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                style: CustomTextStyle.titleMedium,
                textInputAction: TextInputAction.search,
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ValueListenableBuilder<CitySearchState>(
                  valueListenable: _weatherController.searchState,
                  builder: (context, searchState, _) {
                    switch (searchState.status) {
                      case CitySearchStatus.initial:
                        return SizedBox.shrink();
                      case CitySearchStatus.loading:
                        return const Center(child: CircularProgressIndicator());
                      case CitySearchStatus.error:
                        return Center(
                          child: SelectableText('Ошибка: ${searchState.errorMessage}'),
                        );
                      case CitySearchStatus.loaded:
                        final query = _searchController.text.trim();
                        final hasQuery = query.isNotEmpty;
                        final items = hasQuery ? searchState.searchResults : searchState.savedLocations;

                        if (items.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  hasQuery ? Icons.not_listed_location : Icons.location_off,
                                  size: 80,
                                  color: Colors.white,
                                ),
                                Text(
                                  hasQuery ? "Локации не найдены" : "Нет сохранённых локаций",
                                  style: CustomTextStyle.titleRegular,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  hasQuery ? "Измените запрос" : "Введите название локации в поиске",
                                  style: CustomTextStyle.titleMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }

                        return Scrollbar(
                          controller: _searchScrollController,
                          thumbVisibility: true,
                          child: CustomScrollView(
                            controller: _searchScrollController,
                            slivers: [
                              SliverList.separated(
                                itemCount: items.length,
                                separatorBuilder: (_, _) => const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  if (hasQuery) {
                                    final city = searchState.searchResults[index];
                                    return Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      clipBehavior: Clip.antiAlias,
                                      child: ListTile(
                                        title: Text(city.name, style: CustomTextStyle.titleMedium),
                                        subtitle: city.country != null
                                            ? Text(
                                                city.country!, 
                                                style: CustomTextStyle.titleMedium.copyWith(fontSize: 12, color: Colors.white),
                                              )
                                            : null,
                                        trailing: const Icon(Icons.chevron_right, color: Colors.white),
                                        onTap: () => _weatherController.selectCity(city),
                                      ),
                                    );
                                  } else {
                                    final location = searchState.savedLocations[index];
                                    return Material(
                                      color: Colors.transparent,
                                      child: ListTile(
                                        tileColor: const Color.fromARGB(255, 51, 63, 70),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        title: Text(
                                          location.label ?? "Имя отсутствует",
                                          style: CustomTextStyle.titleBold.copyWith(fontSize: 20),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Ш:${location.latitude} Д:${location.longitude}", style: CustomTextStyle.subtitle),
                                            const SizedBox(height: 20),
                                            Text(location.timezone ?? "-", style: CustomTextStyle.subtitle),
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () async => _weatherController.deleteSavedLocation(location),
                                        ),
                                        onTap: () async => _weatherController.getWeather(location),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationWeatherInfoWidget() {
    return Expanded(
      flex: 2,
      child: ValueListenableBuilder<WeatherState>(
          valueListenable: _weatherController.weatherState,
          builder: (context, weatherState, child) {
            switch (weatherState.status) {
              case WeatherStatus.initial:
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 80,
                        color: Colors.white,
                      ),
                      Text(
                        "Погода",
                        style: CustomTextStyle.titleRegular,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Выберите локацию для получения информации о погоде",
                        style: CustomTextStyle.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ]
                  ),
                );
              case WeatherStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case WeatherStatus.error:
                return Center(
                  child: SelectableText('Ошибка: ${weatherState.errorMessage}'),
                );
              case WeatherStatus.loaded:
                final temp = weatherState.currentWeather?.temperature2m;
                final maxTemp = weatherState.dailyWeather?.points[0].temperature2mMax ?? "-";
                final minTemp = weatherState.dailyWeather?.points[0].temperature2mMin ?? "-";
                final weatherType = WeatherType.fromWmo(weatherState.currentWeather?.weatherCode ?? 0);
                return Padding(
                      padding: const EdgeInsets.only(
                        left: 40,
                        right: 40,
                        top: 20,
                        bottom: 20,
                      ),
                      child: CustomScrollView(
                        controller: _weatherScrollController,
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 40),
                                Text(
                                  weatherState.cityLabel ?? "Нет данных",
                                  style: CustomTextStyle.titleRegular,
                                ),
                                Text(
                                  temp != null ? '$temp°C' : 'Нет данных',
                                  style: CustomTextStyle.titleRegular.copyWith(fontSize: 60),
                                ),
                                Text(
                                  weatherType.weatherDesc,
                                  style: CustomTextStyle.titleMedium,
                                ),
                                Text(
                                  "Макс.: $maxTemp°C, мин.: $minTemp°C",
                                  style: CustomTextStyle.titleMedium,
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: HourlyWeatherWidget(hourlyWeather: weatherState.hourlyWeather)
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 20)
                          ),
                          SliverToBoxAdapter(
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  WindWeatherWidget(currentWeatherInfo: weatherState.currentWeather),
                                  SizedBox(width: 10),
                                  ApparentWeatherWidget(currentWeatherInfo: weatherState.currentWeather),
                                  SizedBox(width: 10),
                                  PressureWeatherWidget(currentWeatherInfo: weatherState.currentWeather),
                                  SizedBox(width: 10),
                                  HumidityWeatherWidget(currentWeatherInfo: weatherState.currentWeather)
                                ],
                              ),
                            )
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 20)
                          ),
                          SliverToBoxAdapter(
                            child: DailyWeatherWidget(dailyWeather: weatherState.dailyWeather)
                          ),
                        ],
                      ),
                );
            }
          },
        ),
    );
  }
}
