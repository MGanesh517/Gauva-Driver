import 'package:freezed_annotation/freezed_annotation.dart';

part 'on_trip_status.freezed.dart';

@freezed
class OnTripStatusState<T> with _$OnTripStatusState<T> {

  const factory OnTripStatusState.initial() = _Initial<T>;
  /// After trip is confirmed and driver accepts the request
  const factory OnTripStatusState.goForPickup() = _GoForPickup<T>;
  /// Driver has reached the pickup point
  const factory OnTripStatusState.arrivedAtPickupPoint() = _ArrivedAtPickupPoint<T>;
  /// Rider is picked up but not yet started the ride
  const factory OnTripStatusState.pickupConfirmed() = _PickupConfirmed<T>;
  /// Ride has officially started
  const factory OnTripStatusState.rideStarted() = _RideStarted<T>;
  /// Driver is en route to the destination
  const factory OnTripStatusState.headingToDestination() = _HeadingToDestination<T>;
  /// Driver reached the destination
  const factory OnTripStatusState.reachedDestination() = _ReachedDestination<T>;
  /// Show chat panel during trip
  const factory OnTripStatusState.chat() = _Chat<T>;
  /// Payment step after trip completion
  const factory OnTripStatusState.payment() = _Payment<T>;
}
