
import '../order_model/order/order.dart';

class OrderDetailModel {
  OrderDetailModel({
      this.success, 
      this.message, 
      this.data,});

  OrderDetailModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Order.fromJson(json['data']) : null;
  }
  bool? success;
  String? message;
  Order? data;
OrderDetailModel copyWith({  bool? success,
  String? message,
  Order? data,
}) => OrderDetailModel(  success: success ?? this.success,
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