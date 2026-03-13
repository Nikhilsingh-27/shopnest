import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/screens/singleproduct_screen.dart';

class TrendingcollectionCardForScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const TrendingcollectionCardForScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    String getLogoImageUrl(String? logoPath) {
      const String baseUrl = "https://www.dizaartdemo.com/";
      const String defaultImage =
          "${baseUrl}public/front/assets/img/list-8.jpg";

      if (logoPath == null || logoPath.trim().isEmpty) {
        return defaultImage;
      }

      final imageName = logoPath.split('/').last;
      if (imageName.isEmpty) return defaultImage;

      return "${baseUrl}demo/shopnest/assets/images/products/$imageName";
    }

    final name = item["name"] ?? "";
    final size = item["size"] ?? "N/A";
    final color = item["color"] ?? "N/A";
    final rentalPrice = item["rental_price"] ?? "0";
    final securityDeposit = item["security_deposit"] ?? "0";
    final discount = item["discount_percent"] ?? 0;
    final price = item["price"] ?? "0";
    final image = getLogoImageUrl(item["images"]);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// PRODUCT IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                image,
                width: double.infinity,
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
          ),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                /// SIZE
                Row(
                  children: [
                    const Icon(
                      Icons.straighten,
                      size: 18,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    Text("Size: $size", style: const TextStyle(fontSize: 14)),
                  ],
                ),

                const SizedBox(height: 6),

                /// COLOR
                Row(
                  children: [
                    const Icon(Icons.palette, size: 18, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text("Color: $color", style: const TextStyle(fontSize: 14)),
                  ],
                ),

                const SizedBox(height: 10),

                /// RENTAL PRICE
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                    children: [
                      const TextSpan(
                        text: "Rental: ",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: "₹$rentalPrice/day"),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                /// SECURITY DEPOSIT
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                    children: [
                      const TextSpan(
                        text: "Security: ",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: "₹$securityDeposit"),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                /// DISCOUNT
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                    children: [
                      const TextSpan(
                        text: "Discount: ",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: "$discount%"),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// FINAL PRICE
                Text(
                  "₹$price/day",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 14),

                /// BUTTONS
                Row(
                  children: [
                    /// DETAILS BUTTON
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Get.to(() => SingleproductScreen(item: item));
                        },
                        icon: const Icon(Icons.remove_red_eye),
                        label: const Text("Details"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.blue),
                          foregroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// ADD TO CART
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text("Add to Cart"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(0xFFff713b),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
