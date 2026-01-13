import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/api_error_handler.dart';
import '../../core/errors/failure.dart';
import '../../generated/l10n.dart';

abstract class BaseRepository {
  // REMOVED: Connectivity check adds 200-500ms delay per request
  // Let Dio handle connection errors directly - it's faster and more reliable
  // Postman doesn't check connectivity, it just makes the request - we should do the same

  // Handle API calls and maps response to [Either].
  Future<Either<Failure, T>> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      // Directly perform the API call - let Dio handle connection errors
      // This eliminates 200-500ms overhead from connectivity checks
      final result = await apiCall();
      return Right(result);
    } on DioException catch (dioError) {
      // Handle connection errors with user-friendly messages
      if (dioError.type == DioExceptionType.connectionError ||
          dioError.type == DioExceptionType.connectionTimeout ||
          dioError.type == DioExceptionType.receiveTimeout ||
          dioError.type == DioExceptionType.sendTimeout) {
        // Return user-friendly error for connection issues
        if (dioError.type == DioExceptionType.connectionError) {
          return Left(Failure(message: AppLocalizations().no_internet_connection));
        }
        if (dioError.type == DioExceptionType.connectionTimeout ||
            dioError.type == DioExceptionType.receiveTimeout ||
            dioError.type == DioExceptionType.sendTimeout) {
          return Left(Failure(message: AppLocalizations().request_timed_out_please_try_again));
        }
      }
      
      final failure = ApiErrorHandler.handleDioError(error: dioError);
      return Left(failure);
    } on TimeoutException {
      return Left(Failure(message: AppLocalizations().request_timed_out_please_try_again));
    } catch (error) {
      return Left(Failure(message: AppLocalizations().something_went_wrong));
    }
  }

}
