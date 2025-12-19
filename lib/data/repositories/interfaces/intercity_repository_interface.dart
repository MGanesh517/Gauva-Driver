import '../../models/intercity/booking_model.dart';
import '../../models/intercity/trip_model.dart';
import '../../models/intercity/intercity_route_model.dart';
import '../../models/intercity/intercity_service_type_model.dart';

abstract class IntercityRepository {
  Future<List<TripModel>> getMyTrips();
  Future<List<BookingModel>> getPendingBookings();
  Future<List<BookingModel>> getTripBookings(int tripId);
  Future<void> acceptBooking(int bookingId);
  Future<void> rejectBooking(int bookingId, String reason);
  Future<void> publishTrip(Map<String, dynamic> tripData);
  Future<void> startTrip(int tripId);
  Future<void> completeTrip(int tripId);
  Future<List<IntercityRouteModel>> getRoutes({String? origin, String? destination});
  Future<List<IntercityServiceType>> getServiceTypes();
  Future<void> verifyOtp(int bookingId, int otp);
}
