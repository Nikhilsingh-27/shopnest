import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'dio_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() {
    return _instance;
  }

  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: const {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(DioInterceptor());

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("➡️ REQUEST: ${options.method} ${options.uri}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}");
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          print("❌ ERROR: ${error.response?.statusCode} ${error.message}");
          return handler.next(error);
        },
      ),
    );
  }
}