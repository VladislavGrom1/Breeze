import 'package:breeze/domain/weather_repository.dart';
import 'package:flutter/material.dart';

class ServiceProvider extends InheritedWidget {
  final WeatherRepository weatherRepository;
 
  const ServiceProvider({
    super.key,
    required this.weatherRepository,
    required super.child,
  });
 
  static WeatherRepository of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ServiceProvider>();
    assert(provider != null, 'ServiceProvider не найден выше по дереву виджетов');
    return provider!.weatherRepository;
  }
 
  @override
  bool updateShouldNotify(ServiceProvider oldWidget) {
    return weatherRepository != oldWidget.weatherRepository;
  }
}