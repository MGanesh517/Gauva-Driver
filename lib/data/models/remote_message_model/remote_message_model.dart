class RemoteMessageModel {
  RemoteMessageModel({
      this.type, 
      this.orderId, 
      this.orderStatus, 
      this.sentTime,});

  RemoteMessageModel.fromJson(dynamic json) {
    type = json['type'];
    orderId = json['order_id'] is String ? num.tryParse(json['order_id']) : json['order_id'];
    orderStatus = json['order_status'];
    sentTime = json['sent_at'];
  }
  String? type;
  num? orderId;
  String? orderStatus;
  String? sentTime;
RemoteMessageModel copyWith({  String? type,
  num? orderId,
  String? orderStatus,
  String? sentTime,
}) => RemoteMessageModel(  type: type ?? this.type,
  orderId: orderId ?? this.orderId,
  orderStatus: orderStatus ?? this.orderStatus,
  sentTime: sentTime ?? this.sentTime,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['order_id'] = orderId;
    map['order_status'] = orderStatus;
    map['sent_at'] = sentTime;
    return map;
  }

}