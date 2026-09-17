import 'dart:async';
import 'package:breeze/app/service_provider.dart';
import 'package:breeze/app/theme/custom_text_style.dart';
import 'package:breeze/presentation/city_search_state.dart';
import 'package:breeze/presentation/weather_controller.dart';
import 'package:breeze/presentation/weather_state.dart';
import 'package:breeze/presentation/widgets/daily_weather_widget.dart';
import 'package:breeze/presentation/widgets/hourly_weather_widget.dart';
import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late final WeatherController _controller;
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
      _controller = WeatherController(repository);
      _initialized = true;
      _controller.getSavedLocations();
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    if (value.isEmpty) {
      _controller.getSavedLocations();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 200), () {
      _controller.searchCities(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _searchController.dispose();
    _searchScrollController.dispose();
    _weatherScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(221, 119, 178, 225),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchLocationsWidget(),
          _buildLocationWeatherInfoWidget(),
        ],
      ),
    );
  }

  Widget _buildSearchLocationsWidget() {
    return Expanded(
      flex: 1,
      child: Material(
        color: const Color.fromARGB(255, 25, 41, 61),
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
                    style: CustomTextStyle.body.copyWith(
                      fontSize: 20,
                      color: Colors.grey
                    ),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
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
                style: CustomTextStyle.body,
                textInputAction: TextInputAction.search,
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ValueListenableBuilder<CitySearchState>(
                  valueListenable: _controller.searchState,
                  builder: (context, searchState, _) {
                    switch (searchState.status) {
                      case CitySearchStatus.initial:
                        return Center(
                          child: Column(
                            children: [
                              Text(
                                "Нет сохранённых локаций",
                                style: CustomTextStyle.titleRegular,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Введите название локации в поиске",
                                style: CustomTextStyle.body,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        );
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
                                Text(
                                  hasQuery ? "Локации не найдены" : "Нет сохранённых локаций",
                                  style: CustomTextStyle.titleRegular,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  hasQuery ? "Измените запрос" : "Введите название локации в поиске",
                                  style: CustomTextStyle.body,
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
                                        title: Text(city.name, style: CustomTextStyle.body),
                                        subtitle: city.country != null
                                            ? Text(
                                                city.country!, 
                                                style: CustomTextStyle.body.copyWith(fontSize: 12, color: Colors.grey),
                                              )
                                            : null,
                                        trailing: const Icon(Icons.chevron_right, color: Colors.white),
                                        onTap: () => _controller.selectCity(city),
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
                                          onPressed: () async => _controller.deleteSavedLocation(location),
                                        ),
                                        onTap: () async => _controller.getWeather(location),
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
      child: Padding(
        padding: const EdgeInsets.only(
          left: 40,
          right: 40,
          top: 20,
          bottom: 20,
        ),
        child: ValueListenableBuilder<WeatherState>(
          valueListenable: _controller.weatherState,
          builder: (context, weatherState, child) {
            switch (weatherState.status) {
              case WeatherStatus.initial:
                return const SizedBox.shrink();
              case WeatherStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case WeatherStatus.error:
                return Center(
                  child: SelectableText('Ошибка: ${weatherState.errorMessage}'),
                );
              case WeatherStatus.loaded:
                final temp = weatherState.currentWeather?.temperature2m;
                return Scrollbar(
                  controller: _weatherScrollController,
                  thumbVisibility: true,
                  child: CustomScrollView(
                    controller: _weatherScrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              weatherState.cityLabel ?? "Нет данных",
                              style: CustomTextStyle.titleRegular,
                            ),
                            Text(
                              temp != null ? '$temp°C' : 'Нет данных',
                              style: CustomTextStyle.titleRegular.copyWith(fontSize: 50),
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
                        child: DailyWeatherWidget(dailyWeather: weatherState.dailyWeather)
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
