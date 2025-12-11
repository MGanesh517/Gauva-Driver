import 'package:flutter/foundation.dart';

@immutable
class Datum {
  final int? id;
  final String? name;

  const Datum({this.id, this.name});

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };
}
