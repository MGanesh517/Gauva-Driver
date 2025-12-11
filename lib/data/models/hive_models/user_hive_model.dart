class UserHiveModel {
  int? id;
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
  int? vehicleRegiYear;
  String? vehiclePlate;
  num? rating;
  num? reviewCount;
  bool? isUnderReview;
  dynamic radiusInMeter;
  String? driverStatus;

  UserHiveModel({
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
  });

  factory UserHiveModel.fromMap(Map<String, dynamic> map) => UserHiveModel(
      id: map['id'] as int?,
      name: map['name'] as String?,
      countryIso: map['countryIso'] as String?,
      gender: map['gender'] as String?,
      address: map['address'] as String?,
      email: map['email'] as String?,
      mobile: map['mobile'] as String?,
      emailVerified: map['emailVerified'] as bool?,
      otpVerified: map['otpVerified'] as bool?,
      status: map['status'] as String?,
      profilePicture: map['profilePicture'] as String?,
      emergencyContact: map['emergencyContact'] as String?,
      licence: map['licence'] as String?,
      nid: map['nid'] as String?,
      vehicleColor: map['vehicleColor'] as String?,
      vehicleRegiYear: map['vehicleRegiYear'] as int?,
      vehiclePlate: map['vehiclePlate'] as String?,
      rating: map['rating'] as num?,
      reviewCount: map['reviewCount'] as num?,
      isUnderReview: map['isUnderReview'] as bool?,
      radiusInMeter: map['radiusInMeter'],
      driverStatus: map['driverStatus'] as String?,
    );

  Map<String, dynamic> toMap() => {
      'id': id,
      'name': name,
      'countryIso': countryIso,
      'gender': gender,
      'address': address,
      'email': email,
      'mobile': mobile,
      'emailVerified': emailVerified,
      'otpVerified': otpVerified,
      'status': status,
      'profilePicture': profilePicture,
      'emergencyContact': emergencyContact,
      'licence': licence,
      'nid': nid,
      'vehicleColor': vehicleColor,
      'vehicleRegiYear': vehicleRegiYear,
      'vehiclePlate': vehiclePlate,
      'rating': rating,
      'reviewCount': reviewCount,
      'isUnderReview': isUnderReview,
      'radiusInMeter': radiusInMeter,
      'driverStatus': driverStatus,
    };
}
