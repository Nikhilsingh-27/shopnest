import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';

class AuthProvider {
  final Dio dio = DioClient().dio;

  Future<Response> login(String email, String password) async {
    return await dio.post(
      ApiConstants.login,
      data: {"email": email, "password": password},
      options: Options(extra: {"requiresToken": false}),
    );
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String address,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: {
          "name": name,
          "email": email,
          "address": address,
          "password": password,
          "phone": phone,
        },
        options: Options(extra: {"requiresToken": false}),
      );
      print(response.data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Not found");
    }
  }

  Future<Response> getProfile() async {
    return await dio.get(
      "/profile",
      options: Options(extra: {"requiresToken": true}),
    );
  }

  // PUBLIC API (NO TOKEN)
  Future<Response> getProducts() async {
    return await dio.get(
      ApiConstants.categories,
      options: Options(extra: {"requiresToken": false}),
    );
  }
}
