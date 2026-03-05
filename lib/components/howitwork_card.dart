import 'package:flutter/material.dart';

class HowItWorksCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const HowItWorksCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 160,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item["icon"], size: 30, color: item["color"]),

          const SizedBox(height: 5),

          Text(
            item["title"],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            item["description"],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
