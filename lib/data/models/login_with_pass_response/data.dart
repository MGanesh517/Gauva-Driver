import 'package:flutter/foundation.dart';
import '../user_model/user_model.dart';

@immutable
class Data {
  final User? user;
  final String? token;
  final String? refreshToken;
  final bool? otherDevice;

  const Data({
    this.user,
    this.token,
    this.refreshToken,
    this.otherDevice,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        token: json['token'] as String? ?? json['accessToken'] as String?,
        refreshToken: json['refreshToken'] as String?,
        otherDevice: json['other_device'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'user': user?.toJson(),
        'token': token,
        'refreshToken': refreshToken,
        'other_device': otherDevice,
      };
}
