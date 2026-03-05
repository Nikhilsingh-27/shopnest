import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/components/browsemycategory_section.dart';
import 'package:shopnest/components/howitwork_section.dart';
import 'package:shopnest/components/stats_section.dart';
import 'package:shopnest/components/trendingcollection_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFf9f9f9),

      /// DRAWER
      endDrawer: Drawer(
        backgroundColor: const Color(0xFF243447),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                _drawerItem(Icons.home, "Home", "/home"),
                _drawerItem(Icons.checkroom, "Rent Clothes", "/rent"),
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

      /// BODY
      body: SafeArea(
        child: Builder(
          builder: (context) => SingleChildScrollView(
            child: Column(
              children: [
                /// NAVBAR
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF243447),
                    border: Border(
                      bottom: BorderSide(color: Colors.white24, width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// LOGO
                      Row(
                        children: const [
                          Icon(
                            Icons.checkroom,
                            color: Color(0xFFFF7A45),
                            size: 32,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "ShopNest",
                            style: TextStyle(
                              color: Color(0xFFFF7A45),
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      /// MENU BUTTON
                      InkWell(
                        onTap: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white24),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: Colors.white70,
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// HERO SECTION
                Container(
                  height: 500,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1558769132-cb1aea458c5e?q=80&w=1600&auto=format&fit=crop",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.withOpacity(0.7),
                          Colors.deepPurple.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// TITLE
                            Text(
                              "Rent Designer Clothes",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isMobile ? 32 : 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// SUBTITLE
                            Text(
                              "Wear your dream outfit without buying it. Rent premium clothing for every occasion.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: isMobile ? 16 : 20,
                                color: Colors.white70,
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 40),

                            /// PRIMARY BUTTON
                            InkWell(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.checkroom, color: Colors.black),
                                    SizedBox(width: 10),
                                    Text(
                                      "Browse Collection",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// SECONDARY BUTTON
                            InkWell(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: Colors.white70,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.play_circle_fill,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "How It Works",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// BROWSE CATEGORY
                const Text(
                  "Browse By Category",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                const BrowsemycategorySection(),

                const SizedBox(height: 40),

                /// TRENDING COLLECTION
                const Text(
                  "Trending Collection",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                const TrendingcollectionSection(),

                const SizedBox(height: 7),
                StatsSection(),
                const SizedBox(height: 20),
                const Text(
                  "How ShopNest Works",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 7),
                HowItWorksSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Drawer Item
  static Widget _drawerItem(IconData icon, String title, String routeName) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Icon(icon, color: Colors.white70, size: 26),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white70, fontSize: 18),
      ),
      onTap: () {
        Get.back();
        Get.toNamed(routeName);
      },
    );
  }
}
