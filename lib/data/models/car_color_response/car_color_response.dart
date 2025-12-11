import 'package:flutter/foundation.dart';

import 'datum.dart';

@immutable
class CarColorResponse {
  final bool? success;
  final String? message;
  final List<Datum>? data;

  const CarColorResponse({this.success, this.message, this.data});

  factory CarColorResponse.fromMap(Map<String, dynamic> json) => CarColorResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromMap(e as Map<String, dynamic>))
          .toList(),
    );

  Map<String, dynamic> toMap() => {
        'success': success,
        'message': message,
        'data': data?.map((e) => e.toMap()).toList(),
      };
}
