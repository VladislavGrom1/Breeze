import 'package:breeze/app/constants/current_field.dart';
import 'package:breeze/app/constants/daily_field.dart';
import 'package:breeze/app/constants/hourly_field.dart';
import 'package:breeze/app/http_client.dart';

class WeatherApiService {
  final HttpClient _client;
  final String baseUrl;
 
  WeatherApiService({required this.baseUrl, HttpClient? client}) : _client = client ?? HttpClient();
 
  Future<List<Map<String, dynamic>>> geocode(String name, {int count = 5}) async {
    final uri = Uri.parse('$baseUrl/v1/geocode').replace(
      queryParameters: {
        'name': name,
        'count': count.toString(),
      },
    );
    final data = await _client.getData(uri);
    final items = (data['items'] as List).cast<Map<String, dynamic>>();
    return items;
  }
 
  Future<Map<String, dynamic>> createLocation({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final uri = Uri.parse('$baseUrl/v1/locations');
    final data = await _client.postData(uri, body: {
      'latitude': latitude,
      'longitude': longitude,
      'label': ?label,
    });
    return data;
  }
 
  Future<List<Map<String, dynamic>>> getSavedLocations() async {
    final uri = Uri.parse('$baseUrl/v1/locations');
    final data = await _client.getData(uri);
    final items = (data['items'] as List).cast<Map<String, dynamic>>();
    return items;
  }
 
  Future<Map<String, dynamic>> getSavedLocation(String locationId) async {
    final uri = Uri.parse('$baseUrl/v1/locations/$locationId');
    final data = await _client.getData(uri);
    return data;
  }
 
  Future<void> deleteSavedLocation(String locationId) async {
    final uri = Uri.parse('$baseUrl/v1/locations/$locationId');
    await _client.deleteData(uri);
  }
 
  Future<Map<String, dynamic>> getCurrentWeather(
    String locationId, {
    List<String> fields = const [
      CurrentField.weatherCode,
      CurrentField.temperature2m, 
      CurrentField.apparentTemperature,
      CurrentField.relativeHumidity2m 
    ],
  }) async {
    final uri = Uri.parse('$baseUrl/v1/locations/$locationId/current').replace(
      queryParameters: {'fields': fields},
    );
    return _client.getData(uri);
  }
 
  Future<Map<String, dynamic>> getHourlyWeather(
    String locationId, {
    List<String> fields = const [
      HourlyField.weatherCode,
      HourlyField.temperature2m,
      HourlyField.apparentTemperature,
      HourlyField.relativeHumidity2m 
    ],
    int forecastDays = 1,
    int pastDays = 0,
    String? startDate,
    String? endDate,
  }) async {
    final uri = Uri.parse('$baseUrl/v1/locations/$locationId/hourly').replace(
      queryParameters: {
        'fields': fields,
        'forecast_days': forecastDays.toString(),
        'past_days': pastDays.toString(),
        'start_date': ?startDate,
        'end_date': ?endDate,
      },
    );
    return _client.getData(uri);
  }
 
  Future<Map<String, dynamic>> getDailyWeather(
    String locationId, {
    List<String> fields = const [
      DailyField.weatherCode,
      DailyField.temperature2mMean,
      DailyField.temperature2mMin,
      DailyField.temperature2mMax,       
    ],
    int forecastDays = 7,
  }) async {
    final uri = Uri.parse('$baseUrl/v1/locations/$locationId/daily').replace(
      queryParameters: {
        'fields': fields,
        'forecast_days': forecastDays.toString(),
      },
    );
    return _client.getData(uri);
  }
 
  void dispose() => _client.close();
}