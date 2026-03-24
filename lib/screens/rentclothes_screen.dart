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
  int limit = 2;

  bool isLoading = false;
  bool isPageChanging = false;

  List<dynamic> productList = [];
  List<Map<String, dynamic>> categories = [];

  String selectedCategoryName = "All Categories";
  String selectedCategoryId = "0";

  @override
  void initState() {
    super.initState();

    final args = Get.arguments;

    if (args != null) {
      selectedCategoryId = args["categoryId"] ?? "0";
      selectedCategoryName = args["categoryName"] ?? "All Categories";
    }

    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await fetchCategories();
    await fetchAllProducts(reset: true);
  }

  Future<void> fetchCategories() async {
    try {
      final data = await repo.getcategoriesfun();

      if (data["success"] == true && data["data"] is List) {
        final list = List<Map<String, dynamic>>.from(data["data"]);
        setState(() => categories = list);
      }
    } catch (e) {
      debugPrint("Category fetch error: $e");
    }
  }

  Future<void> fetchAllProducts({int page = 1, bool reset = false}) async {
    if (isLoading) return;

    currentPage = page;

    setState(() {
      isLoading = true;
      if (reset) productList.clear();
    });

    try {
      final Map<String, dynamic> data;

      if (selectedCategoryId == "0") {
        data = await repo.getallproductsfun(page: currentPage, limit: limit);
      } else {
        data = await repo.categorybyid(
          id: selectedCategoryId,
          page: currentPage,
          limit: limit,
        );
      }

      final products = (data["data"]?["products"] as List<dynamic>?) ?? [];
      final apiTotalPages =
          (data["data"]?["pagination"]?["total_pages"] as int?) ?? 0;

      setState(() {
        totalPages = apiTotalPages;
        productList.addAll(products);
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

  Widget categoryButton(String text, {required String id}) {
    final isSelected = selectedCategoryId == id;

    return GestureDetector(
      onTap: () {
        if (selectedCategoryId == id) return;

        setState(() {
          selectedCategoryName = text;
          selectedCategoryId = id;
          currentPage = 1;
          isPageChanging = true;
        });

        fetchAllProducts(page: 1, reset: true);
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
                            categoryButton("All Categories", id: "0"),
                            const SizedBox(width: 10),
                            ...categories.expand((cat) {
                              final name = cat["name"]?.toString() ?? "Unknown";
                              final id = cat["id"]?.toString() ?? "0";
                              return [
                                categoryButton(name, id: id),
                                const SizedBox(width: 10),
                              ];
                            }).toList(),
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
                              key: ValueKey(product["id"]),
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

                          fetchAllProducts(page: page, reset: true);
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
