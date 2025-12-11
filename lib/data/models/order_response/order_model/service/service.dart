class Service {
  Service({
    this.id,
    this.name,
    this.logo,
    this.capacity,
    this.minimumFee,
    this.baseFare,
    this.perHundredMeters,});

  Service.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    capacity = json['capacity'];
    minimumFee = json['minimum_fee'];
    baseFare = json['base_fare'];
    perHundredMeters = json['per_hundred_meters'];
  }
  num? id;
  String? name;
  String? logo;
  num? capacity;
  num? minimumFee;
  num? baseFare;
  num? perHundredMeters;
  Service copyWith({  num? id,
    String? name,
    String? logo,
    num? capacity,
    num? minimumFee,
    num? baseFare,
    num? perHundredMeters,
  }) => Service(  id: id ?? this.id,
    name: name ?? this.name,
    logo: logo ?? this.logo,
    capacity: capacity ?? this.capacity,
    minimumFee: minimumFee ?? this.minimumFee,
    baseFare: baseFare ?? this.baseFare,
    perHundredMeters: perHundredMeters ?? this.perHundredMeters,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['logo'] = logo;
    map['capacity'] = capacity;
    map['minimum_fee'] = minimumFee;
    map['base_fare'] = baseFare;
    map['per_hundred_meters'] = perHundredMeters;
    return map;
  }

}


// class ServiceOrder {
//   ServiceOrder({
//       this.id,
//       this.name,
//       this.description,
//       this.logo,
//       this.capacity,
//     this.minimumFee,
//       this.baseFare,
//       this.perHundredMeters,});
//
//   ServiceOrder.fromJson(dynamic json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//     logo = json['logo'];
//     capacity = json['capacity'];
//     minimumFee = json['minimum_fee'];
//     baseFare = json['base_fare'];
//     perHundredMeters = json['per_hundred_meters'];
//   }
//   int? id;
//   String? name;
//   String? description;
//   String? logo;
//   int? capacity;
//   double? minimumFee;
//   double? baseFare;
//   double? perHundredMeters;
// ServiceOrder copyWith({  int? id,
//   String? name,
//   String? description,
//   String? logo,
//   int? capacity,
//   double? minimumFee,
//   double? baseFare,
//   double? perHundredMeters,
// }) => ServiceOrder(  id: id ?? this.id,
//   name: name ?? this.name,
//   description: description ?? this.description,
//   logo: logo ?? this.logo,
//   capacity: capacity ?? this.capacity,
//   minimumFee: minimumFee ?? this.minimumFee,
//   baseFare: baseFare ?? this.baseFare,
//   perHundredMeters: perHundredMeters ?? this.perHundredMeters,
// );
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['name'] = name;
//     map['description'] = description;
//     map['logo'] = logo;
//     map['capacity'] = capacity;
//     map['base_fare'] = baseFare;
//     map['per_hundred_meters'] = perHundredMeters;
//     return map;
//   }
//
// }