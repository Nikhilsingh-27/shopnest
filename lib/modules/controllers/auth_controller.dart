import 'package:get/get.dart';
import 'package:shopnest/components/custom_snackbar.dart';

import '../../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository repo = AuthRepository();

  var isLoading = false.obs;

  Future login(String email, String password) async {
    try {
      isLoading.value = true;

      final response = await repo.login(email, password);
      print(response);
      if (response["success"]) {
        Get.offAllNamed("/home");
      } else {
        CustomSnackbar.showError("Invalid credentials");
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String phone,
    String address,
    String password,
  ) async {
    try {
      isLoading.value = true;

      final response = await repo.register(
        name,
        email,
        address,
        phone,
        password,
      );

      print(response);

      if (response["success"] == true) {
        CustomSnackbar.showSuccessSlow("Registration successful!");
        Get.offAllNamed("/home");
      } else {
        CustomSnackbar.showError(response["message"] ?? "Registration failed");
      }

      return response;
    } catch (e) {
      CustomSnackbar.showError("Registration error: $e");
      return {"success": false, "message": e.toString()};
    } finally {
      isLoading.value = false;
    }
  }
}
