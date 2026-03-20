import 'package:flutter/material.dart';
import 'package:shopnest/components/custom_snackbar.dart';
import 'package:shopnest/data/repositories/auth_repository.dart';

class CartCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onDeleteSuccess;
  const CartCard({
    super.key,
    required this.item,
    required this.onDeleteSuccess,
  });

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

    final AuthRepository repo = AuthRepository();
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
          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              getLogoImageUrl(item["images"]),
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
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
                  item["name"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                /// SIZE
                // Row(
                //   children: [
                //     const Icon(
                //       Icons.straighten,
                //       size: 18,
                //       color: Colors.black54,
                //     ),
                //     const SizedBox(width: 6),
                //     Text(
                //       "Size: ${item["size"]}",
                //       style: const TextStyle(fontSize: 14),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 6),

                /// COLOR
                // Row(
                //   children: [
                //     const Icon(Icons.palette, size: 18, color: Colors.black54),
                //     const SizedBox(width: 6),
                //     Text(
                //       "Color: ${item["color"]}",
                //       style: const TextStyle(fontSize: 14),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 10),

                /// RENT
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
                      TextSpan(text: "₹${item["price"]}.00/day"),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                /// SECURITY
                // RichText(
                //   text: TextSpan(
                //     style: const TextStyle(fontSize: 15, color: Colors.black87),
                //     children: [
                //       const TextSpan(
                //         text: "Security: ",
                //         style: TextStyle(
                //           color: Colors.red,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //       const TextSpan(text: "₹2,500.00"),
                //     ],
                //   ),
                // ),
                //
                // const SizedBox(height: 4),

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
                      TextSpan(text: "${item["discount_percent"]}%"),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                    children: [
                      const TextSpan(
                        text: "Quantity: ",
                        style: TextStyle(
                          color: Color(0xFF6a6fd5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: "${item["quantity"]}"),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                /// FINAL PRICE
                Text(
                  "₹${item["line_total"]}.00/day",
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
                    /// Delete BUTTON
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          try {
                            final res = await repo.deletecartfun(
                              id: item["id"].toString(), // ✅ important
                            );

                            if (res["success"] == true) {
                              CustomSnackbar.showSuccess(
                                "Item removed from cart",
                              );

                              onDeleteSuccess();
                              // 👉 OPTIONAL: refresh UI (very important)
                              // You need to remove item from list or call API again
                            } else {
                              CustomSnackbar.showError(
                                res["message"] ?? "Failed",
                              );
                            }
                          } catch (e) {
                            CustomSnackbar.showError(e.toString());
                          }
                        },
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.red, // background color
                          side: const BorderSide(
                            color: Colors.red,
                          ), // border color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
