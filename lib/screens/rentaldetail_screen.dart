import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';

class RentalDetailsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String orderId;
  final String totalPrice;

  const RentalDetailsScreen({
    super.key,
    required this.items,
    required this.orderId,
    required this.totalPrice,
  });

  String getImageUrl(String? imageName) {
    const String baseUrl = "https://www.dizaartdemo.com/";
    const String defaultImage = "${baseUrl}public/front/assets/img/list-8.jpg";

    if (imageName == null || imageName.trim().isEmpty) return defaultImage;

    // Handle JSON stringified arrays like ["image.jpg"]
    String imageFile = "";
    if (imageName.startsWith("[") && imageName.endsWith("]")) {
      try {
        final List<dynamic> images = jsonDecode(imageName);
        if (images.isNotEmpty) {
          imageFile = images[0].toString();
        }
      } catch (e) {
        // Fallback to simple split if decode fails
        imageFile = imageName.split('/').last;
      }
    } else {
      imageFile = imageName.split('/').last;
    }

    if (imageFile.isEmpty) return defaultImage;

    return "${baseUrl}demo/shopnest/assets/images/products/$imageFile";
  }

  double getTotalPrice() {
    double total = 0;
    for (var item in items) {
      final price = double.tryParse(item["price"].toString()) ?? 0;
      final qty = int.tryParse(item["quantity"].toString()) ?? 0;
      total += price * qty;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: items.isEmpty
          ? const Center(child: Text("No items found"))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 MAIN CONTENT WITH PADDING
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        /// 🔹 HEADING
                        Text(
                          "Order Details",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "Order #$orderId",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 🔹 ITEMS TITLE
                        Text(
                          "Items",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// 🔹 ITEMS LIST
                        Column(
                          children: items.map((item) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  /// IMAGE
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: SizedBox(
                                      height: 80,
                                      width: 80,
                                      child: Image.network(
                                        getImageUrl(item["images"]),
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: Colors.grey[300],
                                          alignment: Alignment.center,
                                          child: const Icon(
                                            Icons.image_not_supported,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  /// DETAILS
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item["product_name"],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "Quantity: ${item["quantity"]}",
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "₹${item["price"]}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 20),

                        /// 🔹 PRICE SUMMARY
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _buildPriceRow(
                                "Total Items",
                                items.length.toString(),
                              ),
                              const SizedBox(height: 8),
                              _buildPriceRow(
                                "Total Price",
                                "₹$totalPrice",
                                isBold: true,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  /// 🔥 FOOTER WITHOUT PADDING
                  ShopFooter(),
                ],
              ),
            ),
    );
  }

  Widget _buildPriceRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
