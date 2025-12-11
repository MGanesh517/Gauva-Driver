import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import '../../../core/routes/app_routes.dart';
import '../navigation_service.dart';

class DioInterceptors extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Token fetch from local storage
    final token = await LocalStorageService().getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final navigatorKey = NavigationService.navigatorKey;
    final currentContext = navigatorKey.currentContext;
    final currentRoute = currentContext != null ? ModalRoute.of(currentContext)?.settings.name : null;

    if (err.response?.statusCode == 401) {
      await LocalStorageService().clearToken();
      await LocalStorageService().clearStorage();

      if (currentContext != null && currentRoute != AppRoutes.login) {
        NavigationService.pushNamedAndRemoveUntil(AppRoutes.login);
      }
    }

    return super.onError(err, handler);
  }
}
