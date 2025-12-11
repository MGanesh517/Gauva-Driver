import 'package:flutter/foundation.dart';

@immutable
class Data {
  final Data? data;

  const Data({this.data});

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        data: json['data'] == null
            ? null
            : Data.fromMap(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'data': data?.toMap(),
      };
}
