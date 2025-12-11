import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gauva_driver/core/errors/failure.dart';

import '../../data/services/local_storage_service.dart';
import '../../data/services/navigation_service.dart';
import '../../generated/l10n.dart';

class ApiErrorHandler {
  static Failure handleDioError({required DioException error}) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return Failure(message: AppLocalizations().connection_timeout_with_api_server);
      case DioExceptionType.receiveTimeout:
        return Failure(message: AppLocalizations().receive_timeout_with_api_server);
      case DioExceptionType.sendTimeout:
        return Failure(message: AppLocalizations().send_timeout_with_api_server);
      case DioExceptionType.badCertificate:
        return Failure(message: AppLocalizations().bad_certificate_with_api_server);
      case DioExceptionType.badResponse:
        if (error.response != null) {
          return _handleBadResponse(response: error.response!);
        }
        return Failure(message: AppLocalizations().received_invalid_response_from_server);
      case DioExceptionType.cancel:
        return Failure(message: AppLocalizations().request_to_api_server_was_cancelled);
      case DioExceptionType.connectionError:
        return Failure(message: AppLocalizations().connection_error_with_api_server);
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return Failure(message: AppLocalizations().no_internet_connection_please_check);
        }
        return Failure(message: AppLocalizations().unexpected_error_occurred);
    }
  }

  static Failure _handleBadResponse({required Response response}) {
    final statusCode = response.statusCode;
    final data = response.data;

    if (data is! Map<String, dynamic>) {
      return Failure(message: AppLocalizations().unexpected_response_format, code: statusCode);
    }

    if (statusCode == 400) {
      return Failure(message: data['message'] ?? AppLocalizations().bad_request, code: statusCode);
    } else if (statusCode == 401) {
      LocalStorageService().destroyAll();
      NavigationService.navigateToLogin();
      return Failure(
        message: data['message'] ?? AppLocalizations().unauthorized_access_please_login_again,
        code: statusCode,
      );
    } else if (statusCode == 403) {
      return Failure(
        message: data['message'] ?? AppLocalizations().forbidden_access_please_login_again,
        code: statusCode,
      );
    } else if (statusCode == 404) {
      return Failure(message: data['message'] ?? AppLocalizations().resource_not_found, code: statusCode);
    } else if (statusCode == 413) {
      return Failure(message: AppLocalizations().requestEntityTooLarge, code: statusCode);
    } else if (statusCode == 422) {
      if (data['message'] != null) {
        return Failure(message: data['message'], code: statusCode);
      }
      if (data['errors'] != null) {
        return Failure(
          message: _extractValidationError(error: data['errors']),
          code: statusCode,
        );
      }
      return Failure(message: data['message'] ?? AppLocalizations().validation_error, code: statusCode);
    } else if (statusCode == 500) {
      return Failure(message: data['message'] ?? AppLocalizations().internal_server_error, code: statusCode);
    }
    return Failure(message: AppLocalizations().something_went_wrong, code: statusCode);
  }

  static String _extractValidationError({required Map<String, dynamic> error}) =>
      error.entries.map((e) => "${e.key}: ${e.value.join(', ')}").join('\n');
}
