import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopnest/components/custom_snackbar.dart';
import 'package:shopnest/data/repositories/auth_repository.dart';

class WishlistCard extends StatefulWidget {
  final VoidCallback onDelete;
  final Map<String, dynamic> item;

  const WishlistCard({super.key, required this.item, required this.onDelete});

  @override
  State<WishlistCard> createState() => _WishlistCardState();
}

class _WishlistCardState extends State<WishlistCard> {
  bool isAddingToCart = false;
  int quantity = 1;

  /// ✅ Extract first image safely
  String? _getFirstImage(dynamic imagesData) {
    if (imagesData is List && imagesData.isNotEmpty) {
      return imagesData[0].toString();
    } else if (imagesData is String) {
      try {
        final decoded = jsonDecode(imagesData);

        if (decoded is List && decoded.isNotEmpty) {
          return decoded[0].toString();
        } else {
          return imagesData;
        }
      } catch (e) {
        return imagesData;
      }
    }
    return null;
  }

  /// ✅ Image URL builder
  String _getImageUrl(String? imageName) {
    const String baseUrl = "https://www.dizaartdemo.com/";
    const String defaultImage = "${baseUrl}public/front/assets/img/list-8.jpg";

    if (imageName == null || imageName.trim().isEmpty) return defaultImage;

    final imageFile = imageName.split('/').last;
    if (imageFile.isEmpty) return defaultImage;

    return "${baseUrl}demo/shopnest/assets/images/products/$imageFile";
  }

  /// ✅ Add to cart with spam protection
  Future<void> addToCart(int quantityToAdd) async {
    if (isAddingToCart) return;

    setState(() => isAddingToCart = true);

    final productId = widget.item["product_id"];

    if (productId == null || productId == 0) {
      CustomSnackbar.showError("Product ID missing");
      setState(() => isAddingToCart = false);
      return;
    }

    try {
      final response = await AuthRepository().addcartfun(
        id: productId.toString(),
        quantity: quantityToAdd.toString(),
      );

      if (response["success"] == true) {
        CustomSnackbar.showSuccess("Added to cart");
        await Future.delayed(const Duration(seconds: 3));
      } else {
        CustomSnackbar.showError(response["message"] ?? "Failed");
      }
    } catch (e) {
      CustomSnackbar.showError("Error: $e");
    } finally {
      if (mounted) {
        setState(() => isAddingToCart = false);
      }
    }
  }

  /// ✅ Delete wishlist item
  Future<void> deletewishlist() async {
    final productId = widget.item["product_id"];

    if (productId == null || productId == 0) {
      CustomSnackbar.showError("Product ID missing");
      return;
    }

    try {
      final response = await AuthRepository().deletewishlist(
        id: productId.toString(),
      );

      if (response["success"] == true) {
        CustomSnackbar.showSuccess("Removed from wishlist");
        widget.onDelete();
      } else {
        CustomSnackbar.showError(response["message"] ?? "Failed");
      }
    } catch (e) {
      CustomSnackbar.showError("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstImage = _getFirstImage(
      widget.item["images"] ?? widget.item["image"],
    );

    final imageUrl = _getImageUrl(firstImage);

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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(imageUrl, fit: BoxFit.cover),
                  Container(color: Colors.black.withOpacity(0.3)),
                  Image.network(imageUrl, fit: BoxFit.contain),
                ],
              ),
            ),
          ),

          /// CONTENT
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item["name"] ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "₹${widget.item["effective_price"]}.00/day",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    /// ADD TO CART
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: isAddingToCart
                            ? null
                            : () => addToCart(quantity),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: const Color(0xFFff713b),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: isAddingToCart
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Add to Cart",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// DELETE
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: deletewishlist,
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
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
