import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/data/repositories/auth_repository.dart';

import 'browsemycategory_card.dart';

class BrowsemycategorySection extends StatefulWidget {
  const BrowsemycategorySection({super.key});

  @override
  State<BrowsemycategorySection> createState() =>
      _BrowsemycategorySectionState();
}

class _BrowsemycategorySectionState extends State<BrowsemycategorySection> {
  final PageController _pageController = PageController(viewportFraction: 0.85);

  Timer? _timer;
  int _currentPage = 0;
  bool _autoScrollStarted = false;

  final home = Get.find<AuthRepository>();

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
    return Obx(() {
      final categories = home.categories;

      if (categories.isEmpty) {
        return const SizedBox(
          height: 300,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      _startAutoScroll(categories.length);

      return SizedBox(
        height: 311,
        child: PageView.builder(
          controller: _pageController,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final item = categories[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: BrowsemycategoryCard(
                item: {
                  "title": item["name"],
                  "description": item["description"],
                  "buttonText": "Browse",
                },
                onPressed: () {
                  Get.toNamed("/rentclothes");
                },
              ),
            );
          },
        ),
      );
    });
  }
}
