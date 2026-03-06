import 'package:flutter/material.dart';

class ShopNestNavbar extends StatelessWidget {
  const ShopNestNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // responsive breakpoints
    final bool isMobile = width < 700;
    final bool isTablet = width >= 700 && width < 1100;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF243447), // dark blue background
        border: Border(bottom: BorderSide(color: Colors.white24, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT — LOGO
          Row(
            children: const [
              Icon(Icons.checkroom, color: Color(0xFFFF7A45), size: 30),
              SizedBox(width: 10),
              Text(
                "ShopNest",
                style: TextStyle(
                  color: Color(0xFFFF7A45),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          /// RIGHT — MENU
          if (!isMobile)
            Row(
              children: [
                _navItem(Icons.home_outlined, "Home"),
                _navItem(Icons.checkroom_outlined, "Rent Clothes"),
                _navItem(Icons.local_offer_outlined, "Categories"),
                _navItem(Icons.shopping_cart_outlined, "Cart"),
                _navItem(Icons.login, "Login"),

                const SizedBox(width: 20),

                /// SIGN UP BUTTON
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7A45),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.person_add, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        "Sign Up Free",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          /// MOBILE MENU ICON
          if (isMobile)
            Builder(
              builder: (context) => InkWell(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.menu, color: Colors.white, size: 26),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Navbar Item Widget
  static Widget _navItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
