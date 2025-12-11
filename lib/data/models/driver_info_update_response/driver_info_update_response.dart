import 'package:gauva_driver/data/models/driver_info_update_response/data.dart';

class DriverInfoUpdateResponse {
  DriverInfoUpdateResponse({this.message, this.data});

  DriverInfoUpdateResponse.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? DriverData.fromJson(json['data']) : null;
  }
  String? message;
  DriverData? data;
  DriverInfoUpdateResponse copyWith({String? message, DriverData? data}) =>
      DriverInfoUpdateResponse(message: message ?? this.message, data: data ?? this.data);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}
