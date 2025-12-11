import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/onboarding_notifier.dart';

final onBoardingNotifierProvider = StateNotifierProvider<OnboardingNotifier, int>((ref) => OnboardingNotifier());
