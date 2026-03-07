import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const AppEndDrawer(),

      appBar: AppBar(
        backgroundColor: const Color(0xFF243447),
        elevation: 0,

        iconTheme: const IconThemeData(color: Colors.white),

        automaticallyImplyLeading: true, // shows back button when possible

        title: const Text(
          "ShopNest",
          style: TextStyle(
            color: Color(0xFFFF7A45),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),

        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: SafeArea(child: child),
    );
  }
}

class AppEndDrawer extends StatefulWidget {
  const AppEndDrawer({super.key});

  @override
  State<AppEndDrawer> createState() => _AppEndDrawerState();
}

class _AppEndDrawerState extends State<AppEndDrawer> {
  bool showProfileDropdown = false;

  void toggleProfile() {
    setState(() {
      showProfileDropdown = !showProfileDropdown;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: 270,
        child: Container(
          color: const Color(0xFF2C3E50),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: ListView(
            children: [
              /// MENU ITEMS
              _menuItem(Icons.home, "Home", "/"),
              _menuItem(Icons.checkroom, "Rent Clothes", "/rentclothes"),
              _menuItem(Icons.local_offer, "Categories", "/categories"),
              _menuItem(Icons.shopping_cart, "Cart", "/cart"),

              const SizedBox(height: 30),

              /// PROFILE ROW
              InkWell(
                onTap: toggleProfile,
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.white70),

                    const SizedBox(width: 8),

                    const Text(
                      "Nikhil",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),

                    const SizedBox(width: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Unverified",
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),

                    const Spacer(),

                    Icon(
                      showProfileDropdown
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              /// PROFILE DROPDOWN CARD
              if (showProfileDropdown)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      /// ID VERIFICATION SECTION
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.center, // center vertically
                          children: [
                            /// UNVERIFIED BADGE
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Unverified",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            /// TEXT SECTION
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "ID Verification",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  InkWell(
                                    onTap: () {
                                      Get.toNamed("/verify");
                                    },
                                    child: const Text(
                                      "Manage verification",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),

                      _profileItem(Icons.settings, "Profile", "/profile"),
                      _profileItem(Icons.inventory_2, "My Rentals", "/rentals"),
                      _profileItem(Icons.favorite, "Wishlist", "/wishlist"),

                      const Divider(),

                      _profileItem(
                        Icons.badge,
                        "Start Verification",
                        "/verify",
                        color: Colors.orange,
                      ),

                      _profileItem(
                        Icons.logout,
                        "Logout",
                        "/login",
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// MENU ITEM
  Widget _menuItem(IconData icon, String title, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: InkWell(
        onTap: () {
          Get.toNamed(route);
        },
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }

  /// PROFILE ITEM
  Widget _profileItem(
    IconData icon,
    String title,
    String route, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(title, style: TextStyle(color: color ?? Colors.black87)),
      onTap: () {
        Get.toNamed(route);
      },
    );
  }
}
