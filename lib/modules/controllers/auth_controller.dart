import 'package:get/get.dart';
import 'package:shopnest/components/custom_snackbar.dart';

import '../../data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository repo = AuthRepository();

  var isLoading = false.obs;
  var rentalStatusList = <Map<String, dynamic>>[].obs;

  Future<void> fetchRentalStatus() async {
    try {
      isLoading.value = true;
      final response = await repo.getrentalstatusfun();
      if (response["success"] == true) {
        final List<dynamic> allOrders = response["data"]["all"] ?? [];
        // Filter orders with "In Use" status
        final inUseOrders =
            allOrders.where((order) => order["status"] == "In Use").toList();

        // Flatten to show items if needed, or just store the orders
        // The user said "show the product", so I will store the items from these orders
        List<Map<String, dynamic>> inUseItems = [];
        for (var order in inUseOrders) {
          final items = order["items"] as List<dynamic>? ?? [];
          for (var item in items) {
            // Add order level info to each item for display (dates, etc.)
            inUseItems.add({
              ...item,
              "order_id": order["id"],
              "total_price": order["total_price"],
              "status": order["status"],
              "start_date": order["start_date"],
              "return_date": order["return_date"],
              "rental_days": order["rental_days"],
            });
          }
        }
        rentalStatusList.assignAll(inUseItems);
      }
    } catch (e) {
      print("Error fetching rental status: $e");
    } finally {
      isLoading.value = false;
    }
  }

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
