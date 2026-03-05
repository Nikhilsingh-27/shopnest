import 'package:flutter/material.dart';
import 'package:shopnest/components/howitwork_card.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  final List<Map<String, dynamic>> steps = const [
    {
      "title": "Browse & Select",
      "description": "Choose from our curated collection of designer outfits",
      "icon": Icons.search,
      "color": Color(0xFFFF6A2A),
    },
    {
      "title": "Choose Dates",
      "description": "Select your rental period (3-14 days)",
      "icon": Icons.calendar_month,
      "color": Colors.blue,
    },
    {
      "title": "Wear & Return",
      "description": "Free delivery, wear it, and we'll pick it up",
      "icon": Icons.local_shipping,
      "color": Color(0xFFFF6A2A),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: steps.map((item) {
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: HowItWorksCard(item: item),
            );
          }).toList(),
        ),
      ),
    );
  }
}
