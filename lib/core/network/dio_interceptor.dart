import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

class DioInterceptor extends Interceptor {
  final TokenStorage storage = TokenStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check if request requires token
    if (options.extra["requiresToken"] == true) {
      final token = storage.getToken();

      if (token != null) {
        options.headers["Authorization"] = "Bearer $token";
      }
    }

    super.onRequest(options, handler);
  }
}
