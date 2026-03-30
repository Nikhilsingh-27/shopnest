import 'package:get/get.dart';

class ModeController extends GetxController {
  var isShoppingMode = false.obs;

  void switchToShop() {
    isShoppingMode.value = true;
  }

  void switchToRent() {
    isShoppingMode.value = false;
  }
}
