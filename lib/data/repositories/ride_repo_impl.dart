import 'package:dartz/dartz.dart' hide Order;
import 'package:gauva_driver/core/errors/failure.dart';
import 'package:gauva_driver/data/models/common_response.dart';
import 'package:gauva_driver/data/repositories/base_repository.dart';
import '../../domain/interfaces/ride_service_interface.dart';
import '../models/order_response/order_detail/order_detail_model.dart';
import '../models/order_response/order_model/order/order.dart';
import '../models/order_response/tip_model/trip_model.dart';
import 'interfaces/ride_repo_interface.dart';

class RideRepoImpl extends BaseRepository implements IRideRepo {
  final IRideService rideService;

  RideRepoImpl({required this.rideService});

  @override
  Future<Either<Failure, OrderDetailModel>> rideOrder({required int orderId, required String status}) async =>
      await safeApiCall(() async {
        final response = await rideService.rideOrder(orderId: orderId, status: status);
        try {
          return OrderDetailModel.fromJson(response.data);
        } catch (e) {
          return OrderDetailModel.fromJson(response.data);
        }
      });

  @override
  Future<Either<Failure, OrderDetailModel>> orderDetails({required int orderId}) async => await safeApiCall(() async {
    final response = await rideService.orderDetails(orderId: orderId);
    try {
      // Handle array response (HTML tool shows response can be an array)
      if (response.data is List && (response.data as List).isNotEmpty) {
        // Extract first element from array
        final firstElement = (response.data as List).first;
        return OrderDetailModel.fromJson(firstElement);
      }
      // Handle direct object response
      return OrderDetailModel.fromJson(response.data);
    } catch (e) {
      print('❌ Error parsing orderDetails response: $e');
      print('❌ Response data type: ${response.data.runtimeType}');
      print('❌ Response data: ${response.data}');
      // Try to handle array on error too
      if (response.data is List && (response.data as List).isNotEmpty) {
        final firstElement = (response.data as List).first;
        return OrderDetailModel.fromJson(firstElement);
      }
      return OrderDetailModel.fromJson(response.data);
    }
  });

  @override
  Future<Either<Failure, OrderDetailModel>> saveRideStatus({required int orderId, required String status}) async =>
      await safeApiCall(() async {
        final response = await rideService.saveRideStatus(orderId: orderId, status: status);
        try {
          return OrderDetailModel.fromJson(response.data);
        } catch (e) {
          return OrderDetailModel.fromJson(response.data);
        }
      });

  @override
  Future<Either<Failure, CommonResponse>> cancelRide({required int? orderId}) async => await safeApiCall(() async {
    final response = await rideService.cancelRide(orderId: orderId);
    return CommonResponse.fromJson(response.data);
  });

  @override
  Future<Either<Failure, TripModel>> checkActiveTrip() async => await safeApiCall(() async {
    final response = await rideService.checkActiveTrip();
    try {
      // Handle new API format: might return a list or single object
      final data = response.data;
      if (data is List && data.isNotEmpty) {
        // If it's a list, take the first ride and wrap it in the expected format
        return TripModel.fromJson({
          'message': 'Active trip found',
          'data': {
            'order': data[0], // First ride from the list
          },
        });
      } else if (data is Map) {
        // If it's already in the expected format
        return TripModel.fromJson(data);
      } else {
        // Fallback: return empty response
        return TripModel.fromJson({'message': 'No active trip', 'data': null});
      }
    } catch (e) {
      // Fallback to original parsing if new format fails
      return TripModel.fromJson(response.data);
    }
  });

  @override
  Future<Either<Failure, OrderDetailModel>> getCurrentRide({required int driverId}) async => await safeApiCall(() async {
    final response = await rideService.getCurrentRide(driverId: driverId);
    try {
      return OrderDetailModel.fromJson(response.data);
    } catch (e) {
      return OrderDetailModel.fromJson(response.data);
    }
  });

  @override
  Future<Either<Failure, List<Order>>> getStartedRides() async => await safeApiCall(() async {
    final response = await rideService.getStartedRides();
    try {
      final data = response.data;
      if (data is List) {
        return data.map((item) => Order.fromJson(item as Map<String, dynamic>)).toList();
      } else if (data is Map && data.containsKey('data') && data['data'] is List) {
        return (data['data'] as List).map((item) => Order.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        return <Order>[];
      }
    } catch (e) {
      return <Order>[];
    }
  });

  @override
  Future<Either<Failure, List<Order>>> getAllocatedRides() async => await safeApiCall(() async {
    final response = await rideService.getAllocatedRides();
    try {
      final data = response.data;
      if (data is List) {
        return data.map((item) => Order.fromJson(item as Map<String, dynamic>)).toList();
      } else if (data is Map && data.containsKey('data') && data['data'] is List) {
        return (data['data'] as List).map((item) => Order.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        return <Order>[];
      }
    } catch (e) {
      return <Order>[];
    }
  });

  @override
  Future<Either<Failure, List<Order>>> getCompletedRides() async => await safeApiCall(() async {
    final response = await rideService.getCompletedRides();
    try {
      final data = response.data;
      if (data is List) {
        return data.map((item) => Order.fromJson(item as Map<String, dynamic>)).toList();
      } else if (data is Map && data.containsKey('data') && data['data'] is List) {
        return (data['data'] as List).map((item) => Order.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        return <Order>[];
      }
    } catch (e) {
      return <Order>[];
    }
  });

  @override
  Future<Either<Failure, OrderDetailModel>> acceptRide({required int rideId, required int otp}) async =>
      await safeApiCall(() async {
        final response = await rideService.acceptRide(rideId: rideId, otp: otp);
        try {
          return OrderDetailModel.fromJson(response.data);
        } catch (e) {
          return OrderDetailModel.fromJson(response.data);
        }
      });

  @override
  Future<Either<Failure, CommonResponse>> declineRide({required int rideId}) async => await safeApiCall(() async {
    final response = await rideService.declineRide(rideId: rideId);
    return CommonResponse.fromJson(response.data);
  });

  @override
  Future<Either<Failure, OrderDetailModel>> startRide({required int rideId, required int otp}) async =>
      await safeApiCall(() async {
        final response = await rideService.startRide(rideId: rideId, otp: otp);
        try {
          return OrderDetailModel.fromJson(response.data);
        } catch (e) {
          return OrderDetailModel.fromJson(response.data);
        }
      });

  @override
  Future<Either<Failure, OrderDetailModel>> completeRide({required int rideId}) async => await safeApiCall(() async {
    final response = await rideService.completeRide(rideId: rideId);
    try {
      return OrderDetailModel.fromJson(response.data);
    } catch (e) {
      return OrderDetailModel.fromJson(response.data);
    }
  });

  @override
  Future<Either<Failure, OrderDetailModel>> getRideDetails({required int rideId}) async => await safeApiCall(() async {
    final response = await rideService.getRideDetails(rideId: rideId);
    try {
      return OrderDetailModel.fromJson(response.data);
    } catch (e) {
      return OrderDetailModel.fromJson(response.data);
    }
  });

  @override
  Future<Either<Failure, OrderDetailModel>> goToPickup({required int orderId}) async => await safeApiCall(() async {
    final response = await rideService.goToPickup(orderId: orderId);
    try {
      return OrderDetailModel.fromJson(response.data);
    } catch (e) {
      return OrderDetailModel.fromJson(response.data);
    }
  });
}
