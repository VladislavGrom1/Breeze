import 'package:flutter/material.dart';

enum WeatherStatus { initial, loading, loaded, error }
 
@immutable
class WeatherState {
  final WeatherStatus status;
  final Map<String, dynamic>? currentWeather;
  final String? cityLabel;
  final String? errorMessage;
 
  const WeatherState({
    this.status = WeatherStatus.initial,
    this.currentWeather,
    this.cityLabel,
    this.errorMessage,
  });
 
  WeatherState copyWith({
    WeatherStatus? status,
    Map<String, dynamic>? currentWeather,
    String? cityLabel,
    String? errorMessage,
  }) {
    return WeatherState(
      status: status ?? this.status,
      currentWeather: currentWeather ?? this.currentWeather,
      cityLabel: cityLabel ?? this.cityLabel,
      errorMessage: errorMessage,
    );
  }
}