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

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String address,
    String phone,
    String password,
  ) async {
    final response = await provider.register(
      name: name,
      email: email,
      address: address,
      password: password,
      phone: phone,
    );

    // provider.register already returns a parsed Map<String, dynamic>
    if (response["success"] == true) {
      final token = response["data"]?["token"];
      final user = response["data"]?["user"];

      if (token != null && user != null) {
        storage.saveAuthData(token.toString(), Map<String, dynamic>.from(user));
      }
    }

    return response;
  }

  Future<Map<String, dynamic>> getcategoriesfun() async {
    final response = await dio.get(
      ApiConstants.categories,
      options: Options(extra: {"requiresToken": false}),
    );
    print(response);
    if (response.data["success"] == true) {
      final data = response.data["data"];
      if (data != null) {
        categories.value = List<Map<String, dynamic>>.from(data)
            .where((item) => item != null)
            .toList();
      } else {
        categories.value = [];
      }
    }
    return response.data;
  }

  Future<Map<String, dynamic>> getusercarts({required String id}) async {
    try {
      final response = await dio.get(
        ApiConstants.cart,
        queryParameters: {"id": id},
        options: Options(extra: {"requiresToken": true}),
      );

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

  Future<Map<String, dynamic>> addcartfun({
    required String id,
    required String quantity,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.addcart,
        data: {"product_id": id, "quantity": quantity},
        options: Options(extra: {"requiresToken": true}),
      );
      print(response.data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?["message"] ?? e.message ?? "API error";

      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> deletecartfun({required String id}) async {
    try {
      final response = await dio.post(
        ApiConstants.deletecart,
        data: {"cart_item_id": id},
        options: Options(extra: {"requiresToken": true}),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?["message"] ?? e.message ?? "API error";

      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> trendingProducts() async {
    try {
      final response = await dio.get(ApiConstants.trending);

      if (response.data == null) {
        throw Exception("Empty response from server");
      }
      print(response.data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?["message"] ?? e.message ?? "API error";

      throw Exception(errorMessage);
    }
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

  Future<Map<String, dynamic>> categorybyid({
    required dynamic id,
    required int page,
    required int limit,
  }) async {
    final categoryId = id is String || id is int ? id.toString() : "0";

    try {
      final response = await dio.get(
        "${ApiConstants.categories}/$categoryId",
        queryParameters: {"page": page, "limit": limit},
        options: Options(extra: {"requiresToken": false}),
      );

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

  Future<Map<String, dynamic>> getprofile() async {
    try {
      final response = await dio.get(
        ApiConstants.getprofile,
        options: Options(extra: {"requiresToken": true}),
      );

      if (response.data == null) {
        throw Exception("Empty response from server");
      }
      print(response.data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?["message"] ?? e.message ?? "API error";

      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await dio.put(
        ApiConstants.getprofile,
        data: {"name": name, "phone": phone, "address": address},
        options: Options(extra: {"requiresToken": true}),
      );

      if (response.data == null) {
        throw Exception("Empty response from server");
      }
      print(response.data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?["message"] ?? e.message ?? "API error";

      throw Exception(errorMessage);
    }
  }

  Future<Map<String, dynamic>> updatePassword({
    required String currPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.updatePassowrd,
        data: {
          "current_password": currPassword,
          "new_password": newPassword,
          "confirm_password": confirmPassword,
        },
        options: Options(extra: {"requiresToken": true}),
      );

      if (response.data == null) {
        throw Exception("Empty response from server");
      }
      print(response.data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?["message"] ?? e.message ?? "API error";

      throw Exception(errorMessage);
    }
  }
}
