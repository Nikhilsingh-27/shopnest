import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  /// Dummy Data
  final List<Map<String, dynamic>> categories = [
    {
      "title": "Traditional Wear",
      "description": "Ethnic and traditional clothing for all occasions",
      "icon": Icons.checkroom,
      "buttonText": "Browse",
    },
    {
      "title": "Wedding Collection",
      "description": "Perfect outfits for weddings and receptions",
      "icon": Icons.diamond,
      "buttonText": "Browse",
    },
    {
      "title": "Party Wear",
      "description": "Stylish outfits for parties and events",
      "icon": Icons.celebration,
      "buttonText": "Browse",
    },
  ];

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
    _startAutoScroll(categories.length);

    return SizedBox(
      height: 300,
      child: PageView.builder(
        controller: _pageController,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final item = categories[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: BrowsemycategoryCard(
              item: item,
              onPressed: () {
                Get.toNamed("/rentclothes");
                //print("Clicked ${item['title']}");
              },
            ),
          );
        },
      ),
    );
  }
}
