class ResendOtpModel {
  ResendOtpModel({
      this.message, 
      this.data,});

  ResendOtpModel.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  Data? data;
ResendOtpModel copyWith({  String? message,
  Data? data,
}) => ResendOtpModel(  message: message ?? this.message,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class Data {
  Data({
      this.mobile, 
      this.otp,});

  Data.fromJson(dynamic json) {
    mobile = json['mobile'];
    otp = json['otp'];
  }
  String? mobile;
  num? otp;
Data copyWith({  String? mobile,
  num? otp,
}) => Data(  mobile: mobile ?? this.mobile,
  otp: otp ?? this.otp,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobile'] = mobile;
    map['otp'] = otp;
    return map;
  }

}