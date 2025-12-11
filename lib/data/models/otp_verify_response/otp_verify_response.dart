import 'package:flutter/foundation.dart';

import 'data.dart';

@immutable
class OtpVerifyResponse {
  final bool? success;
  final String? message;
  final Data? data;

  const OtpVerifyResponse({this.success, this.message, this.data});

  factory OtpVerifyResponse.fromMap(Map<String, dynamic> json) => OtpVerifyResponse(
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
