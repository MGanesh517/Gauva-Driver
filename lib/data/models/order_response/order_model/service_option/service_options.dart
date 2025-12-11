// class RidePreferences {
//   RidePreferences({this.prefList});
//
//   List<RidePreference>? prefList;
//
//   RidePreferences copyWith({
//     List<RidePreference>? prefList,
//   }) {
//     return RidePreferences(
//       prefList: prefList ?? this.prefList,
//     );
//   }
//
//   factory RidePreferences.fromJson(Map<String, dynamic> json) {
//     return RidePreferences(
//       prefList: json['ride_preferences'] != null
//           ? List<RidePreference>.from(
//         json['ride_preferences'].map((v) => RidePreference.fromJson(v)),
//       )
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       if (prefList != null)
//         'service_options': prefList!.map((v) => v.toJson()).toList(),
//     };
//   }
// }
//
// class RidePreference {
//   RidePreference({
//     this.id,
//     this.name,
//     this.description,
//     this.type,
//     this.additionalFee,
//   });
//
//   num? id;
//   String? name;
//   String? description;
//   Type? type;
//   num? additionalFee;
//
//   RidePreference copyWith({
//     num? id,
//     String? name,
//     String? description,
//     Type? type,
//     num? additionalFee,
//   }) {
//     return RidePreference(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       description: description ?? this.description,
//       type: type ?? this.type,
//       additionalFee: additionalFee ?? this.additionalFee,
//     );
//   }
//
//   factory RidePreference.fromJson(Map<String, dynamic> json) {
//     return RidePreference(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       type: json['type'] != null ? Type.fromJson(json['type']) : null,
//       additionalFee: json['additional_fee'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       if (type != null) 'type': type!.toJson(),
//       'additional_fee': additionalFee,
//     };
//   }
// }
//
// class Type {
//   Type({this.value, this.label});
//
//   String? value;
//   String? label;
//
//   Type copyWith({
//     String? value,
//     String? label,
//   }) {
//     return Type(
//       value: value ?? this.value,
//       label: label ?? this.label,
//     );
//   }
//
//   factory Type.fromJson(Map<String, dynamic> json) {
//     return Type(
//       value: json['value'],
//       label: json['label'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'value': value,
//       'label': label,
//     };
//   }
// }
