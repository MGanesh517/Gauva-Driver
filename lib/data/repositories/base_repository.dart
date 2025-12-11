import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/api_error_handler.dart';
import '../../core/errors/failure.dart';
import '../../generated/l10n.dart';

abstract class BaseRepository {
  // Handle API calls and maps response to [Either].
  Future<Either<Failure, T>> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      // Step 1: Check internet connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasInternet = connectivityResult.contains(ConnectivityResult.mobile) || connectivityResult.contains(ConnectivityResult.wifi) || connectivityResult.contains(ConnectivityResult.ethernet);

      if (!hasInternet) {

        return Left(Failure(message: AppLocalizations().no_internet_connection));
      }

      // Step 2: Perform the API call
      final result = await apiCall();

      return Right(result);
    } on DioException catch (dioError) {
      final failure = ApiErrorHandler.handleDioError(error: dioError);
      return Left(failure);
    } on TimeoutException {
      return Left(Failure(message: AppLocalizations().request_timed_out_please_try_again));
    } catch (error) {
      return Left(Failure(message: AppLocalizations().something_went_wrong));
    }
  }
}
