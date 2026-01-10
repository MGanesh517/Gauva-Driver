import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/errors/api_error_handler.dart';
import '../../core/errors/failure.dart';
import '../../generated/l10n.dart';

abstract class BaseRepository {
  // Cache connectivity check to avoid 200-500ms delay on every API call
  static bool? _cachedConnectivityStatus;
  static DateTime? _lastConnectivityCheck;
  static const _connectivityCacheDuration = Duration(seconds: 5);
  
  // Connectivity instance (reuse same instance)
  static final Connectivity _connectivity = Connectivity();

  // Handle API calls and maps response to [Either].
  Future<Either<Failure, T>> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      // OPTIMIZED: Only check connectivity if cache expired (saves 200-500ms per request)
      // If we have a recent connectivity check and it was successful, skip the check
      final now = DateTime.now();
      final shouldCheckConnectivity = _lastConnectivityCheck == null ||
          now.difference(_lastConnectivityCheck!) > _connectivityCacheDuration ||
          _cachedConnectivityStatus != true;

      if (shouldCheckConnectivity) {
        try {
          final connectivityResult = await _connectivity.checkConnectivity();
          _cachedConnectivityStatus = connectivityResult.contains(ConnectivityResult.mobile) ||
              connectivityResult.contains(ConnectivityResult.wifi) ||
              connectivityResult.contains(ConnectivityResult.ethernet);
          _lastConnectivityCheck = now;
        } catch (e) {
          // If connectivity check fails, assume we have internet and let Dio handle it
          if (kDebugMode) {
            print('⚠️ Connectivity check failed, proceeding with API call: $e');
          }
          _cachedConnectivityStatus = true; // Optimistic: try API call anyway
          _lastConnectivityCheck = now;
        }

        if (_cachedConnectivityStatus != true) {
          return Left(Failure(message: AppLocalizations().no_internet_connection));
        }
      }

      // Perform the API call
      final result = await apiCall();

      // If API call succeeds, mark connectivity as good
      _cachedConnectivityStatus = true;
      _lastConnectivityCheck = DateTime.now();

      return Right(result);
    } on DioException catch (dioError) {
      // Check if it's a connection error
      if (dioError.type == DioExceptionType.connectionError ||
          dioError.type == DioExceptionType.connectionTimeout) {
        // Invalidate connectivity cache on connection error
        _cachedConnectivityStatus = false;
        _lastConnectivityCheck = DateTime.now();
        
        // Return user-friendly error
        if (dioError.type == DioExceptionType.connectionError) {
          return Left(Failure(message: AppLocalizations().no_internet_connection));
        }
      }
      
      final failure = ApiErrorHandler.handleDioError(error: dioError);
      return Left(failure);
    } on TimeoutException {
      // Invalidate connectivity cache on timeout
      _cachedConnectivityStatus = null;
      _lastConnectivityCheck = DateTime.now();
      
      return Left(Failure(message: AppLocalizations().request_timed_out_please_try_again));
    } catch (error) {
      return Left(Failure(message: AppLocalizations().something_went_wrong));
    }
  }

  /// Clear connectivity cache (useful for manual refresh or testing)
  static void clearConnectivityCache() {
    _cachedConnectivityStatus = null;
    _lastConnectivityCheck = null;
  }
}
