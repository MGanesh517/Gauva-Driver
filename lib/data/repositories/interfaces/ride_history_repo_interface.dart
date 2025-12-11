import 'package:dartz/dartz.dart';
import 'package:gauva_driver/data/models/ride_history_response/ride_history_model.dart';
import '../../../core/errors/failure.dart';

abstract class IRideHistoryRepo {
  Future<Either<Failure, RideHistoryModel>> getRideHistory({String? status, String? date});
}
