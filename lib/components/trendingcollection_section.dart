import 'dart:async';

import 'package:flutter/material.dart';

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

  /// Dummy Data (Map style like categories)
  final List<Map<String, dynamic>> items = [
    {
      "title": "Royal Sherwani",
      "image": "https://picsum.photos/400/300?1",
      "rent": 1600,
      "discount": 20,
      "finalPrice": 1280,
    },
    {
      "title": "Wedding Lehenga",
      "image": "https://picsum.photos/400/300?2",
      "rent": 2000,
      "discount": 25,
      "finalPrice": 1500,
    },
    {
      "title": "Party Blazer",
      "image": "https://picsum.photos/400/300?3",
      "rent": 1200,
      "discount": 15,
      "finalPrice": 1020,
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
    _startAutoScroll(items.length);

    return SizedBox(
      height: 450,
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
