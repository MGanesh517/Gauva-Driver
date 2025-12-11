import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/lang_code_state.dart';
import '../view_model/select_country_notifier.dart';

final selectedCountry = StateNotifierProvider<SelectedCountryNotifier, LangCodeState>((ref) => SelectedCountryNotifier(ref));
