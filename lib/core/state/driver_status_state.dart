import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_status_state.freezed.dart';

@freezed
class DriverStatusState<T> with _$DriverStatusState<T> {
  const factory DriverStatusState.initial() = _Initial<T>;
  factory DriverStatusState.loading() = _Loading<T>;
  const factory DriverStatusState.online() = _Online<T>;
  const factory DriverStatusState.offline() = _Offline<T>;
  const factory DriverStatusState.onTrip() = _OnTrip<T>;
  const factory DriverStatusState.orderRequest(T data) = _OrderRequest<T>;
}
