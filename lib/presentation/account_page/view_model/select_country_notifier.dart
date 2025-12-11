import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/country_codes.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/state/app_state.dart';
import '../../../core/state/lang_code_state.dart';
import '../../../data/models/country_code.dart';
import '../../../data/repositories/interfaces/country_list_repo_interface.dart';
import '../../../data/services/local_storage_service.dart';
import '../../../data/services/navigation_service.dart';
import '../../booking/provider/home_providers.dart';
import '../provider/select_country_provider.dart';

class SelectedCountryNotifier extends StateNotifier<LangCodeState> {
  final Ref ref;

  SelectedCountryNotifier(this.ref) : super(LangCodeState.empty()) {
    _init();
  }

  Future<void> _init() async {
    final savedLocale = await LocalStorageService().getSelectedLanguage();
    final CountryCode initialCountry = countryCodeList.firstWhere(
          (c) => c.languageCode == savedLocale,
      orElse: () => countryCodeList[1],
    );
    state = state.copyWith(selectedLang: initialCountry, langCountryList: countryCodeList);
  }

  void setCountry(CountryCode countryCode, {bool loadAddress = false}) {
    if(countryCode.languageCode == null)return;
    state = state.copyWith(selectedLang: countryCode);
    LocalStorageService().selectLanguage(countryCode.languageCode!);
    Future.delayed(const Duration(microseconds: 300)).then((_){
      Navigator.of(NavigationService.navigatorKey.currentContext!).pushNamedAndRemoveUntil(
        AppRoutes.splash,
            (route)=> false,
      );

      if(loadAddress){
        ref.read(bookingNotifierProvider.notifier).initialize();
      }
    });
  }

  void setPhoneCode(CountryCode phoneCode){
    if(phoneCode.phoneCode == null)return;
    LocalStorageService().savePhoneCode(phoneCode.phoneCode!);
    state = state.copyWith(selectedPhoneCode: phoneCode);
  }

  void updatePhoneList(List<CountryCode> phoneList){
    if(phoneList.isEmpty)return;
    final initial = phoneList.firstWhere((element) => element.code == 'BD', orElse: ()=> phoneList.first);
    LocalStorageService().savePhoneCode(initial.phoneCode!);
    state = state.copyWith(phoneCountryList: phoneList, selectedPhoneCode: initial);
  }

  void reset()=> _init();

}


class CountryListNotifier extends StateNotifier<AppState<List<CountryCode>>> {
  final Ref ref;
  final ICountryListRepo _repo;
  CountryListNotifier(this.ref, this._repo) : super(const AppState.initial()) {
    getCountryList();
  }

  Future<void> getCountryList() async {
    state = const AppState.loading();
    final response = await _repo.getCountryList();
    response.fold(
          (failure) {
        state = AppState.error(failure);
      },
          (data) {
        state = AppState.success(data.countries ?? []);
        ref.read(selectedCountry.notifier).updatePhoneList(data.countries ?? []);
      },
    );
  }
}