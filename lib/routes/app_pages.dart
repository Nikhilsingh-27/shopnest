import 'package:get/get.dart';
import 'package:shopnest/screens/Shopping_screen.dart';
import 'package:shopnest/screens/about_us_screen.dart';
import 'package:shopnest/screens/categories_screen.dart';
import 'package:shopnest/screens/checkout_screen.dart';
import 'package:shopnest/screens/contact_us_screen.dart';
import 'package:shopnest/screens/faq_screen.dart';
import 'package:shopnest/screens/forgot.dart';
import 'package:shopnest/screens/privacy_policy_screen.dart';
import 'package:shopnest/screens/profile_screen.dart';
import 'package:shopnest/screens/rentclothes_screen.dart';
import 'package:shopnest/screens/returns_refunds_screen.dart';
import 'package:shopnest/screens/shipping_policy_screen.dart';
import 'package:shopnest/screens/signup.dart';
import 'package:shopnest/screens/terms_conditions_screen.dart';
import 'package:shopnest/screens/verification_screen.dart';

// import '../screens/rent_screen.dart';
// import '../screens/categories_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/homescreen.dart';
import '../screens/login.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(name: Routes.home, page: () => Homescreen()),
    // GetPage(name: Routes.rent, page: () => const RentScreen()),
    GetPage(name: Routes.categories, page: () => const CategoriesScreen()),
    GetPage(name: Routes.cart, page: () => const CartScreen()),
    GetPage(name: Routes.login, page: () => const ShopNestLogin()),
    GetPage(name: Routes.signup, page: () => const ShopNestSignup()),
    GetPage(name: Routes.forgot, page: () => const ForgotPasswordScreen()),
    GetPage(name: Routes.rentclothes, page: () => RentclothesScreen()),
    GetPage(name: Routes.profile, page: () => ProfileScreen()),
    GetPage(name: Routes.verify, page: () => VerificationScreen()),
    GetPage(name: Routes.chekout, page: () => CheckoutScreen()),
    GetPage(name: Routes.about, page: () => const AboutUsScreen()),
    GetPage(name: Routes.contact, page: () => const ContactUsScreen()),
    GetPage(
      name: Routes.shippingPolicy,
      page: () => const ShippingPolicyScreen(),
    ),
    GetPage(
      name: Routes.returnsRefunds,
      page: () => const ReturnsRefundsScreen(),
    ),
    GetPage(
      name: Routes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: Routes.termsConditions,
      page: () => const TermsConditionsScreen(),
    ),
    GetPage(name: Routes.faq, page: () => const FAQScreen()),

    GetPage(name: Routes.shopping, page: () => ShopHomescreen()),
  ];
}
