import 'package:breeze/app/constants/current_field.dart';
import 'package:breeze/app/constants/daily_field.dart';
import 'package:breeze/app/constants/hourly_field.dart';
import 'package:breeze/app/http_client.dart';
import 'package:breeze/data/geocode_result.dart';
import 'package:breeze/data/weather_location.dart';

class WeatherApiService {
  final HttpClient _client;
  final String baseUrl;
 
  WeatherApiService({required this.baseUrl, HttpClient? client})
      : _client = client ?? HttpClient();
 
 
  Future<List<GeocodeResult>> geocode(String name, {int count = 5}) async {
    final uri = Uri.parse('$baseUrl/v1/geocode').replace(
      queryParameters: {
        'name': name,
        'count': count.toString(),
      },
    );
    final data = await _client.getData(uri);
    final items = data['items'] as List<dynamic>;
    return items.map((e) => GeocodeResult.fromJson(e as Map<String, dynamic>)).toList();
  }
 
  Future<WeatherLocation> createLocation({
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
    return WeatherLocation.fromJson(data);
  }
 
  Future<List<WeatherLocation>> listLocations() async {
    final uri = Uri.parse('$baseUrl/v1/locations');
    final data = await _client.getData(uri);
    final items = data['items'] as List<dynamic>;
    return items.map((e) => WeatherLocation.fromJson(e as Map<String, dynamic>)).toList();
  }
 
  Future<WeatherLocation> getLocation(String locationId) async {
    final uri = Uri.parse('$baseUrl/v1/locations/$locationId');
    final data = await _client.getData(uri);
    return WeatherLocation.fromJson(data);
  }
 
  Future<void> deleteLocation(String locationId) async {
    final uri = Uri.parse('$baseUrl/v1/locations/$locationId');
    await _client.deleteData(uri);
  }
 
  Future<Map<String, dynamic>> getCurrent(
    String locationId, {
    List<String> fields = const [CurrentField.temperature2m, CurrentField.weatherCode],
  }) async {
    final uri = Uri.parse('$baseUrl/v1/locations/$locationId/current').replace(
      queryParameters: {'fields': fields},
    );
    return _client.getData(uri);
  }
 
  Future<Map<String, dynamic>> getHourly(
    String locationId, {
    List<String> fields = const [HourlyField.temperature2m, HourlyField.weatherCode],
    int forecastDays = 7,
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
 
  Future<Map<String, dynamic>> getDaily(
    String locationId, {
    List<String> fields = const [DailyField.temperature2mMax, DailyField.temperature2mMin, DailyField.weatherCode],
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