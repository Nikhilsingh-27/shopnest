import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

class DioInterceptor extends Interceptor {
  final TokenStorage storage = TokenStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requiresToken = options.extra["requiresToken"] ?? true;

    if (requiresToken) {
      final token = storage.getToken();

      if (token != null && token.isNotEmpty) {
        options.headers["Authorization"] = "Bearer $token";
      }
    }

    handler.next(options); // continue request
  }
}
