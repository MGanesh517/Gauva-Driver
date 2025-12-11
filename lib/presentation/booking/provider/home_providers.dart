import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_model/booking_notifier.dart';
import 'geo_location_providers.dart';

final bookingNotifierProvider = StateNotifierProvider<BookingNotifier, BookingState>(
    (ref) => BookingNotifier(ref.read(geoLocationManagerProvider), ref,));
