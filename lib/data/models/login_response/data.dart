
class Data {
  Data({
    this.mobile,
    this.otp,
    this.isNewDriver,
    this.isUnderReview,
  });

  Data.fromJson(dynamic json) {
    mobile = json['mobile'];
    otp = json['otp'];
    isNewDriver = json['is_new_driver'];
    isUnderReview = json['is_under_review'];
  }
  String? mobile;
  num? otp;
  bool? isNewDriver;
  bool? isUnderReview;
  Data copyWith({  String? mobile,
    num? otp,
    bool? isNewRider,
  }) => Data(  mobile: mobile ?? this.mobile,
    otp: otp ?? this.otp,
    isNewDriver: isNewRider ?? isNewDriver,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobile'] = mobile;
    map['otp'] = otp;
    map['is_new_driver'] = isNewDriver;
    map['is_under_review'] = isUnderReview;
    return map;
  }

}