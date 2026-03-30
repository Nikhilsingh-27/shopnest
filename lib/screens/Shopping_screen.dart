import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/components/browsemycategory_section.dart';
import 'package:shopnest/components/custom_snackbar.dart';
import 'package:shopnest/components/howitwork_section.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';
import 'package:shopnest/components/stats_section.dart';
import 'package:shopnest/components/trendingcollection_section.dart';
import 'package:shopnest/core/storage/token_storage.dart';
import 'package:shopnest/data/repositories/auth_repository.dart';
import 'package:shopnest/modules/controllers/mod_controller.dart';

class ShopHomescreen extends StatefulWidget {
  const ShopHomescreen({super.key});

  @override
  State<ShopHomescreen> createState() => _ShopHomescreenState();
}

class _ShopHomescreenState extends State<ShopHomescreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey howItWorksKey = GlobalKey();
  final homedata = Get.find<AuthRepository>();
  final modeController = Get.find<ModeController>();
  @override
  void initState() {
    super.initState();
    homedata.getcategoriesfun();
  }

  void scrollToHowItWorks() {
    final context = howItWorksKey.currentContext;

    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = TokenStorage();

    var user = storage.getUser();

    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 700;

    return MainLayout(
      /// BODY
      child: SafeArea(
        child: Builder(
          builder: (context) => SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                /// HERO SECTION
                /// HERO SECTION
                Container(
                  height: 500,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      /// BACKGROUND IMAGE
                      Positioned.fill(
                        child: Image.network(
                          "https://images.unsplash.com/photo-1558769132-cb1aea458c5e?q=80&w=1600&auto=format&fit=crop",
                          fit: BoxFit.cover,
                        ),
                      ),

                      /// OVERLAY GRADIENT
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.purple.withOpacity(0.7),
                                Colors.deepPurple.withOpacity(0.85),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                      ),

                      /// 🔥 TOP RIGHT MODE SWITCH
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// RENT MODE
                              GestureDetector(
                                onTap: () {
                                  modeController.switchToRent();
                                  Get.offAllNamed("/");
                                  CustomSnackbar.showSuccess(
                                    "Rent Mode Activated",
                                  );
                                },
                                child: Obx(
                                  () => AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          !modeController.isShoppingMode.value
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.checkroom,
                                          size: 16,
                                          color:
                                              !modeController
                                                  .isShoppingMode
                                                  .value
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Rent",
                                          style: TextStyle(
                                            color:
                                                !modeController
                                                    .isShoppingMode
                                                    .value
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              /// SHOP MODE
                              GestureDetector(
                                onTap: () {
                                  modeController.switchToShop();
                                  Get.offAllNamed("/shopping");
                                  CustomSnackbar.showSuccess(
                                    "Shopping Mode Activated",
                                  );
                                },
                                child: Obx(
                                  () => AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: modeController.isShoppingMode.value
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.store,
                                          size: 16,
                                          color:
                                              modeController
                                                  .isShoppingMode
                                                  .value
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Shop",
                                          style: TextStyle(
                                            color:
                                                modeController
                                                    .isShoppingMode
                                                    .value
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// CENTER CONTENT
                      Center(
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
                                  fontSize: 42,
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
                                  fontSize: 18,
                                  color: Colors.white70,
                                  height: 1.6,
                                ),
                              ),

                              const SizedBox(height: 30),

                              /// PRIMARY BUTTON
                              InkWell(
                                onTap: () {
                                  Get.toNamed("/rentclothes");
                                },
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
                                      Icon(
                                        Icons.checkroom,
                                        color: Colors.black,
                                      ),
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
                                onTap: () {
                                  scrollToHowItWorks();
                                },
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
                    ],
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
                const SizedBox(height: 5),
                Container(
                  width: 200,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed("/rentclothes");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag, size: 22, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "View All Collection",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 7),
                StatsSection(),
                const SizedBox(height: 20),
                Container(
                  key: howItWorksKey,
                  child: const Text(
                    "How ShopNest Works",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 2),
                HowItWorksSection(),
                const SizedBox(height: 20),
                ShopFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
