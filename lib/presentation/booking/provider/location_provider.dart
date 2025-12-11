import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_model/location_notifier.dart';
import 'geo_location_providers.dart';

final locationNotifierProvider = StateNotifierProvider<LocationNotifier, void>((ref) {
  final geoManager = ref.read(geoLocationManagerProvider);
  return LocationNotifier(geoManager, ref);
});
