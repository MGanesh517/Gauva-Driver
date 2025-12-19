import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/environment.dart';
import '../services/local_storage_service.dart';
import '../models/intercity/booking_model.dart';
import '../models/intercity/trip_model.dart';
import '../models/intercity/intercity_route_model.dart';
import '../models/intercity/intercity_service_type_model.dart';
import 'interfaces/intercity_repository_interface.dart';

class IntercityRepositoryImpl implements IntercityRepository {
  final http.Client client;
  final String baseUrl;

  IntercityRepositoryImpl({required this.client, String? baseUrl}) : baseUrl = baseUrl ?? Environment.baseUrl;

  Future<Map<String, String>> _getHeaders() async {
    String? token = await LocalStorageService().getToken();
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
  }

  @override
  Future<List<TripModel>> getMyTrips() async {
    final headers = await _getHeaders();
    final response = await client.get(Uri.parse('$baseUrl/api/driver/intercity/trips'), headers: headers);
    print('GET /trips Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> trips = data is List ? data : (data['content'] ?? data['trips'] ?? []);
      return trips.map((e) => TripModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load trips: ${response.statusCode}');
    }
  }

  @override
  Future<List<BookingModel>> getPendingBookings() async {
    final headers = await _getHeaders();
    final response = await client.get(Uri.parse('$baseUrl/api/driver/intercity/bookings/pending'), headers: headers);
    print('GET /bookings/pending Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> bookings = data is List ? data : (data['content'] ?? data['bookings'] ?? []);
      return bookings.map((e) => BookingModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load pending bookings: ${response.statusCode}');
    }
  }

  @override
  Future<List<BookingModel>> getTripBookings(int tripId) async {
    final headers = await _getHeaders();
    final response = await client.get(
      Uri.parse('$baseUrl/api/driver/intercity/trips/$tripId/bookings'),
      headers: headers,
    );
    print('GET /trips/$tripId/bookings Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> bookings = jsonDecode(response.body);
      return bookings.map((e) => BookingModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load trip bookings: ${response.statusCode}');
    }
  }

  @override
  Future<void> acceptBooking(int bookingId) async {
    final headers = await _getHeaders();
    final response = await client.post(
      Uri.parse('$baseUrl/api/driver/intercity/bookings/$bookingId/accept'),
      headers: headers,
    );
    print('POST /bookings/$bookingId/accept Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to accept booking: ${response.body}');
    }
  }

  @override
  Future<void> rejectBooking(int bookingId, String reason) async {
    final headers = await _getHeaders();
    final response = await client.post(
      Uri.parse('$baseUrl/api/driver/intercity/bookings/$bookingId/reject'),
      headers: headers,
      body: jsonEncode({'reason': reason}),
    );
    print('POST /bookings/$bookingId/reject Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to reject booking: ${response.body}');
    }
  }

  @override
  Future<void> publishTrip(Map<String, dynamic> tripData) async {
    final headers = await _getHeaders();
    final response = await client.post(
      Uri.parse('$baseUrl/api/driver/intercity/publish'),
      headers: headers,
      body: jsonEncode(tripData),
    );
    print('POST /publish Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to publish trip: ${response.body}');
    }
  }

  @override
  Future<void> startTrip(int tripId) async {
    final headers = await _getHeaders();
    final response = await client.post(Uri.parse('$baseUrl/api/driver/intercity/trips/$tripId/start'), headers: headers);
    print('POST /trips/$tripId/start Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to start trip: ${response.body}');
    }
  }

  @override
  Future<void> completeTrip(int tripId) async {
    final headers = await _getHeaders();
    final response = await client.post(
      Uri.parse('$baseUrl/api/driver/intercity/trips/$tripId/complete'),
      headers: headers,
    );
    print('POST /trips/$tripId/complete Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to complete trip: ${response.body}');
    }
  }

  @override
  Future<List<IntercityRouteModel>> getRoutes({String? origin, String? destination}) async {
    // Construct endpoint based on filters
    String endpoint = '$baseUrl/api/customer/intercity/services';
    if (origin != null && origin.isNotEmpty) {
      endpoint = '$baseUrl/api/customer/intercity/services/origin/${Uri.encodeComponent(origin)}';
    } else if (destination != null && destination.isNotEmpty) {
      endpoint = '$baseUrl/api/customer/intercity/services/destination/${Uri.encodeComponent(destination)}';
    }

    // Customer endpoints are usually public, but we can send auth if available or just skip headers if public.
    // HTML tool calls them without auth headers. Let's try without headers for customer APIs.
    final response = await client.get(Uri.parse(endpoint));
    print('GET Routes ($endpoint) Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => IntercityRouteModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load routes: ${response.statusCode}');
    }
  }

  @override
  Future<List<IntercityServiceType>> getServiceTypes() async {
    final response = await client.get(Uri.parse('$baseUrl/api/customer/intercity/service-types'));
    print('GET Service Types Response: ${response.statusCode} - ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list.map((e) => IntercityServiceType.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load service types: ${response.statusCode}');
    }
  }

  @override
  Future<void> verifyOtp(int bookingId, int otp) async {
    final headers = await _getHeaders();
    final body = jsonEncode({'bookingId': bookingId, 'otp': otp});

    final response = await client.post(
      Uri.parse('$baseUrl/api/driver/intercity/verify-otp'),
      headers: headers,
      body: body,
    );
    print('POST /verify-otp Response: ${response.statusCode} - ${response.body}');

    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to verify OTP');
    }
  }
}
