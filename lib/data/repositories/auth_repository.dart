import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';
import '../../core/storage/token_storage.dart';
import '../providers/auth_provider.dart';

class AuthRepository extends GetxController {
  final Dio dio = DioClient().dio;

  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final AuthProvider provider = AuthProvider();
  final TokenStorage storage = TokenStorage();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await provider.login(email, password);

    if (response.data["success"] == true) {
      final token = response.data["data"]["token"];
      final user = response.data["data"]["user"];

      storage.saveAuthData(token, user);
    }
    return response.data;
  }

  Future<Map<String, dynamic>> getcategoriesfun() async {
    final response = await dio.get(
      ApiConstants.categories,
      options: Options(extra: {"requiresToken": false}),
    );
    print(response);
    if (response.data["success"] == true) {
      final data = response.data["data"];
      categories.value = List<Map<String, dynamic>>.from(data);
    }
    return response.data;
  }

  Future<Map<String, dynamic>> getallproductsfun({
    required int page,
    required int limit,
  }) async {
    try {
      print(page);
      final response = await dio.get(
        ApiConstants.products,
        queryParameters: {"page": page, "limit": limit},
      );

      // print("Products API Response: ${response.data}");

      if (response.data == null) {
        throw Exception("Empty response from server");
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?["message"] ?? e.message ?? "API error";

      throw Exception(errorMessage);
    }
  }
}
