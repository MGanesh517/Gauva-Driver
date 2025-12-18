import '../order_response/order_model/order/order.dart';

class RideHistoryModel {
  List<Order>? content;
  int? totalElements;
  int? totalPages;
  int? size;
  int? number;

  RideHistoryModel({this.content, this.totalElements, this.totalPages, this.size, this.number});

  RideHistoryModel.fromJson(dynamic json) {
    if (json['content'] != null) {
      content = [];
      json['content'].forEach((v) {
        content?.add(Order.fromJson(v));
      });
    }
    totalElements = json['totalElements'];
    totalPages = json['totalPages'];
    size = json['size'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (content != null) {
      map['content'] = content?.map((v) => v.toJson()).toList();
    }
    map['totalElements'] = totalElements;
    map['totalPages'] = totalPages;
    map['size'] = size;
    map['number'] = number;
    return map;
  }
}
