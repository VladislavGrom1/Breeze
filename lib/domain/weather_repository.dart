import 'package:breeze/data/geocode_result.dart';
import 'package:breeze/data/weather_location.dart';
import 'package:breeze/app/weather_api_service.dart';

class WeatherRepository {
  final WeatherApiService weatherApiService;
 
  WeatherRepository({required this.weatherApiService});
 
  Future<List<GeocodeResult>> getLocations(String name) async {
    return await weatherApiService.geocode(name);
  }
  

  Future<List<WeatherLocation>> getSavedLocations() async {
    return await weatherApiService.getSavedLocations();
  }

  Future<WeatherLocation> createLocation(String name, double latitude, double longitude) async {
    return await weatherApiService.createLocation(
      label: name,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<Map<String, dynamic>> getCurrentWeather(String locationId) async {
    return await weatherApiService.getCurrentWeather(locationId);
  }

  Future<Map<String, dynamic>> getDailyWeather(String locationId) async {
    return await weatherApiService.getDailyWeather(locationId);
  }

  Future<Map<String, dynamic>> getHourlyWeather(String locationId) async {
    return await weatherApiService.getHourlyWeather(locationId);
  }
 
  Future<void> deleteSavedLocation(String locationId) async {
    return await weatherApiService.deleteSavedLocation(locationId);
  }  
}