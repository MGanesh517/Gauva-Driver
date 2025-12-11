class Rider {
  Rider({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.profilePicture,
    // this.onTrip,
    this.totalTrip,
    this.rating
  });

  Rider.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    profilePicture = json['profile_picture'];
    // onTrip = json['on_trip'];
    totalTrip = json['total_trip'];
    rating = json['rating'];
  }
  num? id;
  String? name;
  dynamic email;
  String? mobile;
  String? profilePicture;
  // bool? onTrip;
  num? totalTrip;
  num? rating;
  Rider copyWith({  num? id,
    String? name,
    dynamic email,
    String? mobile,
    String? profilePicture,
    // bool? onTrip,
    num? totalTrip,
  }) => Rider(  id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    mobile: mobile ?? this.mobile,
    profilePicture: profilePicture ?? this.profilePicture,
    // onTrip: onTrip ?? this.onTrip,
    totalTrip: totalTrip ?? this.totalTrip
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['mobile'] = mobile;
    map['profile_picture'] = profilePicture;
    // map['on_trip'] = onTrip;
    map['total_trip'] = totalTrip;
    return map;
  }

}
