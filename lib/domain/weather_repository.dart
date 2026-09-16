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
    return await weatherApiService.listLocations();
  }

  Future<WeatherLocation> createLocation(String name, double latitude, double longitude) async {
    return await weatherApiService.createLocation(
      label: name,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<Map<String, dynamic>> getCurrentWeather(String locationId) async {
    return await weatherApiService.getCurrent(locationId);
  }
 
  Future<void> deleteSavedLocation(String locationId) async {
    return await weatherApiService.deleteLocation(locationId);
  }  
}