import 'package:get/get.dart';
import 'package:shopnest/screens/forgot.dart';
import 'package:shopnest/screens/profile_screen.dart';
import 'package:shopnest/screens/rentclothes_screen.dart';
import 'package:shopnest/screens/signup.dart';

import '../screens/homescreen.dart';
// import '../screens/rent_screen.dart';
// import '../screens/categories_screen.dart';
// import '../screens/cart_screen.dart';
import '../screens/login.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(name: Routes.home, page: () => const HomeScreen()),
    // GetPage(name: Routes.rent, page: () => const RentScreen()),
    // GetPage(name: Routes.categories, page: () => const CategoriesScreen()),
    // GetPage(name: Routes.cart, page: () => const CartScreen()),
    GetPage(name: Routes.login, page: () => const ShopNestLogin()),
    GetPage(name: Routes.signup, page: () => const ShopNestSignup()),
    GetPage(name: Routes.forgot, page: () => const ForgotPasswordScreen()),
    GetPage(name: Routes.rentclothes, page: () => RentclothesScreen()),
    GetPage(name: Routes.profile, page: () => ProfileScreen()),
  ];
}
