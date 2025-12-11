class Addresses {
  Addresses({
    this.pickupAddress,
    this.dropAddress,
    this.waitAddress,});

  Addresses.fromJson(dynamic json) {
    pickupAddress = json['pickup_address'];
    dropAddress = json['drop_address'];
    waitAddress = json['wait_address'];
  }
  String? pickupAddress;
  String? dropAddress;
  String? waitAddress;
  Addresses copyWith({  String? pickupAddress,
    String? dropAddress,
    String? waitAddress,
  }) => Addresses(  pickupAddress: pickupAddress ?? this.pickupAddress,
    dropAddress: dropAddress ?? this.dropAddress,
    waitAddress: waitAddress ?? this.waitAddress,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pickup_address'] = pickupAddress;
    map['drop_address'] = dropAddress;
    map['wait_address'] = waitAddress;
    return map;
  }

}


// class Addresses {
//   Addresses({
//     this.pickupAddress,
//     this.dropAddress,
//     this.waitAddress,});
//
//   Addresses.fromJson(dynamic json) {
//     pickupAddress = json['pickup_address'];
//     dropAddress = json['drop_address'];
//     waitAddress = json['wait_address'];
//   }
//   String? pickupAddress;
//   String? dropAddress;
//   String? waitAddress;
//   Addresses copyWith({  String? pickupAddress,
//     String? dropAddress,
//     String? waitAddress,
//   }) => Addresses(  pickupAddress: pickupAddress ?? this.pickupAddress,
//     dropAddress: dropAddress ?? this.dropAddress,
//     waitAddress: waitAddress ?? this.waitAddress,
//   );
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['pickup_address'] = pickupAddress;
//     map['drop_address'] = dropAddress;
//     map['wait_address'] = waitAddress;
//     return map;
//   }
//
// }
