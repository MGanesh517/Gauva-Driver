import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/geo_location_manager.dart';
import '../../../data/repositories/interfaces/i_geo_location_manager.dart';

final geoLocationManagerProvider = Provider<IGeoLocationManager>((ref) => GeoLocationManager());
