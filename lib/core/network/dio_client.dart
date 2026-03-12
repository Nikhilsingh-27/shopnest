import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import 'dio_interceptor.dart';

class DioClient {
  late Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(seconds: 20),
        receiveTimeout: Duration(seconds: 20),
        headers: {"Content-Type": "application/json"},
      ),
    );

    dio.interceptors.add(DioInterceptor());
  }
}
