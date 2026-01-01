import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:gauva_driver/core/widgets/markers/app_marker_drop_off.dart';
import 'package:gauva_driver/data/models/order_response/order_model/points/points.dart';
import 'package:gauva_driver/data/repositories/interfaces/i_geo_location_manager.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import 'package:widget_to_marker/widget_to_marker.dart';
import 'package:geocoding/geocoding.dart';

import '../../../core/enums/booking_status.dart';
import '../../../core/enums/driver_status.dart';
import '../../../core/enums/movements.dart';
import '../../../core/widgets/markers/app_marker_pickup.dart';
import '../provider/driver_providers.dart';
import '../provider/location_provider.dart';
import '../provider/pusher_provider.dart';
import '../provider/ride_providers.dart';
import '../provider/way_point_list_provider.dart';

class BookingState {
  final GoogleMapController? mapController;
  final LatLng? currentLocation;
  final bool isOnline;
  final int radius;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Set<Circle> circles;
  final bool hasAnimatedCamera;
  final String? address;
  final bool hasReachedDestination;

  BookingState({
    required this.mapController,
    required this.currentLocation,
    required this.isOnline,
    required this.radius,
    required this.polylines,
    required this.markers,
    required this.circles,
    required this.hasAnimatedCamera,
    this.address,
    required this.hasReachedDestination,
  });

  BookingState copyWith({
    GoogleMapController? mapController,
    LatLng? currentLocation,
    bool? isOnline,
    int? radius,
    Set<Polyline>? polylines,
    Set<Marker>? markers,
    Set<Circle>? circles,
    bool? hasAnimatedCamera,
    String? address,
    bool? hasReachedDestination,
  }) => BookingState(
    mapController: mapController ?? this.mapController,
    currentLocation: currentLocation ?? this.currentLocation,
    isOnline: isOnline ?? this.isOnline,
    radius: radius ?? this.radius,
    polylines: polylines ?? this.polylines,
    markers: markers ?? this.markers,
    circles: circles ?? this.circles,
    hasAnimatedCamera: hasAnimatedCamera ?? this.hasAnimatedCamera,
    address: address ?? this.address,
    hasReachedDestination: hasReachedDestination ?? this.hasReachedDestination,
  );

  BookingState.empty()
    : this(
        mapController: null,
        currentLocation: null,
        isOnline: false,
        radius: 0,
        polylines: {},
        markers: {},
        circles: {},
        hasAnimatedCamera: false,
        address: null,
        hasReachedDestination: false,
      );
}

class BookingNotifier extends StateNotifier<BookingState> {
  final Ref ref;
  final IGeoLocationManager geoLocationManager;
  bool _isDisposed = false;

  BookingNotifier(this.geoLocationManager, this.ref, {GoogleMapController? controller}) : super(BookingState.empty()) {
    initialize();
  }

  // Size markerSize = const Size(700, 400);
  MarkerId carMarkerId = const MarkerId('car');
  MarkerId pickupMarkerId = const MarkerId('pick-up');
  MarkerId dropMarkerId = const MarkerId('Drop-off point');
  MarkerId circleMarkerId = const MarkerId('circle');

  final local = LocalStorageService();
  void setMapController(GoogleMapController controller) {
    state = state.copyWith(mapController: controller);
  }

  /// Initialize user location and set marker
  Future<void> initialize() async {
    _isDisposed = false; // Reset disposed flag on initialization
    final LatLng? location = await geoLocationManager.getUserLocation();

    final markerIcon = await getMarkerIcon();
    if (location != null) {
      final userData = await LocalStorageService().getSavedUser();
      state = state.copyWith(
        currentLocation: location,
        isOnline: isOnline(userData?.driverStatus?.toLowerCase()),
        radius: getRadiusInKm(userData?.radiusInMeter),
        polylines: {},
        markers: {Marker(markerId: carMarkerId, position: location, icon: markerIcon)},
        circles: {
          Circle(
            circleId: const CircleId('radius'),
            center: location,
            radius: getRadiusInKm(userData?.radiusInMeter) * 1000,
            fillColor: Colors.blue.withValues(alpha: 0.1),
            strokeColor: Colors.blue.withValues(alpha: 0.3),
            strokeWidth: 2,
          ),
        },
      );
      await _getAddressFromLatLng(location);
    }
    ref.read(driverStatusNotifierProvider.notifier).initialize();
  }

