import 'dart:async';

import 'package:flutter/material.dart';

import '../data/repositories/auth_repository.dart';
import 'trendingcollection_card.dart';

class TrendingcollectionSection extends StatefulWidget {
  const TrendingcollectionSection({super.key});

  @override
  State<TrendingcollectionSection> createState() =>
      _TrendingcollectionSectionState();
}

class _TrendingcollectionSectionState extends State<TrendingcollectionSection> {
  final PageController _pageController = PageController(viewportFraction: 0.85);

  Timer? _timer;
  int _currentPage = 0;
  bool _autoScrollStarted = false;

  /// Dynamic Data from API
  final List<Map<String, dynamic>> items = [];
  bool isLoading = true;
  String? errorMessage;

  String _getImageUrl(String? imageName) {
    const String baseUrl = "https://www.dizaartdemo.com/";
    const String defaultImage = "${baseUrl}public/front/assets/img/list-8.jpg";

    if (imageName == null || imageName.trim().isEmpty) return defaultImage;

    final imageFile = imageName.split('/').last;
    if (imageFile.isEmpty) return defaultImage;

    return "${baseUrl}demo/shopnest/assets/images/products/$imageFile";
  }

  @override
  void initState() {
    super.initState();
    _fetchTrendingProducts();
  }

  Future<void> _fetchTrendingProducts() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await AuthRepository().trendingProducts();

      if (response["success"] == true) {
        final products = response["data"]["products"] as List<dynamic>;

        setState(() {
          items.clear();
          items.addAll(
            products.map(
              (product) => {
                "id": product["id"],
                "title": product["name"],
                "rent":
                    double.tryParse(product["price"]?.toString() ?? "0") ?? 0,
                "discount":
                    int.tryParse(
                      product["discount_percent"]?.toString() ?? "0",
                    ) ??
                    0,
                "finalPrice": product["effective_price"] ?? 0,
                "image": _getImageUrl(
                  (product["images"] is List && product["images"].isNotEmpty)
                      ? product["images"][0]
                      : null,
                ),
                "stock": product["stock"],
                "slug": product["slug"],
                "category_id": product["category_id"],
                "category_name": product["category_name"],
                "original_price": product["original_price"],
                "description": product["description"],
                // Add any other fields needed for SingleproductScreen
              },
            ),
          );
        });
      } else {
        setState(() {
          errorMessage =
              response["message"] ?? "Failed to load trending products";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _startAutoScroll(int itemCount) {
    if (_autoScrollStarted || itemCount <= 1) return;

    _autoScrollStarted = true;

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_pageController.hasClients) return;

      _currentPage = (_currentPage + 1) % itemCount;

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 450,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return SizedBox(
        height: 450,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchTrendingProducts,
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    if (items.isEmpty) {
      return const SizedBox(
        height: 450,
        child: Center(child: Text("No trending products available")),
      );
    }

    _startAutoScroll(items.length);

    return SizedBox(
      height: 600,
      child: PageView.builder(
        controller: _pageController,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TrendingcollectionCard(key: ValueKey(index), item: item),
          );
        },
      ),
    );
  }
}
