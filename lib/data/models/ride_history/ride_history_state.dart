import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideHistoryState {
  final Set<Marker> markers;
  final Set<Polyline> polyLines;
  // final bool isLoading;

  RideHistoryState({
    required this.markers,
    required this.polyLines,
    // required this.isLoading,
  });

  // 🧩 copyWith method
  RideHistoryState copyWith({
    Set<Marker>? markers,
    Set<Polyline>? polyLines,
    bool? isLoading,
  }) => RideHistoryState(
      markers: markers ?? this.markers,
      polyLines: polyLines ?? this.polyLines,
      // isLoading: isLoading ?? this.isLoading,
    );

  // 🔄 empty factory constructor
  factory RideHistoryState.empty() => RideHistoryState(
      markers: {},
      polyLines: {},
      // isLoading: false
    );
}
