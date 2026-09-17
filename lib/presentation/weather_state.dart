import 'package:breeze/data/model/current_weather_info.dart';
import 'package:breeze/data/model/daily_weather_info.dart';
import 'package:breeze/data/model/hourly_weather_info.dart';
import 'package:flutter/material.dart';

enum WeatherStatus { initial, loading, loaded, error }
 
@immutable
class WeatherState {
  final WeatherStatus status;
  final CurrentWeatherInfo? currentWeather;
  final HourlyWeatherInfo? hourlyWeather;
  final DailyWeatherInfo? dailyWeather;
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
    CurrentWeatherInfo? currentWeather,
    HourlyWeatherInfo? hourlyWeather,
    DailyWeatherInfo? dailyWeather,
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