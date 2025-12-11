class RideStatusMessage {
  final int? id;
  final String? status;
  final Map<String, dynamic>? user;
  final Map<String, dynamic>? driver;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final double? fare;
  final int? otp;
  final Map<String, dynamic>? data;

  RideStatusMessage({
    this.id,
    this.status,
    this.user,
    this.driver,
    this.pickupLatitude,
    this.pickupLongitude,
    this.destinationLatitude,
    this.destinationLongitude,
    this.fare,
    this.otp,
    this.data,
  });

  factory RideStatusMessage.fromJson(Map<String, dynamic> json) {
    return RideStatusMessage(
      id: json['id'] as int?,
      status: json['status'] as String?,
      user: json['user'] as Map<String, dynamic>?,
      driver: json['driver'] as Map<String, dynamic>?,
      pickupLatitude: json['pickupLatitude'] != null ? (json['pickupLatitude'] as num).toDouble() : null,
      pickupLongitude: json['pickupLongitude'] != null ? (json['pickupLongitude'] as num).toDouble() : null,
      destinationLatitude: json['destinationLatitude'] != null ? (json['destinationLatitude'] as num).toDouble() : null,
      destinationLongitude: json['destinationLongitude'] != null
          ? (json['destinationLongitude'] as num).toDouble()
          : null,
      fare: json['fare'] != null ? (json['fare'] as num).toDouble() : null,
      otp: json['otp'] as int?,
      data: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'user': user,
      'driver': driver,
      'pickupLatitude': pickupLatitude,
      'pickupLongitude': pickupLongitude,
      'destinationLatitude': destinationLatitude,
      'destinationLongitude': destinationLongitude,
      'fare': fare,
      'otp': otp,
    };
  }
}
