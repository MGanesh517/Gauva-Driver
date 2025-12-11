import 'package:flutter/foundation.dart';

import '../user_model/user_model.dart';

@immutable
class Data {
  final User? user;

  const Data({this.user});

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'user': user?.toJson(),
      };
}
