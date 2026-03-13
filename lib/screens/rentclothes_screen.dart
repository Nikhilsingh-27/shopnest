import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/pagination.dart';
import 'package:shopnest/components/shopfooter_section.dart';
import 'package:shopnest/components/trendingCollection_card_for_screen.dart';
import 'package:shopnest/data/repositories/auth_repository.dart';

class RentclothesScreen extends StatefulWidget {
  const RentclothesScreen({super.key});

  @override
  State<RentclothesScreen> createState() => _RentclothesScreenState();
}

class _RentclothesScreenState extends State<RentclothesScreen> {
  final AuthRepository repo = Get.find<AuthRepository>();

  int currentPage = 1;
  int totalPages = 0;
  int limit = 5;

  bool isLoading = false;
  bool isPageChanging = false;

  List<dynamic> productList = [];

  String selectedCategory = "All Categories";

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  Future<void> fetchAllProducts({bool reset = false}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      if (reset) productList.clear();
    });

    try {
      final data = await repo.getallproductsfun(
        page: currentPage,
        limit: limit,
      );

      final products = data['data']['products'] as List<dynamic>;

      setState(() {
        totalPages = data["data"]["pagination"]["total_pages"];
        productList.addAll(products);
        print(productList);
      });
    } catch (e) {
      debugPrint("Pagination error: $e");
    } finally {
      setState(() {
        isLoading = false;
        isPageChanging = false;
      });
    }
  }

  Widget categoryButton(String text) {
    final isSelected = selectedCategory == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orangeAccent : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.orangeAccent : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.checkroom,
              size: 18,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SafeArea(
        child: isLoading && productList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    /// TITLE
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Rent Designer Clothes",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// CATEGORY LIST
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            categoryButton("All Categories"),
                            const SizedBox(width: 10),
                            categoryButton("Casual Wear"),
                            const SizedBox(width: 10),
                            categoryButton("Designer Wear"),
                            const SizedBox(width: 10),
                            categoryButton("Party Wear"),
                            const SizedBox(width: 10),
                            categoryButton("Traditional Wear"),
                            const SizedBox(width: 10),
                            categoryButton("Wedding Wear"),
                            const SizedBox(width: 10),
                            categoryButton("Western Wear"),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// PRODUCT LIST
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: List.generate(productList.length, (index) {
                          final product = productList[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TrendingcollectionCardForScreen(
                              item: product,
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// PAGINATION
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Pagination(
                        currentPage: currentPage,
                        totalPages: totalPages,
                        onPageChanged: (page) {
                          setState(() {
                            currentPage = page;
                            isPageChanging = true;
                          });

                          fetchAllProducts(reset: true);
                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// FOOTER
                    const ShopFooter(),
                  ],
                ),
              ),
      ),
    );
  }
}
