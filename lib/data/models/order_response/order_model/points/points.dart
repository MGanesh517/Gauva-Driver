class Points {
  Points({
    this.pickupLocation,
    this.dropLocation,
    this.waitLocation,});

  Points.fromJson(dynamic json) {
    pickupLocation = json['pickup_location'] != null ? json['pickup_location'].cast<num>() : [];
    dropLocation = json['drop_location'] != null ? json['drop_location'].cast<num>() : [];
    waitLocation = json['wait_location'];
  }
  List<num>? pickupLocation;
  List<num>? dropLocation;
  dynamic waitLocation;
  Points copyWith({  List<num>? pickupLocation,
    List<num>? dropLocation,
    dynamic waitLocation,
  }) => Points(  pickupLocation: pickupLocation ?? this.pickupLocation,
    dropLocation: dropLocation ?? this.dropLocation,
    waitLocation: waitLocation ?? this.waitLocation,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pickup_location'] = pickupLocation;
    map['drop_location'] = dropLocation;
    map['wait_location'] = waitLocation;
    return map;
  }

}

// class Points {
//   Points({
//     this.pickupLocation,
//     this.dropLocation,
//     this.waitLocation,});
//
//   Points.fromJson(dynamic json) {
//     pickupLocation = json['pickup_location'] != null ? json['pickup_location'].cast<num>() : [];
//     dropLocation = json['drop_location'] != null ? json['drop_location'].cast<num>() : [];
//     waitLocation = json['wait_location'] != null ? json['wait_location'].cast<num>() : [];
//   }
//   List<num>? pickupLocation;
//   List<num>? dropLocation;
//   List<num>? waitLocation;
//   Points copyWith({  List<num>? pickupLocation,
//     List<num>? dropLocation,
//     List<num>? waitLocation,
//   }) => Points(  pickupLocation: pickupLocation ?? this.pickupLocation,
//     dropLocation: dropLocation ?? this.dropLocation,
//     waitLocation: waitLocation ?? this.waitLocation,
//   );
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['pickup_location'] = pickupLocation;
//     map['drop_location'] = dropLocation;
//     map['wait_location'] = waitLocation;
//     return map;
//   }
//
// }