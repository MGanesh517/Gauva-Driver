import 'package:dartz/dartz.dart';

import '../../core/errors/failure.dart';
import '../../domain/interfaces/ride_history_service_interface.dart';
import '../models/ride_history_response/ride_history_model.dart';
import 'base_repository.dart';
import 'interfaces/ride_history_repo_interface.dart';

class RideHistoryRepoImpl extends BaseRepository implements IRideHistoryRepo {
  final IRideHistoryService rideHistoryService;

  RideHistoryRepoImpl({required this.rideHistoryService});

  @override
  Future<Either<Failure, RideHistoryModel>> getRideHistory({String? status, String? date}) async => await safeApiCall(()async{
      final response = await rideHistoryService.getRideHistory(status: status, date: date);
      try {
        return RideHistoryModel.fromJson(response.data);
      } catch (e) {
        throw Exception('Parsing error');
      }

    });}