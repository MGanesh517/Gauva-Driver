class LocationMessage {
  final double lat;
  final double lng;
  final String timestamp;

  LocationMessage({required this.lat, required this.lng, required this.timestamp});

  factory LocationMessage.fromJson(Map<String, dynamic> json) {
    return LocationMessage(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      timestamp: json['timestamp'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng, 'timestamp': timestamp};
  }
}
