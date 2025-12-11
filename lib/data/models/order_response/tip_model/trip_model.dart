import '../order_model/order/order.dart';

class TripModel {
  TripModel({
      this.message, 
      this.data,});

  TripModel.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  Data? data;
TripModel copyWith({  String? message,
  Data? data,
}) => TripModel(  message: message ?? this.message,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      this.order,});

  Data.fromJson(dynamic json) {
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }
  Order? order;
Data copyWith({  Order? order,
}) => Data(  order: order ?? this.order,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (order != null) {
      map['order'] = order?.toJson();
    }
    return map;
  }

}

