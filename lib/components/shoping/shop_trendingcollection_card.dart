import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/components/custom_snackbar.dart';
import 'package:shopnest/data/repositories/auth_repository.dart';
import 'package:shopnest/screens/singleproduct_screen.dart';

class TrendingcollectionCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const TrendingcollectionCard({super.key, required this.item});
  // print(item["description"]);
  /// 🚀 FETCH PRODUCT BY ID
  Future<void> handleViewDetails() async {
    final productId = item["id"]?.toString();
    print(item["id"]);
    print(item["description"]);
    if (productId == null || productId.isEmpty) {
      CustomSnackbar.showError("Product ID missing");
      return;
    }

    try {
      final response = await AuthRepository().getproductbyidfun(id: productId);

      Get.to(SingleproductScreen(item: response["data"] ?? response));
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      constraints: const BoxConstraints(
        minHeight: 400, // 🔥 ensures Spacer works properly
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🖼 IMAGE
          /// 🖼 SQUARE IMAGE (NO STRETCH, FULL COVER)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: AspectRatio(
              aspectRatio: 1, // 🔥 perfect square
              child: Stack(
                fit: StackFit.expand,
                children: [
                  /// 🔥 Background blurred-style fill
                  Image.network(
                    item["image"] ?? "",
                    fit: BoxFit.cover, // fills entire square
                  ),

                  /// 🔥 Dark overlay for premium look
                  Container(color: Colors.black.withOpacity(0.25)),

                  /// ✅ Foreground image (FULL visible, no crop)
                  Image.network(
                    item["image"] ?? "",
                    fit: BoxFit.contain, // 👈 complete image visible
                  ),

                  /// ❌ Error fallback
                  Positioned.fill(
                    child: (item["image"] == null || item["image"] == "")
                        ? Container(
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: const Icon(Icons.image_not_supported),
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
            ),
          ),

          /// 📦 CONTENT
          Expanded(
            // 🔥 IMPORTANT (gives height to use Spacer)
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🏷 TITLE
                  Text(
                    item["title"] ?? "No Title",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// 💰 RENT
                  // Row(
                  //   children: [
                  //     const Text(
                  //       "Original Price:",
                  //       style: TextStyle(fontSize: 14, color: Colors.black54),
                  //     ),
                  //     const SizedBox(width: 6),
                  //     Text(
                  //       "₹${item["original_price"] ?? 0}",
                  //       style: const TextStyle(
                  //         fontSize: 16,
                  //         color: Colors.blue,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  //const SizedBox(height: 10),

                  //
                  Row(
                    children: [
                      const Text(
                        "MRP :",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "₹${item["market_price"] ?? 0}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description :",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        // 🔥 important to prevent overflow
                        child: Text(
                          "${item["description"] ?? ""}",
                          maxLines: 3, // ✅ only 3 lines
                          overflow: TextOverflow.ellipsis, // ✅ show ...
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // /// 🔥 DISCOUNT
                  // if ((item["discount"] ?? 0) > 0)
                  //   Container(
                  //     padding: const EdgeInsets.symmetric(
                  //       horizontal: 10,
                  //       vertical: 4,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       color: Colors.orange,
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: Text(
                  //       "${item["discount"]}% OFF",
                  //       style: const TextStyle(
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ),
                  //
                  // const SizedBox(height: 12),
                  //
                  // /// 💵 FINAL PRICE
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  //   children: [
                  //     Text(
                  //       "₹${item["finalPrice"] ?? 0}",
                  //       style: const TextStyle(
                  //         fontSize: 26,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.green,
                  //       ),
                  //     ),
                  //     const SizedBox(width: 4),
                  //     const Text("/day", style: TextStyle(fontSize: 14)),
                  //   ],
                  // ),

                  /// 🚀 PUSH BUTTON TO BOTTOM
                  const Spacer(),

                  /// 👁 VIEW BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: handleViewDetails,
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                      label: const Text("View Details"),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
