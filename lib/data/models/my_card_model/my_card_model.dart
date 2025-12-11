class MyCardModel {
  MyCardModel({
      this.success, 
      this.message, 
      this.data,});

  MyCardModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? success;
  String? message;
  Data? data;
MyCardModel copyWith({  bool? success,
  String? message,
  Data? data,
}) => MyCardModel(  success: success ?? this.success,
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
      this.cards,});

  Data.fromJson(dynamic json) {
    if (json['cards'] != null) {
      cards = [];
      json['cards'].forEach((v) {
        cards?.add(Cards.fromJson(v));
      });
    }
  }
  List<Cards>? cards;
Data copyWith({  List<Cards>? cards,
}) => Data(  cards: cards ?? this.cards,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (cards != null) {
      map['cards'] = cards?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Cards {
  Cards({
    this.id,
    this.brand,
    this.name,
    this.country,
    this.cardHolderName,
    this.last4,
    this.expMonth,
    this.expYear,});

  Cards.fromJson(dynamic json) {
    id = json['id'];
    brand = json['brand'];
    name = json['name'];
    country = json['country'];
    cardHolderName = json['card_holder_name'];
    last4 = json['last4'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
  }
  String? id;
  String? brand;
  String? name;
  String? country;
  String? cardHolderName;
  String? last4;
  num? expMonth;
  num? expYear;
  Cards copyWith({String? id,
    String? brand,
    String? name,
    String? country,
    String? cardHolderName,
    String? last4,
    num? expMonth,
    num? expYear,
  }) => Cards(  id: id ?? this.id,
    brand: brand ?? this.brand,
    name: name ?? this.name,
    country: country ?? this.country,
    cardHolderName: cardHolderName ?? this.cardHolderName,
    last4: last4 ?? this.last4,
    expMonth: expMonth ?? this.expMonth,
    expYear: expYear ?? this.expYear,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['brand'] = brand;
    map['name'] = name;
    map['last4'] = last4;
    map['exp_month'] = expMonth;
    map['exp_year'] = expYear;
    return map;
  }

}