import 'package:flutter/foundation.dart';

import 'data.dart';

@immutable
class DriverRadiusUpdateResponse {
  final bool? success;
  final String? message;
  final Data? data;

  const DriverRadiusUpdateResponse({this.success, this.message, this.data});

  factory DriverRadiusUpdateResponse.fromMap(Map<String, dynamic> json) => DriverRadiusUpdateResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromMap(json['data'] as Map<String, dynamic>),
    );

  Map<String, dynamic> toMap() => {
        'success': success,
        'message': message,
        'data': data?.toMap(),
      };
}
