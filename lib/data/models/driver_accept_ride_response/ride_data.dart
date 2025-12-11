import 'package:flutter/foundation.dart';

@immutable
class RideData {
  final int? rideId;
  final String? status;
  final String? pickupLocation;
  final String? dropoffLocation;

  const RideData({
    this.rideId,
    this.status,
    this.pickupLocation,
    this.dropoffLocation,
  });

  factory RideData.fromMap(Map<String, dynamic> json) => RideData(
      rideId: json['ride_id'] as int?,
      status: json['status'] as String?,
      pickupLocation: json['pickup_location'] as String?,
      dropoffLocation: json['dropoff_location'] as String?,
    );

  Map<String, dynamic> toMap() => {
    'ride_id': rideId,
    'status': status,
    'pickup_location': pickupLocation,
    'dropoff_location': dropoffLocation,
  };
}
