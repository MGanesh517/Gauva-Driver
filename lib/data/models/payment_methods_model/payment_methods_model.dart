class PaymentMethodsModel {
  PaymentMethodsModel({
      this.success, 
      this.message, 
      this.data,});

  PaymentMethodsModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? success;
  String? message;
  Data? data;
PaymentMethodsModel copyWith({  bool? success,
  String? message,
  Data? data,
}) => PaymentMethodsModel(  success: success ?? this.success,
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
      this.paymentMethods,});

  Data.fromJson(dynamic json) {
    if (json['paymentMethods'] != null) {
      paymentMethods = [];
      json['paymentMethods'].forEach((v) {
        paymentMethods?.add(PaymentMethods.fromJson(v));
      });
    }
  }
  List<PaymentMethods>? paymentMethods;
Data copyWith({  List<PaymentMethods>? paymentMethods,
}) => Data(  paymentMethods: paymentMethods ?? this.paymentMethods,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (paymentMethods != null) {
      map['paymentMethods'] = paymentMethods?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class PaymentMethods {
  PaymentMethods({
      this.id, 
      this.value, 
      this.logo,});

  PaymentMethods.fromJson(dynamic json) {
    id = json['id'];
    value = json['value'];
    logo = json['logo'];
  }
  num? id;
  String? value;
  String? logo;
PaymentMethods copyWith({  num? id,
  String? value,
  String? logo,
}) => PaymentMethods(  id: id ?? this.id,
  value: value ?? this.value,
  logo: logo ?? this.logo,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['value'] = value;
    map['logo'] = logo;
    return map;
  }

}