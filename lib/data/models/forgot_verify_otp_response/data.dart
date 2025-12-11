import 'package:flutter/foundation.dart';

@immutable
class Data {
  final String? token;

  const Data({this.token});

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        token: json['token'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'token': token,
      };
}
