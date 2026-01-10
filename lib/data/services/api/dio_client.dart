import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../../core/config/environment.dart';
import 'dio_interceptors.dart';
import 'background_transformer.dart';

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
          headers: {'Accept': 'application/json'},
        ),
      ) {
    // Use BackgroundTransformer for better performance
    dio.transformer = FlutterComputeTransformer();

    dio.interceptors.add(DioInterceptors());
    dio.interceptors.add(InterceptorsWrapper());
    dio.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: false, responseBody: false, compact: true));
  }
}
