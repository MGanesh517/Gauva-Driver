class Rider {
  Rider({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.profilePicture,
    // this.onTrip,
    this.totalTrip,
    this.rating,
  });

  Rider.fromJson(dynamic json) {
    id = json['id'];
    // Handle both direct fields and nested user object
    name = json['name'] ?? json['fullName'] ?? json['full_name'];
    email = json['email'];
    mobile = json['mobile'] ?? json['phone'];
    profilePicture = json['profile_picture'] ?? json['profilePicture'];
    // onTrip = json['on_trip'];
    totalTrip = json['total_trip'] ?? json['totalTrip'];
    rating = json['rating'];
  }
  dynamic id; // Can be num or String (UUID)
  String? name;
  dynamic email;
  String? mobile;
  String? profilePicture;
  // bool? onTrip;
  num? totalTrip;
  num? rating;
  Rider copyWith({
    dynamic id,
    String? name,
    dynamic email,
    String? mobile,
    String? profilePicture,
    // bool? onTrip,
    num? totalTrip,
  }) => Rider(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    mobile: mobile ?? this.mobile,
    profilePicture: profilePicture ?? this.profilePicture,
    // onTrip: onTrip ?? this.onTrip,
    totalTrip: totalTrip ?? this.totalTrip,
  );

  /// Merges this rider with another Rider object.
  /// New non-null values will overwrite existing ones.
  /// Existing values will be preserved if the new value is null.
  Rider merge(Rider? other) {
    if (other == null) return this;
    return copyWith(
      id: other.id,
      name: other.name,
      email: other.email,
      mobile: other.mobile,
      profilePicture: other.profilePicture,
      totalTrip: other.totalTrip,
    );
  }

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
