import 'package:breeze/app/service_provider.dart';
import 'package:breeze/app/weather_api_service.dart';
import 'package:breeze/domain/weather_repository.dart';
import 'package:breeze/presentation/weather_screen.dart';
import 'package:flutter/material.dart';

void main() {
  final weatherApiService = WeatherApiService(baseUrl: 'http://127.0.0.1:8000');
  final weatherRepository = WeatherRepository(weatherApiService: weatherApiService);
  runApp(MyApp(weatherRepository: weatherRepository));
}
 
class MyApp extends StatelessWidget {
  final WeatherRepository weatherRepository;
  const MyApp({super.key, required this.weatherRepository});
 
  @override
  Widget build(BuildContext context) {
    return ServiceProvider(
      weatherRepository: weatherRepository,
      child: MaterialApp(
        title: 'Breeze',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          fontFamily: 'SF-Pro-Display',
        ),
        home: const WeatherScreen(),
      ),
    );
  }
}
