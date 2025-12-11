import 'package:flutter/foundation.dart';

import 'data.dart';

@immutable
class LoginResponse {
  final String? message;
  final Data? data;

  const LoginResponse({ this.message, this.data});

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        message: json['message'] as String?,
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': data?.toJson(),
      };
}
