class WeatherLocation {
  final String locationId;
  final double latitude;
  final double longitude;
  final double? elevation;
  final String? timezone;
  final String? label;
 
  WeatherLocation({
    required this.locationId,
    required this.latitude,
    required this.longitude,
    this.elevation,
    this.timezone,
    this.label,
  });
 
  factory WeatherLocation.fromJson(Map<String, dynamic> json) {
    return WeatherLocation(
      locationId: json['location_id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      elevation: (json['elevation'] as num?)?.toDouble(),
      timezone: json['timezone'] as String?,
      label: json['label'] as String?,
    );
  }
}