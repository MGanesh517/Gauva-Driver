import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/app_flow_state.dart';
import '../view_model/app_flow_notifier.dart';

final appFlowViewModelProvider = StateNotifierProvider<AppFlowNotifier, AppFlowState>((ref) => AppFlowNotifier(ref));
