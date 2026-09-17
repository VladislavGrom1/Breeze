import 'package:breeze/data/geocode_result.dart';
import 'package:breeze/data/weather_location.dart';
import 'package:breeze/domain/weather_repository.dart';
import 'package:breeze/presentation/city_search_state.dart';
import 'package:breeze/presentation/weather_state.dart';
import 'package:flutter/material.dart';

class WeatherController {
  final WeatherRepository _weatherRepository;
 
  final ValueNotifier<CitySearchState> searchState = ValueNotifier(const CitySearchState());
  final ValueNotifier<WeatherState> weatherState = ValueNotifier(const WeatherState());
 
  WeatherController(this._weatherRepository);
 
  Future<void> searchCities(String name) async {
    final query = name.trim();
    if (query.isEmpty) {
      searchState.value = const CitySearchState();
      return;
    }
    searchState.value = searchState.value.copyWith(status: CitySearchStatus.loading);
    try {
      final results = await _weatherRepository.getLocations(query);
      searchState.value = CitySearchState(status: CitySearchStatus.loaded, searchResults: results);
    } catch (e) {
      searchState.value = CitySearchState(status: CitySearchStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> getSavedLocations() async {
    try{
      final results = await _weatherRepository.getSavedLocations();
      searchState.value = CitySearchState(status: CitySearchStatus.loaded, savedLocations: results);
    } catch(e){
      searchState.value = CitySearchState(status: CitySearchStatus.error, errorMessage: e.toString());
    }
  }

 
  Future<void> selectCity(GeocodeResult city) async {
    weatherState.value = weatherState.value.copyWith(status: WeatherStatus.loading);
    try {
      final location = await _weatherRepository.createLocation(city.name, city.latitude, city.longitude);
      await getWeather(location);
    } catch (e) {
      weatherState.value = WeatherState(status: WeatherStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> getWeather(WeatherLocation location) async {
    weatherState.value = weatherState.value.copyWith(status: WeatherStatus.loading);
    try{
      final current = await _weatherRepository.getCurrentWeather(location.locationId);
      final hourly = await _weatherRepository.getHourlyWeather(location.locationId);
      final daily = await _weatherRepository.getDailyWeather(location.locationId);
      weatherState.value = WeatherState(
        status: WeatherStatus.loaded,
        currentWeather: current,
        hourlyWeather: hourly["hourly"],
        dailyWeather: daily["daily"],
        cityLabel: location.label,
      );
    } catch(e) {
      weatherState.value = WeatherState(status: WeatherStatus.error, errorMessage: e.toString());
    }
  }

  Future<void> deleteSavedLocation(WeatherLocation location) async {
    try{
      await _weatherRepository.deleteSavedLocation(location.locationId);
      final currentSavedLocations = searchState.value.savedLocations;
      currentSavedLocations.removeWhere((item) => item.locationId == location.locationId);
      searchState.value = CitySearchState(status: CitySearchStatus.loaded, savedLocations: currentSavedLocations);
    } catch(e){
      searchState.value = CitySearchState(status: CitySearchStatus.error, errorMessage: e.toString());
    }
  }
 
  void reset() {
    weatherState.value = const WeatherState();
  }
 
  void dispose() {
    searchState.dispose();
    weatherState.dispose();
  }
}