import 'package:get/get.dart';
import 'package:shopnest/components/custom_snackbar.dart';
import 'package:shopnest/data/repositories/auth_repository.dart';

class CartController extends GetxController {
  var isDeleting = false.obs;

  /// ✅ Per item loading
  var addingItems = <String, bool>{}.obs;

  Future<void> addToCart(String id) async {
    if (addingItems[id] == true) return;

    try {
      addingItems[id] = true;

      final response = await AuthRepository().addcartfun(id: id, quantity: "1");

      if (response["success"] == true) {
        CustomSnackbar.showSuccess("Product added to cart successfully");
        await Future.delayed(const Duration(seconds: 3));
      } else {
        CustomSnackbar.showError(
          response["message"] ?? "Failed to add item to cart",
        );
        await Future.delayed(const Duration(seconds: 3));
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
      await Future.delayed(const Duration(seconds: 3));
    } finally {
      addingItems[id] = false;
    }
  }

  Future<void> deleteCart(String id) async {
    try {
      isDeleting.value = true;

      await AuthRepository().deletecartfun(id: id);

      Get.snackbar("Success", "Item deleted");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isDeleting.value = false;
    }
  }
}
