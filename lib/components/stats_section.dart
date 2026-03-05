import 'package:flutter/material.dart';

import 'stats_card.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> stats = [
      {
        "icon": Icons.checkroom,
        "value": "7+",
        "label": "Designer Outfits",
        "color": Color(0xFFFF6A33),
      },
      {
        "icon": Icons.sentiment_satisfied_alt,
        "value": "2+",
        "label": "Happy Customers",
        "color": Colors.blue,
      },
      {
        "icon": Icons.local_offer,
        "value": "8+",
        "label": "Categories",
        "color": Color(0xFFFF6A33),
      },
      {
        "icon": Icons.local_shipping,
        "value": "24/7",
        "label": "Delivery Support",
        "color": Colors.blue,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: stats.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: StatsCard(
                icon: item["icon"],
                value: item["value"],
                label: item["label"],
                color: item["color"],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
