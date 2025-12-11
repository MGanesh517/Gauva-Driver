import '../country_code.dart';

class CountryCodeModel {
  CountryCodeModel({
      this.message, 
      this.countries,});

  CountryCodeModel.fromJson(dynamic json) {
    message = json['message'];
    if (json['countries'] != null) {
      countries = [];
      json['countries'].forEach((v) {
        countries?.add(CountryCode.fromJson(v));
      });
    }
  }
  String? message;
  List<CountryCode>? countries;
CountryCodeModel copyWith({  String? message,
  List<CountryCode>? countries,
}) => CountryCodeModel(  message: message ?? this.message,
  countries: countries ?? this.countries,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = message;
    if (countries != null) {
      map['countries'] = countries?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

// class Countries {
//   Countries({
//       this.code,
//       this.name,
//       this.phoneCode,
//       this.flag,
//       this.languageCode,});
//
//   Countries.fromJson(dynamic json) {
//     code = json['code'];
//     name = json['name'];
//     phoneCode = json['phoneCode'];
//     flag = json['flag'];
//     languageCode = json['languageCode'];
//   }
//   String? code;
//   String? name;
//   String? phoneCode;
//   String? flag;
//   dynamic languageCode;
// Countries copyWith({  String? code,
//   String? name,
//   String? phoneCode,
//   String? flag,
//   dynamic languageCode,
// }) => Countries(  code: code ?? this.code,
//   name: name ?? this.name,
//   phoneCode: phoneCode ?? this.phoneCode,
//   flag: flag ?? this.flag,
//   languageCode: languageCode ?? this.languageCode,
// );
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['code'] = code;
//     map['name'] = name;
//     map['phoneCode'] = phoneCode;
//     map['flag'] = flag;
//     map['languageCode'] = languageCode;
//     return map;
//   }
//
// }