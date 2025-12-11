import 'package:flutter/foundation.dart';

@immutable
class CommonResponse {
  final bool? success;
  final String? message;

  const CommonResponse({this.success, this.message});

  factory CommonResponse.fromJson(Map<String, dynamic> json) => CommonResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
    );

  Map<String, dynamic> toMap() => {
        'success': success,
        'message': message,
      };
}
