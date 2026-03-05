import 'package:flutter/material.dart';

class BrowsemycategoryCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onPressed;

  const BrowsemycategoryCard({
    super.key,
    required this.item,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item["icon"], size: 60, color: const Color(0xFFFF6A2A)),

          const SizedBox(height: 20),

          Text(
            item["title"],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 10),

          Text(
            item["description"],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onPressed,
              child: Text(item["buttonText"]),
            ),
          ),
        ],
      ),
    );
  }
}
