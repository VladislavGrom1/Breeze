import 'package:flutter/material.dart';

enum WeatherStatus { initial, loading, loaded, error }
 
@immutable
class WeatherState {
  final WeatherStatus status;
  final Map<String, dynamic>? currentWeather;
  final Map<String, dynamic>? hourlyWeather;
  final Map<String, dynamic>? dailyWeather;
  final String? cityLabel;
  final String? errorMessage;
 
  const WeatherState({
    this.status = WeatherStatus.initial,
    this.currentWeather,
    this.hourlyWeather,
    this.dailyWeather,
    this.cityLabel,
    this.errorMessage,
  });
 
  WeatherState copyWith({
    WeatherStatus? status,
    Map<String, dynamic>? currentWeather,
    Map<String, dynamic>? hourlyWeather,
    Map<String, dynamic>? dailyWeather,
    String? cityLabel,
    String? errorMessage,
  }) {
    return WeatherState(
      status: status ?? this.status,
      currentWeather: currentWeather ?? this.currentWeather,
      hourlyWeather: hourlyWeather ?? this.hourlyWeather,
      dailyWeather: dailyWeather ?? this.dailyWeather,
      cityLabel: cityLabel ?? this.cityLabel,
      errorMessage: errorMessage,
    );
  }
}