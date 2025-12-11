import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_flow_state.freezed.dart';

@freezed
class AppFlowState with _$AppFlowState {
  const factory AppFlowState.loginRequired() = _LoginRequired;
  const factory AppFlowState.dashboardReady() = _DashboardReady;
}
