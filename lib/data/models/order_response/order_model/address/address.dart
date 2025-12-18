class Addresses {
  Addresses({
    this.pickupAddress,
    this.dropAddress,
    this.waitAddress,});

  Addresses.fromJson(dynamic json) {
    // Handle both formats: pickup_address/drop_address (old) and pickupArea/destinationArea (new API)
    pickupAddress = json['pickup_address'] ?? json['pickupArea'];
    dropAddress = json['drop_address'] ?? json['destinationArea'];
    waitAddress = json['wait_address'] ?? json['waitArea'];
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
