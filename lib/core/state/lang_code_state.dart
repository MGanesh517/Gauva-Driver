import '../../data/models/country_code.dart';
import 'package:equatable/equatable.dart';

class LangCodeState extends Equatable {
  final List<CountryCode> phoneCountryList;
  final CountryCode? selectedPhoneCode;
  final List<CountryCode> langCountryList;
  final CountryCode? selectedLang;

  const LangCodeState({
    this.phoneCountryList = const <CountryCode>[],
    this.selectedPhoneCode,
    this.langCountryList = const <CountryCode>[],
    this.selectedLang,
  });

  factory LangCodeState.empty() => const LangCodeState();

  LangCodeState copyWith({
    List<CountryCode>? phoneCountryList,
    CountryCode? selectedPhoneCode,
    List<CountryCode>? langCountryList,
    CountryCode? selectedLang,
  }) => LangCodeState(
    phoneCountryList: phoneCountryList ?? this.phoneCountryList,
    selectedPhoneCode: selectedPhoneCode ?? this.selectedPhoneCode,
    langCountryList: langCountryList ?? this.langCountryList,
    selectedLang: selectedLang ?? this.selectedLang,
  );

  @override
  List<Object?> get props => [
    phoneCountryList,
    selectedPhoneCode,
    langCountryList,
    selectedLang,
  ];

  @override
  String toString() =>
      'LangCodeState(selectedPhoneCode: $selectedPhoneCode, selectedLang: $selectedLang, '
          'phoneCountryList length: ${phoneCountryList.length}, langCountryList length: ${langCountryList.length})';
}
