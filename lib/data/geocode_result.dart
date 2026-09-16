class GeocodeResult {
  final String name;
  final double latitude;
  final double longitude;
  final String? country;
 
  GeocodeResult({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.country,
  });
 
  factory GeocodeResult.fromJson(Map<String, dynamic> json) {
    return GeocodeResult(
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      country: json['country'] as String?,
    );
  }
}