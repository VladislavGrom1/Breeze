import 'dart:async';
import 'package:breeze/app/service_provider.dart';
import 'package:breeze/presentation/city_search_state.dart';
import 'package:breeze/presentation/weather_controller.dart';
import 'package:breeze/presentation/weather_state.dart';
import 'package:flutter/material.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late final WeatherController _controller;
  final _searchController = TextEditingController();
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
                        child: Text('Ошибка: ${searchState.errorMessage}'),
                      );
                    case CitySearchStatus.loaded:
                      return CustomScrollView(
                        slivers: [
                          if (searchState.searchResults.isEmpty)
                            SliverList.separated(
                              itemCount: searchState.savedLocations.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Ш:${location.latitude} Д:${location.longitude}",
                                        ),
                                        Text(location.timezone ?? "-"),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        await _controller.deleteSavedLocation(location);
                                      } 
                                    ),
                                    onTap: () async {
                                      await _controller.getWeather(location);
                                    },
                                  ),
                                );
                              },
                            )
                          else
                            SliverList.separated(
                              itemCount: searchState.searchResults.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 1),
                              itemBuilder: (context, index) {
                                final city = searchState.searchResults[index];
                                return ListTile(
                                  title: Text(city.name),
                                  subtitle: city.country != null
                                      ? Text(city.country!)
                                      : null,
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () => _controller.selectCity(city),
                                );
                              },
                            ),
                        ],
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
        child: Column(
          children: [
            const Text("Погода"),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder<WeatherState>(
                valueListenable: _controller.weatherState,
                builder: (context, weather, child) {
                  switch (weather.status) {
                    case WeatherStatus.loading:
                      return const Center(child: CircularProgressIndicator());
                    case WeatherStatus.error:
                      return Center(
                        child: Text('Ошибка: ${weather.errorMessage}'),
                      );
                    case WeatherStatus.loaded:
                      final current =
                          weather.currentWeather?['current']
                              as Map<String, dynamic>?;
                      final temp = current?['temperature_2m'];
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (weather.cityLabel != null)
                              Text(
                                weather.cityLabel!,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            const SizedBox(height: 8),
                            Text(
                              temp != null ? '$temp°C' : 'Нет данных',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        ),
                      );
                    case WeatherStatus.initial:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
