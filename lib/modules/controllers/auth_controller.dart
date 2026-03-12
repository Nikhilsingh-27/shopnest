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
}
