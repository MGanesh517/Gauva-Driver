class RidePreference {
  RidePreference({
      this.id, 
      this.name, 
      this.description, 
      this.type, 
      this.additionalFee,});

  RidePreference.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    type = json['type'] != null ? Type.fromJson(json['type']) : null;
    additionalFee = json['additional_fee'];
  }
  num? id;
  String? name;
  String? description;
  Type? type;
  num? additionalFee;
RidePreference copyWith({  num? id,
  String? name,
  String? description,
  Type? type,
  num? additionalFee,
}) => RidePreference(  id: id ?? this.id,
  name: name ?? this.name,
  description: description ?? this.description,
  type: type ?? this.type,
  additionalFee: additionalFee ?? this.additionalFee,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    if (type != null) {
      map['type'] = type?.toJson();
    }
    map['additional_fee'] = additionalFee;
    return map;
  }

}

class Type {
  Type({
      this.value, 
      this.label,});

  Type.fromJson(dynamic json) {
    value = json['value'];
    label = json['label'];
  }
  String? value;
  String? label;
Type copyWith({  String? value,
  String? label,
}) => Type(  value: value ?? this.value,
  label: label ?? this.label,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = value;
    map['label'] = label;
    return map;
  }

}