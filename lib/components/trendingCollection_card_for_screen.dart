import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/modules/controllers/cart_controller.dart';
import 'package:shopnest/screens/singleproduct_screen.dart';

class TrendingcollectionCardForScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  TrendingcollectionCardForScreen({super.key, required this.item});

  final CartController cartController = Get.put(CartController());

  String _getImageUrl(String? imageName) {
    const String baseUrl = "https://www.dizaartdemo.com/";
    const String defaultImage = "${baseUrl}public/front/assets/img/list-8.jpg";

    if (imageName == null || imageName.trim().isEmpty) return defaultImage;

    final imageFile = imageName.split('/').last;
    if (imageFile.isEmpty) return defaultImage;

    return "${baseUrl}demo/shopnest/assets/images/products/$imageFile";
  }

  @override
  Widget build(BuildContext context) {
    final name = item["name"] ?? "";
    final size = item["size"] ?? "N/A";
    final color = item["color"] ?? "N/A";
    final rentalPrice = item["rental_price"] ?? "0";
    final securityDeposit = item["security_deposit"] ?? "0";
    final discount = item["discount_percent"] ?? 0;
    final price = item["price"] ?? "0";
    final images = item["images"];

    String? imageName;
    if (images is List && images.isNotEmpty) {
      imageName = images[0];
    }

    final image = _getImageUrl(imageName);
    final id = item["id"].toString();

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
          /// IMAGE (INCREASED HEIGHT)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  /// 🔥 Background (blurred fill)
                  Image.network(image, fit: BoxFit.cover),

                  /// 🔥 Dark overlay (optional)
                  Container(color: Colors.black.withOpacity(0.3)),

                  /// ✅ Actual image (full visible)
                  Image.network(image, fit: BoxFit.contain),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.straighten, size: 18),
                    const SizedBox(width: 6),
                    Text("Size: $size"),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    const Icon(Icons.palette, size: 18),
                    const SizedBox(width: 6),
                    Text("Color: $color"),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  "₹$price/day",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    /// DETAILS
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Get.to(() => SingleproductScreen(item: item));
                        },
                        icon: const Icon(Icons.remove_red_eye),
                        label: const Text(
                          "Details",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// ADD TO CART (🔥 REACTIVE)
                    Expanded(
                      flex: 2,
                      child: Obx(() {
                        bool isLoading =
                            cartController.addingItems[id] ?? false;

                        return ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () => cartController.addToCart(id),

                          icon: const Icon(Icons.add_shopping_cart),

                          label: isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text("Add to Cart"),

                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: const Color(0xFFff713b),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        );
                      }),
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
