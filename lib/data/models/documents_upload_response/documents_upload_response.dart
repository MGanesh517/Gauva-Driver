import 'package:flutter/foundation.dart';

import 'data.dart';

@immutable
class DocumentsUploadResponse {
  final bool? success;
  final String? message;
  final Data? data;

  const DocumentsUploadResponse({this.success, this.message, this.data});

  factory DocumentsUploadResponse.fromMap(Map<String, dynamic> json) => DocumentsUploadResponse(
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
