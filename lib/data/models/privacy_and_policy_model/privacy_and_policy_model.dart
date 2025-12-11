class PrivacyAndPolicyModel {
  PrivacyAndPolicyModel({
      this.message, 
      this.data,});

  PrivacyAndPolicyModel.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  Data? data;
PrivacyAndPolicyModel copyWith({  String? message,
  Data? data,
}) => PrivacyAndPolicyModel(  message: message ?? this.message,
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
      this.policy,});

  Data.fromJson(dynamic json) {
    policy = json['policy'];
  }
  String? policy;
Data copyWith({  String? policy,
}) => Data(  policy: policy ?? this.policy,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['policy'] = policy;
    return map;
  }

}