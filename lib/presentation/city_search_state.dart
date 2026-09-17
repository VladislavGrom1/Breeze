import 'package:breeze/data/model/geocode_result.dart';
import 'package:breeze/data/model/weather_location.dart';
import 'package:flutter/material.dart';

enum CitySearchStatus { initial, loading, loaded, error }
 
@immutable
class CitySearchState {
  final CitySearchStatus status;
  final List<GeocodeResult> searchResults;
  final List<WeatherLocation> savedLocations;
  final String? errorMessage;
 
  const CitySearchState({
    this.status = CitySearchStatus.initial,
    this.searchResults = const [],
    this.savedLocations = const [],
    this.errorMessage,
  });
 
  CitySearchState copyWith({
    CitySearchStatus? status,
    List<GeocodeResult>? searchResults,
    List<WeatherLocation>? savedLocations,
    String? errorMessage,
  }) {
    return CitySearchState(
      status: status ?? this.status,
      searchResults: searchResults ?? this.searchResults,
      savedLocations: savedLocations ?? this.savedLocations,
      errorMessage: errorMessage,
    );
  }
}