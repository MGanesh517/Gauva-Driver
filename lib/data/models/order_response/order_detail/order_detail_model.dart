
import '../order_model/order/order.dart';

class OrderDetailModel {
  OrderDetailModel({
      this.success, 
      this.message, 
      this.data,});

  OrderDetailModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    // Handle both wrapped response {success, message, data} and direct Order object
    if (json['data'] != null) {
      data = Order.fromJson(json['data']);
    } else if (json['id'] != null) {
      // Direct Order object (not wrapped)
      data = Order.fromJson(json);
    } else {
      data = null;
    }
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