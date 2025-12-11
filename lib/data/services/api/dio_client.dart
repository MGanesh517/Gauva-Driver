import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../../core/config/environment.dart';
import 'dio_interceptors.dart';

class DioClient {
  final Dio dio;

  DioClient({String? baseUrl})
      : dio = Dio(
    BaseOptions(
      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 30),
      baseUrl: baseUrl ?? Environment.apiUrl,
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
      },
    ),
  ) {
    dio.interceptors.add(DioInterceptors());
    dio.interceptors.add(InterceptorsWrapper());
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
    ));
  }
}
