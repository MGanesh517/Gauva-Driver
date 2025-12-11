class User {
  User({
    this.id,
    this.name,
    this.countryIso,
    this.gender,
    this.address,
    this.email,
    this.mobile,
    this.emailVerified,
    this.otpVerified,
    this.status,
    this.profilePicture,
    this.emergencyContact,
    this.licence,
    this.nid,
    this.vehicleColor,
    this.vehicleRegiYear,
    this.vehiclePlate,
    this.rating,
    this.reviewCount,
    this.isUnderReview,
    this.radiusInMeter,
    this.driverStatus,
    this.totalRide,
    this.totalDistance,
  });

  User.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    countryIso = json['country_iso'];
    gender = json['gender'];
    address = json['address'];
    email = json['email'];
    mobile = json['mobile'];
    emailVerified = json['email_verified'];
    otpVerified = json['otp_verified'];
    status = json['status'];
    profilePicture = json['profile_picture'];
    emergencyContact = json['emergency_contact'];
    licence = json['licence'];
    nid = json['nid'];
    vehicleColor = json['vehicle_color'];
    vehicleRegiYear = json['vehicle_regi_year'];
    vehiclePlate = json['vehicle_plate'];
    rating = json['rating'];
    reviewCount = json['review_count'];
    isUnderReview = json['is_under_review'];
    radiusInMeter = json['radius_in_meter'];
    driverStatus = json['driver_status'];
    totalRide = json['total_ride'];
    totalDistance = json['total_distance'];
  }
  num? id;
  String? name;
  String? countryIso;
  String? gender;
  String? address;
  String? email;
  String? mobile;
  bool? emailVerified;
  bool? otpVerified;
  String? status;
  String? profilePicture;
  String? emergencyContact;
  String? licence;
  String? nid;
  String? vehicleColor;
  num? vehicleRegiYear;
  String? vehiclePlate;
  num? rating;
  num? reviewCount;
  bool? isUnderReview;
  dynamic radiusInMeter;
  String? driverStatus;
  num? totalRide;
  num? totalDistance;
  User copyWith({  num? id,
    String? name,
    String? countryIso,
    String? gender,
    String? address,
    String? email,
    String? mobile,
    bool? emailVerified,
    bool? otpVerified,
    String? status,
    String? profilePicture,
    String? emergencyContact,
    String? licence,
    String? nid,
    String? vehicleColor,
    num? vehicleRegiYear,
    String? vehiclePlate,
    num? rating,
    num? reviewCount,
    bool? isUnderReview,
    dynamic radiusInMeter,
    String? driverStatus,
    num? totalRide,
    num? totalDistance
  }) => User(  id: id ?? this.id,
    name: name ?? this.name,
    countryIso: countryIso ?? this.countryIso,
    gender: gender ?? this.gender,
    address: address ?? this.address,
    email: email ?? this.email,
    mobile: mobile ?? this.mobile,
    emailVerified: emailVerified ?? this.emailVerified,
    otpVerified: otpVerified ?? this.otpVerified,
    status: status ?? this.status,
    profilePicture: profilePicture ?? this.profilePicture,
    emergencyContact: emergencyContact ?? this.emergencyContact,
    licence: licence ?? this.licence,
    nid: nid ?? this.nid,
    vehicleColor: vehicleColor ?? this.vehicleColor,
    vehicleRegiYear: vehicleRegiYear ?? this.vehicleRegiYear,
    vehiclePlate: vehiclePlate ?? this.vehiclePlate,
    rating: rating ?? this.rating,
    reviewCount: reviewCount ?? this.reviewCount,
    isUnderReview: isUnderReview ?? this.isUnderReview,
    radiusInMeter: radiusInMeter ?? this.radiusInMeter,
    driverStatus: driverStatus ?? this.driverStatus,
    totalRide: totalRide ?? this.totalRide,
    totalDistance: totalDistance ?? this.totalDistance,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['country_iso'] = countryIso;
    map['gender'] = gender;
    map['address'] = address;
    map['email'] = email;
    map['mobile'] = mobile;
    map['email_verified'] = emailVerified;
    map['otp_verified'] = otpVerified;
    map['status'] = status;
    map['profile_picture'] = profilePicture;
    map['emergency_contact'] = emergencyContact;
    map['licence'] = licence;
    map['nid'] = nid;
    map['vehicle_color'] = vehicleColor;
    map['vehicle_regi_year'] = vehicleRegiYear;
    map['vehicle_plate'] = vehiclePlate;
    map['rating'] = rating;
    map['review_count'] = reviewCount;
    map['is_under_review'] = isUnderReview;
    map['radius_in_meter'] = radiusInMeter;
    map['driver_status'] = driverStatus;
    map['total_ride'] = totalRide;
    map['total_distance'] = totalDistance;
    return map;
  }

}