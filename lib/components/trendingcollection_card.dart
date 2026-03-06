import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/screens/singleproduct_screen.dart';

class TrendingcollectionCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const TrendingcollectionCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE (NO PADDING)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              item["image"],
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          /// CONTENT WITH PADDING
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Text(
                      "Rental Price:",
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "₹${item["rent"]}/day",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("${item["discount"]}% OFF"),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Text(
                      "₹${item["finalPrice"]}",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text("/day"),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.to(SingleproductScreen(item: item));
                    },
                    icon: const Icon(Icons.remove_red_eye_outlined),
                    label: const Text("View Details"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
