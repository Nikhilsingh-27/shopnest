import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const StatsCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: const Border(
          top: BorderSide(color: Color(0xFFFF6A33), width: 4),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: color),

          const SizedBox(height: 5),

          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
