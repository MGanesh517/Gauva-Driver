class Vehicle {
  Vehicle({
    this.id,
    this.carColor,
    this.carModel,
    this.carPlateNumber,
    this.carProductionYear,
    this.direction,});

  Vehicle.fromJson(dynamic json) {
    id = json['id'];
    carColor = json['carColor'];
    carModel = json['carModel'];
    carPlateNumber = json['carPlateNumber'];
    carProductionYear = json['carProductionYear'];
    direction = json['direction'];
  }
  num? id;
  dynamic carColor;
  dynamic carModel;
  dynamic carPlateNumber;
  dynamic carProductionYear;
  num? direction;
  Vehicle copyWith({  num? id,
    dynamic carColor,
    dynamic carModel,
    dynamic carPlateNumber,
    dynamic carProductionYear,
    num? direction,
  }) => Vehicle(  id: id ?? this.id,
    carColor: carColor ?? this.carColor,
    carModel: carModel ?? this.carModel,
    carPlateNumber: carPlateNumber ?? this.carPlateNumber,
    carProductionYear: carProductionYear ?? this.carProductionYear,
    direction: direction ?? this.direction,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['carColor'] = carColor;
    map['carModel'] = carModel;
    map['carPlateNumber'] = carPlateNumber;
    map['carProductionYear'] = carProductionYear;
    map['direction'] = direction;
    return map;
  }

}


// class VehicleOrder {
//   VehicleOrder({
//       this.id,
//       this.carColor,
//       this.carModel,
//       this.carPlateNumber,
//       this.carProductionYear,
//       this.direction,});
//
//   VehicleOrder.fromJson(dynamic json) {
//     id = json['id'];
//     carColor = json['carColor'];
//     carModel = json['carModel'];
//     carPlateNumber = json['carPlateNumber'];
//     carProductionYear = json['carProductionYear'];
//     direction = json['direction'];
//   }
//   int? id;
//   String? carColor;
//   String? carModel;
//   String? carPlateNumber;
//   num? carProductionYear;
//   num? direction;
// VehicleOrder copyWith({  int? id,
//   String? carColor,
//   String? carModel,
//   String? carPlateNumber,
//   num? carProductionYear,
//   num? direction,
// }) => VehicleOrder(  id: id ?? this.id,
//   carColor: carColor ?? this.carColor,
//   carModel: carModel ?? this.carModel,
//   carPlateNumber: carPlateNumber ?? this.carPlateNumber,
//   carProductionYear: carProductionYear ?? this.carProductionYear,
//   direction: direction ?? this.direction,
// );
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['carColor'] = carColor;
//     map['carModel'] = carModel;
//     map['carPlateNumber'] = carPlateNumber;
//     map['carProductionYear'] = carProductionYear;
//     map['direction'] = direction;
//     return map;
//   }
// }
