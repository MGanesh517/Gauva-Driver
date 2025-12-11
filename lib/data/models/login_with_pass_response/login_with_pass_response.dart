import 'package:flutter/foundation.dart';

import 'data.dart';

@immutable
class LoginWithPassResponse {
  final bool? success;
  final String? message;
  final Data? data;
  final String? accessToken;
  final String? refreshToken;
  final String? type;

  const LoginWithPassResponse({
    this.success,
    this.message,
    this.data,
    this.accessToken,
    this.refreshToken,
    this.type,
  });

  factory LoginWithPassResponse.fromMap(Map<String, dynamic> json) {
    // Handle new API format (accessToken at root level)
    if (json.containsKey('accessToken')) {
      return LoginWithPassResponse(
        success: true,
        message: json['message'] as String?,
        accessToken: json['accessToken'] as String?,
        refreshToken: json['refreshToken'] as String?,
        type: json['type'] as String?,
        data: json['accessToken'] != null
            ? Data(
                token: json['accessToken'] as String?,
                refreshToken: json['refreshToken'] as String?,
              )
            : null,
      );
    }
    // Handle old API format (token in data object)
    return LoginWithPassResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromMap(json['data'] as Map<String, dynamic>),
      accessToken: json['data']?['token'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'success': success,
        'message': message,
        'data': data?.toMap(),
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'type': type,
      };
}
