import 'package:flutter/foundation.dart';

@immutable
class RejectOrderData {
  final int? rideId;
  final String? status;
  final String? reason;

  const RejectOrderData({
    this.rideId,
    this.status,
    this.reason,
  });

  factory RejectOrderData.fromMap(Map<String, dynamic> json) => RejectOrderData(
      rideId: json['ride_id'] as int?,
      status: json['status'] as String?,
      reason: json['reason'] as String?,
    );

  Map<String, dynamic> toMap() => {
    'ride_id': rideId,
    'status': status,
    'reason': reason,
  };
}