  Future<void> _getAddressFromLatLng(LatLng location) async {
    try {
      final placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        final String address = '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';

        state = state.copyWith(address: address);
      }
    } catch (e) {
      if (true) {}
    }
  }

  Future<void> updateLocationMarker(LatLng? location) async {
    if (location != null) {
      state = state.copyWith(currentLocation: location);
      state = state.copyWith(
        markers: state.markers.map((marker) {
          if (marker.markerId.value == carMarkerId.value) {
            return marker.copyWith(positionParam: location);
          }
          return marker;
        }).toSet(),
      );
    }
  }

  Future<void> incrementRadius({required GoogleMapController? controller}) async {
    state = state.copyWith(radius: state.radius + 1);
    await ref.read(driverRadiusNotifierProvider.notifier).updateRadius(state.radius * 1000);
    ref
        .read(driverRadiusNotifierProvider)
        .maybeWhen(
          orElse: () {
            state = state.copyWith(radius: state.radius - 1);
          },
          success: (data) async {
            await updateRadius();
          },
        );
  }

  Future<void> decrementRadius({required GoogleMapController? controller}) async {
    if (state.radius == 1) return;
    state = state.copyWith(radius: state.radius > 1 ? state.radius - 1 : state.radius);
    await ref.read(driverRadiusNotifierProvider.notifier).updateRadius(state.radius * 1000);
    ref
        .read(driverRadiusNotifierProvider)
        .maybeWhen(
          orElse: () {
            state = state.copyWith(radius: state.radius + 1);
          },
          success: (data) async {
            await updateRadius();
          },
        );
  }

  Future<void> updateRadius() async {
    state = state.copyWith(
      circles: {
        Circle(
          circleId: const CircleId('radius'),
          center: state.currentLocation!,
          radius: state.radius * 1000,
          fillColor: Colors.blue.withValues(alpha: 0.1),
          strokeColor: Colors.blue.withValues(alpha: 0.3),
          strokeWidth: 2,
        ),
      },
    );

    if (state.mapController != null && state.currentLocation != null) {
      try {
        await state.mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(state.currentLocation!, getZoomLevel(state.radius * 1000)),
        );
      } catch (e) {
        print('⚠️ Error updating radius map zoom: $e');
        // Map controller might be disposed or channel disconnected
      }
    }
  }

  Future<void> updateMapZoom({LatLng? location}) async {
    if (state.currentLocation == null) {
      await initialize();
    }
    if (state.mapController != null && (location != null || state.currentLocation != null)) {
      try {
        await state.mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(location ?? state.currentLocation!, location == null ? 13 : 15.5),
        );
      } catch (e) {
        print('⚠️ Error updating map zoom: $e');
        // Map controller might be disposed or channel disconnected
      }
    }
  }

  Future<void> mapZoomForPickedUp({required GoogleMapController? controller}) async {
    if (controller != null && state.currentLocation != null) {
      try {
        await controller.animateCamera(CameraUpdate.newLatLngZoom(state.currentLocation!, 16));
      } catch (e) {
        print('⚠️ Error zooming for pickup: $e');
        // Map controller might be disposed or channel disconnected
      }
    }
  }

  Future<void> resetMapZoom() async {
    if (state.mapController != null && state.currentLocation != null) {
      try {
        await state.mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(state.currentLocation!, getZoomLevel(state.radius * 1000)),
        );
      } catch (e) {
        print('⚠️ Error resetting map zoom: $e');
        // Map controller might be disposed or channel disconnected
        // Silently fail to avoid crashing the app
      }
    }
  }

  Future<Uint8List> createCircle() async {
    final size = 30;
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final center = Offset(size / 2, size / 2);

    canvas
      ..drawCircle(center, size / 2, Paint()..color = Colors.white)
      ..drawCircle(center, size / 2 - 4, Paint()..color = ColorPalette.primary50);

    final img = await recorder.endRecording().toImage(size, size);
    final byteData = await img.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<BitmapDescriptor> getMarkerIcon() async {
    final userData = await LocalStorageService().getSavedUser();
    String assetPath = 'assets/images/car-top-view.png'; // Default to car

    if (userData?.serviceType != null) {
      final type = userData!.serviceType!.toUpperCase();
      if (type == 'BIKE' || type == 'TWO_WHEELER') {
        assetPath = 'assets/images/bike.png';
      } else if (type == 'AUTO' || type == 'THREE_WHEELER') {
        assetPath = 'assets/images/auto.png';
      } else if (type == 'CAR' || type == 'SMALL_SEDAN' || type == 'SEDAN' || type == 'FOUR_WHEELER') {
        assetPath = 'assets/images/car-top-view.png';
      } else if (type == 'MEGA' || type == 'SUV') {
        assetPath = 'assets/images/car-top-view.png'; // Using car image for SUV/MEGA as well
      }
    }

    print('🚗 Using marker icon: $assetPath for service type: ${userData?.serviceType}');
    return await BitmapDescriptor.asset(const ImageConfiguration(size: Size(44, 44)), assetPath);
  }

  Future<BitmapDescriptor> getPickupMarkerIcon({required String address}) async =>
      await AppMarkerPickup(address: address).toBitmapDescriptor(imageSize: const Size(700, 600));

  Future<BitmapDescriptor> getDestinationMarkerIcon({required String address}) async =>
      await AppMarkerDropOff(address: address).toBitmapDescriptor(imageSize: const Size(700, 600));

  void updatePolyLines(Set<Polyline> polyLines) {
    state = state.copyWith(polylines: {});
    state = state.copyWith(polylines: polyLines);
  }

  Future<void> updateMarkerForOrder({required MovementMode mode}) async {
    updateMarkers(mode);
  }

  void _fitBoundsToPickupAndDropOff(LatLng pickup, LatLng dropOff) {
    final southwest = LatLng(
      pickup.latitude < dropOff.latitude ? pickup.latitude : dropOff.latitude,
      pickup.longitude < dropOff.longitude ? pickup.longitude : dropOff.longitude,
    );
    final northeast = LatLng(
      pickup.latitude > dropOff.latitude ? pickup.latitude : dropOff.latitude,
      pickup.longitude > dropOff.longitude ? pickup.longitude : dropOff.longitude,
    );

    final bounds = LatLngBounds(southwest: southwest, northeast: northeast);

    if (state.mapController != null) {
      // Animate camera to fit bounds with padding
      Future.delayed(const Duration(milliseconds: 300), () async {
        try {
          await state.mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
        } catch (e) {
          print('⚠️ Error fitting bounds: $e');
          // Map controller might be disposed or channel disconnected
        }
      });
    }
  }

  Future<void> updateMarkerForTowardsPickup() async {
    updateMarkerForOrder(mode: MovementMode.towardsPickup);
    if (state.mapController != null) {
      try {
        await state.mapController?.animateCamera(CameraUpdate.zoomIn());
      } catch (e) {
        print('⚠️ Error zooming in towards pickup: $e');
        // Map controller might be disposed or channel disconnected
      }
    }
    await startLocationStream(mode: MovementMode.towardsPickup);
  }

  Future<void> updateMarkerForTowardsDestination() async {
    updateMarkerForOrder(mode: MovementMode.towardsDestination);
    if (state.mapController != null) {
      try {
        await state.mapController?.animateCamera(CameraUpdate.zoomIn());
      } catch (e) {
        print('⚠️ Error zooming in towards destination: $e');
        // Map controller might be disposed or channel disconnected
      }
    }
    await startLocationStream(mode: MovementMode.towardsDestination);
  }

  bool shouldUpdateMarker(MarkerId id, LatLng? newPos) {
    if (newPos == null) return false;
    if (state.markers.isEmpty || state.markers.length == 1) return true;
    try {
      final existing = state.markers.firstWhere((m) => m.markerId == id);
      // Marker exists → check position
      return existing.position != newPos;
    } catch (_) {
      // Marker doesn't exist → needs update
      return true;
    }
  }

  LatLng? listToLatLng(List<num>? coordinates) {
    if (coordinates == null || coordinates.length != 2) return null;

    final lat = coordinates[0].toDouble();
    final lng = coordinates[1].toDouble();

    return LatLng(lat, lng);
  }

  Future<LatLng?> setCurrentLocation() async {
    if (state.currentLocation != null) {
      return state.currentLocation!;
    } else {
      final LatLng? location = await geoLocationManager.getUserLocation();
      if (location != null) {
        final markerIcon = await getMarkerIcon();
        state = state.copyWith(
          currentLocation: location,
          markers: {Marker(markerId: carMarkerId, position: location, icon: markerIcon)},
        );
        return location;
      }
      return null;
    }
  }

  Future<void> updateMarkers(MovementMode? mode) async {
    await setCurrentLocation(); // this is used for when user close the app and return the app and there is need for location permission

    ref
        .read(rideOrderNotifierProvider)
        .maybeWhen(
          orElse: () {},
          success: (data) async {
            final LatLng? pickupPos = listToLatLng(data?.points?.pickupLocation);
            final LatLng? dropPos = listToLatLng(data?.points?.dropLocation);

            if (shouldUpdateMarker(pickupMarkerId, pickupPos)) {
              final circleIcon = BitmapDescriptor.bytes(await createCircle());
              await getPickupMarkerIcon(address: data?.addresses?.pickupAddress ?? '').then((value) {
                final updatedMarkers = {...state.markers}
                  ..removeWhere((m) => m.markerId == pickupMarkerId)
                  ..add(Marker(markerId: pickupMarkerId, position: pickupPos!, icon: value))
                  ..removeWhere((m) => m.markerId == circleMarkerId)
                  ..add(Marker(markerId: circleMarkerId, position: pickupPos, icon: circleIcon));
                state = state.copyWith(markers: updatedMarkers);
              });
            }

            if (shouldUpdateMarker(dropMarkerId, dropPos)) {
              await getDestinationMarkerIcon(address: data?.addresses?.dropAddress ?? '').then((value) {
                final updatedMarkers = {...state.markers}
                  ..removeWhere((m) => m.markerId == dropMarkerId)
                  ..add(Marker(markerId: dropMarkerId, position: dropPos!, icon: value));
                state = state.copyWith(markers: updatedMarkers);
              });
            }

            if (mode != null) {
              switch (mode) {
                case MovementMode.orderAccept:
                  // Check if required locations are not null
                  final currentLoc = state.currentLocation;
                  final pickup = pickupPos;
                  final drop = dropPos;

                  if (currentLoc == null || pickup == null || drop == null) {
                    print('⚠️ BookingNotifier: Cannot update route (orderAccept) - missing location data');
                    print('⚠️ currentLocation: $currentLoc, pickupPos: $pickup, dropPos: $drop');
                    break;
                  }

                  await ref
                      .read(routeNotifierProvider.notifier)
                      .fetchRoutesDetail(
                        Points(
                          pickupLocation: [currentLoc.latitude, currentLoc.longitude],
                          dropLocation: [pickup.latitude, pickup.longitude],
                        ),
                      );
                  _fitBoundsToPickupAndDropOff(pickup, drop);
                  break;

                case MovementMode.towardsPickup:
                  // Check if currentLocation and pickupPos are not null before using
                  final currentLoc = state.currentLocation;
                  final pickup = pickupPos;

                  if (currentLoc == null || pickup == null) {
                    print(
                      '⚠️ BookingNotifier: Cannot update route (towardsPickup) - currentLocation or pickupPos is null',
                    );
                    print('⚠️ currentLocation: $currentLoc');
                    print('⚠️ pickupPos: $pickup');
                    break;
                  }

                  await ref
                      .read(routeNotifierProvider.notifier)
                      .fetchRoutesDetail(
                        Points(
                          pickupLocation: [currentLoc.latitude, currentLoc.longitude],
                          dropLocation: [pickup.latitude, pickup.longitude],
                        ),
                      );
                  _fitBoundsToPickupAndDropOff(currentLoc, pickup);

                  break;

                case MovementMode.towardsDestination:
                  // Check if currentLocation and dropPos are not null before using
                  final currentLoc = state.currentLocation;
                  final drop = dropPos;

                  if (currentLoc == null || drop == null) {
                    print(
                      '⚠️ BookingNotifier: Cannot update route (towardsDestination) - currentLocation or dropPos is null',
                    );
                    print('⚠️ currentLocation: $currentLoc');
                    print('⚠️ dropPos: $drop');
                    break;
                  }

                  await ref
                      .read(routeNotifierProvider.notifier)
                      .fetchRoutesDetail(
                        Points(
                          pickupLocation: [currentLoc.latitude, currentLoc.longitude],
                          dropLocation: [drop.latitude, drop.longitude],
                        ),
                      );
                  _fitBoundsToPickupAndDropOff(currentLoc, drop);
                  break;
              }
            }
          },
        );
  }

  Future<void> resetMarker() async {
    final markerIcon = await getMarkerIcon();
    state = state.copyWith(
      markers: {
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: state.currentLocation ?? const LatLng(0, 0),
          icon: markerIcon,
        ),
      },
    );
  }

  Future<void> resetPolyLines() async {
    state = state.copyWith(polylines: {});
  }

  void resetToInitial({bool enablePusher = true}) {
    _isDisposed = false; // Reset disposed flag when reinitializing
    state = state.copyWith(hasAnimatedCamera: false);
    initialize();
    ref.read(ontripStatusNotifier.notifier).resetState();
    ref.read(driverStatusNotifierProvider.notifier).initialize();
    stopLocationUpdates(setPolyLineEmpty: true);
    if (enablePusher) {
      Future.delayed(const Duration(milliseconds: 500)).then((_) {
        ref.read(pusherNotifierProvider.notifier).setupPusherListeners();
      });
    }
  }

  Future<void> resetState() async {
    _isDisposed = true;
    state.mapController?.dispose();
    state = BookingState.empty();
  }

  @override
  void dispose() {
    _isDisposed = true;
    state.mapController?.dispose();
    super.dispose();
  }

  double getZoomLevel(int radius) {
    if (radius <= 1000) return 14;
    if (radius <= 2000) return 13;
    if (radius <= 5000) return 12;
    if (radius <= 10000) return 11;
    return 10;
  }

  bool isOnline(String? status) {
    if (status == null) return false;
    if (status == DriverStatus.online.name) {
      ref.read(locationNotifierProvider.notifier).startTracking();
      return true;
    }
    return false;
  }

  int getRadiusInKm(String? radiusInMeters) {
    final int radius = int.parse(radiusInMeters ?? '0');
    return radius ~/ 1000;
  }

  Future<void> startLocationStream({required MovementMode mode}) async {
    try {
      ref.read(locationNotifierProvider.notifier).enableOnUpdateCallback();

      final points = ref.watch(rideOrderNotifierProvider).maybeWhen(success: (data) => data?.points, orElse: () => null);

      final orderId = ref.watch(rideOrderNotifierProvider).maybeWhen(success: (data) => data?.id, orElse: () => null);

      final LatLng? pickupLatLng = listToLatLng(points?.pickupLocation);
      final LatLng? dropLatLng = listToLatLng(points?.dropLocation);

      final LatLng? targetLatLng = mode == MovementMode.towardsPickup ? pickupLatLng : dropLatLng;

      ref
          .read(locationNotifierProvider.notifier)
          .startTracking(
            onUpdate: (location) async {
              // Check if notifier is disposed before accessing state
              if (_isDisposed) {
                print('⚠️ BookingNotifier: Ignoring location update - notifier is disposed');
                return;
              }

              if (mode == MovementMode.towardsDestination) {
                final double distance = _calculateDistance(
                  location.latitude,
                  location.longitude,
                  dropLatLng?.latitude ?? 0,
                  dropLatLng?.longitude ?? 0,
                );
                if (distance <= 50) {
                  if (!_isDisposed) {
                    ref.read(ontripStatusNotifier.notifier).updateOnTripStatus(status: BookingStatus.reachedDestination);
                  }
                }
              }

              if (_isDisposed) return;

              await ref
                  .read(routeNotifierProvider.notifier)
                  .fetchRoutesDetail(
                    Points(
                      pickupLocation: [location.latitude, location.longitude],
                      dropLocation: [targetLatLng?.latitude ?? 0, targetLatLng?.longitude ?? 0],
                    ),
                    sendDataToRider: mode == MovementMode.towardsDestination,
                    pickUpPoint: pickupLatLng,
                    orderId: orderId,
                  );

              // Check again before accessing state
              if (_isDisposed) return;

              // Check again before accessing state
              if (_isDisposed) return;

              // Update marker rotation based on closest segment
              double bearing = 0;
              final polylinePoints = state.polylines.isNotEmpty ? state.polylines.first.points : [];
              for (int i = 0; i < polylinePoints.length - 1; i++) {
                final point = polylinePoints[i];
                final nextPoint = polylinePoints[i + 1];
                if (_isPointNearSegment(location, point, nextPoint)) {
                  bearing = _calculateBearing(point, nextPoint);
                  break;
                }
              }

              // Final check before accessing mapController
              if (_isDisposed) return;

              if (state.mapController != null) {
                try {
                  await state.mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(target: location, zoom: 18.0, bearing: bearing)),
                  );
                } catch (e) {
                  print('⚠️ Error animating camera during location update: $e');
                  // Map controller might be disposed or channel disconnected
                }
              }
            },
          );
    } catch (e) {
      if (true) {}
    }
  }

  void stopLocationUpdates({bool setPolyLineEmpty = false}) {
    ref.read(locationNotifierProvider.notifier).disableOnUpdateCallback();

    if (setPolyLineEmpty) {
      state = state.copyWith(polylines: {});
    }
  }

  /// Helper: Calculate distance between two points in meters
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000; // meters
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) => degrees * pi / 180;

  /// Helper: Calculate bearing between two LatLng points
  double _calculateBearing(LatLng from, LatLng to) {
    final lat1 = _degreesToRadians(from.latitude);
    final lon1 = _degreesToRadians(from.longitude);
    final lat2 = _degreesToRadians(to.latitude);
    final lon2 = _degreesToRadians(to.longitude);

    final dLon = lon2 - lon1;
    final y = sin(dLon) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    final bearing = atan2(y, x) * 180 / pi;

    return (bearing + 360) % 360;
  }

  /// Helper: Check if current location is near segment between points a and b
  bool _isPointNearSegment(LatLng current, LatLng a, LatLng b) {
    const threshold = 30.0; // meters

    final distanceToA = _calculateDistance(current.latitude, current.longitude, a.latitude, a.longitude);
    final distanceToB = _calculateDistance(current.latitude, current.longitude, b.latitude, b.longitude);
    final segmentLength = _calculateDistance(a.latitude, a.longitude, b.latitude, b.longitude);

    return (distanceToA + distanceToB - segmentLength).abs() < threshold;
  }
}
