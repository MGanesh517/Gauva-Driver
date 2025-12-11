class CountryCode {
  final String? name;
  final String? code;
  final String? phoneCode;
  final String? flag;
  final String? languageCode;

  CountryCode({
    this.name,
    this.code,
    this.phoneCode,
    this.flag,
    this.languageCode,
  });

  factory CountryCode.fromJson(Map<String, dynamic> json) => CountryCode(
    name: json['name'],
    code: json['code'],
    phoneCode: json['phoneCode'],
    flag: json['flag'],
    languageCode: json['languageCode'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'code': code,
    'phoneCode': phoneCode,
    'flag': flag,
    'languageCode': languageCode,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CountryCode &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              code == other.code &&
              phoneCode == other.phoneCode &&
              flag == other.flag &&
              languageCode == other.languageCode;

  @override
  int get hashCode =>
      name.hashCode ^
      code.hashCode ^
      phoneCode.hashCode ^
      flag.hashCode ^
      languageCode.hashCode;
}