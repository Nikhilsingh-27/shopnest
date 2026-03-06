import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'navbar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFf9f9f9),

        /// GLOBAL DRAWER
        endDrawer: Drawer(
          backgroundColor: const Color(0xFF243447),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _drawerItem(Icons.person, "Profile", "/profile"),
                  _drawerItem(Icons.home, "Home", "/home"),
                  _drawerItem(Icons.checkroom, "Rent Clothes", "/rentclothes"),
                  _drawerItem(Icons.local_offer, "Categories", "/categories"),
                  _drawerItem(Icons.shopping_cart, "Cart", "/cart"),
                  _drawerItem(Icons.login, "Login", "/login"),

                  const Spacer(),

                  /// SIGN UP BUTTON
                  InkWell(
                    onTap: () {
                      Get.back();
                      Get.toNamed("/signup");
                    },
                    borderRadius: BorderRadius.circular(40),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7A45),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.person, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            "Sign Up Free",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const ShopNestNavbar(),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _drawerItem(IconData icon, String title, String routeName) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white70)),
      onTap: () {
        Get.back();
        Get.toNamed(routeName);
      },
    );
  }
}
