class TermsAndConditionModel {
  TermsAndConditionModel({
      this.message, 
      this.data,});

  TermsAndConditionModel.fromJson(dynamic json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  String? message;
  Data? data;
TermsAndConditionModel copyWith({  String? message,
  Data? data,
}) => TermsAndConditionModel(  message: message ?? this.message,
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
      this.terms,});

  Data.fromJson(dynamic json) {
    terms = json['terms'];
  }
  String? terms;
Data copyWith({  String? terms,
}) => Data(  terms: terms ?? this.terms,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['terms'] = terms;
    return map;
  }

}