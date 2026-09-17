import 'package:breeze/data/model/current_weather_info.dart';
import 'package:breeze/data/model/daily_weather_info.dart';
import 'package:breeze/data/model/geocode_result.dart';
import 'package:breeze/data/model/hourly_weather_info.dart';
import 'package:breeze/data/model/weather_location.dart';
import 'package:breeze/app/weather_api_service.dart';

class WeatherRepository {
  final WeatherApiService weatherApiService;
 
  WeatherRepository({required this.weatherApiService});
 
  Future<List<GeocodeResult>> getLocations(String name) async {
    final List<Map<String, dynamic>> items = await weatherApiService.geocode(name);
    return items.map((e) => GeocodeResult.fromJson(e)).toList();
  }
  

  Future<List<WeatherLocation>> getSavedLocations() async {
    final List<Map<String, dynamic>> items = await weatherApiService.getSavedLocations();
    return items.map((e) => WeatherLocation.fromJson(e)).toList();
  }

  Future<WeatherLocation> createLocation(String name, double latitude, double longitude) async {
    final Map<String, dynamic> result = await weatherApiService.createLocation(label: name, latitude: latitude, longitude: longitude);
    return WeatherLocation.fromJson(result);
  }

  Future<CurrentWeatherInfo> getCurrentWeather(String locationId) async {
    final Map<String, dynamic> result = await weatherApiService.getCurrentWeather(locationId);
    return CurrentWeatherInfo.fromJson(result['current']);
  }

  Future<DailyWeatherInfo> getDailyWeather(String locationId) async {
    final Map<String, dynamic> result = await weatherApiService.getDailyWeather(locationId);
    return DailyWeatherInfo.fromJson(result['daily']);
  }

  Future<HourlyWeatherInfo> getHourlyWeather(String locationId) async {
    final Map<String, dynamic> result = await weatherApiService.getHourlyWeather(locationId);
    return HourlyWeatherInfo.fromJson(result['hourly']);
  }
 
  Future<void> deleteSavedLocation(String locationId) async {
    return await weatherApiService.deleteSavedLocation(locationId);
  }  
}