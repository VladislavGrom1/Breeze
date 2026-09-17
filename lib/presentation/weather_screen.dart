import 'dart:async';
import 'package:breeze/app/service_provider.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(
          'Beezer',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 217, 215, 215),
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
      child: Padding(
        padding: const EdgeInsets.only(
          left: 40,
          right: 40,
          top: 20,
          bottom: 20,
        ),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Название города',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
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
                      return const SizedBox.shrink();
                    case CitySearchStatus.loading:
                      return const Center(child: CircularProgressIndicator());
                    case CitySearchStatus.error:
                      return Center(
                        child: SelectableText('Ошибка: ${searchState.errorMessage}'),
                      );
                    case CitySearchStatus.loaded:
                      return Scrollbar(
                        controller: _searchScrollController,
                        thumbVisibility: true,
                        child: CustomScrollView(
                          controller: _searchScrollController,
                          slivers: [
                            if (searchState.searchResults.isEmpty)
                              SliverList.separated(
                                itemCount: searchState.savedLocations.length,
                                separatorBuilder: (_, _) => const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final location =
                                      searchState.savedLocations[index];
                                  return Material(
                                    color: Colors.grey,
                                    child: ListTile(
                                      title: Text(
                                        location.label ?? "Имя отсутствует",
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Ш:${location.latitude} Д:${location.longitude}",
                                          ),
                                          Text(location.timezone ?? "-"),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          await _controller
                                              .deleteSavedLocation(location);
                                        },
                                      ),
                                      onTap: () async {
                                        await _controller.getWeather(
                                          location,
                                        );
                                      },
                                    ),
                                  );
                                },
                              )
                            else
                              SliverList.separated(
                                itemCount: searchState.searchResults.length,
                                separatorBuilder: (_, _) => const SizedBox(height: 1),
                                itemBuilder: (context, index) {
                                  final city =
                                      searchState.searchResults[index];
                                  return ListTile(
                                    title: Text(city.name),
                                    subtitle: city.country != null
                                        ? Text(city.country!)
                                        : null,
                                    trailing: const Icon(
                                      Icons.chevron_right,
                                    ),
                                    onTap: () => _controller.selectCity(city),
                                  );
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
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              temp != null ? '$temp°C' : 'Нет данных',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(child: HourlyWeatherWidget(hourlyWeather: weatherState.hourlyWeather)),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      SliverToBoxAdapter(child: DailyWeatherWidget(dailyWeather: weatherState.dailyWeather)),
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
