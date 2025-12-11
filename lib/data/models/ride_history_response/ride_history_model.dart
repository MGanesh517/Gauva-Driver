import '../order_response/order_model/order/order.dart';

class RideHistoryModel {
  RideHistoryModel({
      this.success, 
      this.message, 
      this.data,});

  RideHistoryModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? success;
  String? message;
  Data? data;
RideHistoryModel copyWith({  bool? success,
  String? message,
  Data? data,
}) => RideHistoryModel(  success: success ?? this.success,
  message: message ?? this.message,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      this.orders,});

  Data.fromJson(dynamic json) {
    if (json['orders'] != null) {
      orders = [];
      json['orders'].forEach((v) {
        orders?.add(Order.fromJson(v));
      });
    }
  }
  List<Order>? orders;
Data copyWith({  List<Order>? orders,
}) => Data(  orders: orders ?? this.orders,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (orders != null) {
      map['orders'] = orders?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

