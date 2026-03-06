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
      "image": "https://images.unsplash.com/photo-1520975916090-3105956dac38",
      "title": "Kids Wear",
      "size": "M",
      "color": "Orange",
      "rent": 1600,
      "discount": 20,
      "finalPrice": 1280,
    },
    {
      "image": "https://images.unsplash.com/photo-1618354691373-d851c5c3a990",
      "title": "Designer Suit",
      "size": "L",
      "color": "Black",
      "rent": 2000,
      "discount": 15,
      "finalPrice": 1700,
    },
    {
      "image": "https://images.unsplash.com/photo-1593030761757-71fae45fa0e7",
      "title": "Wedding Sherwani",
      "size": "XL",
      "color": "Cream",
      "rent": 3500,
      "discount": 25,
      "finalPrice": 2625,
    },
    {
      "image": "https://images.unsplash.com/photo-1596755094514-f87e34085b2c",
      "title": "Party Gown",
      "size": "M",
      "color": "Red",
      "rent": 2200,
      "discount": 18,
      "finalPrice": 1804,
    },
    {
      "image": "https://images.unsplash.com/photo-1585487000160-6ebcfceb0d03",
      "title": "Traditional Kurta",
      "size": "L",
      "color": "Yellow",
      "rent": 1200,
      "discount": 10,
      "finalPrice": 1080,
    },
    {
      "image": "https://images.unsplash.com/photo-1520975661595-6453be3f7070",
      "title": "Western Dress",
      "size": "S",
      "color": "Blue",
      "rent": 1800,
      "discount": 12,
      "finalPrice": 1584,
    },
    {
      "image": "https://images.unsplash.com/photo-1503342217505-b0a15ec3261c",
      "title": "Men's Blazer",
      "size": "XL",
      "color": "Grey",
      "rent": 2500,
      "discount": 22,
      "finalPrice": 1950,
    },
    {
      "image": "https://images.unsplash.com/photo-1490481651871-ab68de25d43d",
      "title": "Wedding Lehenga",
      "size": "M",
      "color": "Pink",
      "rent": 5000,
      "discount": 30,
      "finalPrice": 3500,
    },
    {
      "image": "https://images.unsplash.com/photo-1523381294911-8d3cead13475",
      "title": "Casual Hoodie",
      "size": "L",
      "color": "Green",
      "rent": 900,
      "discount": 8,
      "finalPrice": 828,
    },
    {
      "image": "https://images.unsplash.com/photo-1509631179647-0177331693ae",
      "title": "Formal Suit",
      "size": "XL",
      "color": "Navy Blue",
      "rent": 3200,
      "discount": 20,
      "finalPrice": 2560,
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
