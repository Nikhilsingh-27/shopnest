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
  bool isAddingToCart = false; // ✅ loading state

  int quantity = 1;

  Future<void> addToCart(int quantityToAdd) async {
    if (isAddingToCart) return; // ✅ prevent multiple clicks

    setState(() {
      isAddingToCart = true;
    });

    final productId = widget.item["product_id"];

    if (productId == null || productId == 0) {
      CustomSnackbar.showError("Product ID missing, cannot add to cart.");
      setState(() => isAddingToCart = false);
      return;
    }

    try {
      final response = await AuthRepository().addcartfun(
        id: productId.toString(),
        quantity: quantityToAdd.toString(),
      );

      if (response["success"] == true) {
        CustomSnackbar.showSuccess("Product added to cart successfully");
      } else {
        CustomSnackbar.showError(
          response["message"] ?? "Failed to add item to cart",
        );
      }
    } catch (e) {
      CustomSnackbar.showError("Error adding to cart: $e");
    }

    // ✅ wait for snackbar duration (~3 sec)
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        isAddingToCart = false;
      });
    }
  }

  Future<void> deletewishlist() async {
    final productId = widget.item["product_id"];

    if (productId == null || productId == 0) {
      CustomSnackbar.showError("Product ID missing, cannot Delete.");
      return;
    }

    try {
      final response = await AuthRepository().deletewishlist(
        id: productId.toString(),
      );

      if (response["success"] == true) {
        CustomSnackbar.showSuccess("Product removed successfully");
        widget.onDelete();
      } else {
        CustomSnackbar.showError(
          response["message"] ?? "Failed to remove item",
        );
      }
    } catch (e) {
      CustomSnackbar.showError("Error in removing: $e");
    }
  }

  String? _asString(dynamic value) => value == null ? null : value.toString();

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
    final imageUrl = _getImageUrl(
      _asString(widget.item["images"] ?? widget.item["image"]),
    );

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
            child: SizedBox(
              height: 220,
              width: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
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
                Text(
                  widget.item["name"],
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
                                  Icon(Icons.add_shopping_cart),
                                  SizedBox(width: 6),
                                  Text("Add to Cart"),
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
