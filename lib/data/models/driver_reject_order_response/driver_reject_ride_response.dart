import 'package:flutter/foundation.dart';
import 'data.dart';

@immutable
class DriverRejectRideResponse {
  final bool? success;
  final String? message;
  final RejectOrderData? data;

  const DriverRejectRideResponse({this.success, this.message, this.data});

  factory DriverRejectRideResponse.fromMap(Map<String, dynamic> json) => DriverRejectRideResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : RejectOrderData.fromMap(json['data'] as Map<String, dynamic>),
    );

  Map<String, dynamic> toMap() => {
    'success': success,
    'message': message,
    'data': data?.toMap(),
  };
}
