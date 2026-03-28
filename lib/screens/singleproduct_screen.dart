import 'package:flutter/material.dart';
import 'package:shopnest/components/custom_snackbar.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';
import 'package:shopnest/data/repositories/auth_repository.dart';

class SingleproductScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const SingleproductScreen({super.key, required this.item});

  @override
  State<SingleproductScreen> createState() => _SingleproductScreenState();
}

class _SingleproductScreenState extends State<SingleproductScreen> {
  int quantity = 1;

  String? _asString(dynamic value) => value == null ? null : value.toString();

  String _nonNull(dynamic value, [String fallback = "N/A"]) =>
      _asString(value) ?? fallback;

  String _getImageUrl(String? imageName) {
    const String baseUrl = "https://www.dizaartdemo.com/";
    const String defaultImage = "${baseUrl}public/front/assets/img/list-8.jpg";

    if (imageName == null || imageName.trim().isEmpty) return defaultImage;

    final imageFile = imageName.split('/').last;
    if (imageFile.isEmpty) return defaultImage;

    return "${baseUrl}demo/shopnest/assets/images/products/$imageFile";
  }

  Future<void> addTowishlist() async {
    final productId = _nonNull(widget.item["id"], "");
    if (productId.isEmpty) {
      CustomSnackbar.showError("Product ID missing, cannot add to Wishlist.");
      return;
    }
    try {
      final response = await AuthRepository().addwishlistfun(id: productId);
      if (response["success"] == true) {
        CustomSnackbar.showSuccess("Product added to Wishlist successfully");
      } else {
        CustomSnackbar.showError(
          response["message"] ?? "Failed to add item to Wishlist",
        );
      }
    } catch (e) {
      CustomSnackbar.showError("Error adding to cart: $e");
    }
  }

  Future<void> addToCart(int quantityToAdd) async {
    final productId = _nonNull(widget.item["id"], "");
    if (productId.isEmpty) {
      CustomSnackbar.showError("Product ID missing, cannot add to cart.");
      return;
    }

    try {
      final response = await AuthRepository().addcartfun(
        id: productId,
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
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final imageUrl = _getImageUrl(_asString(item["images"] ?? item["image"]));
    final name = _nonNull(item["name"] ?? item["title"], "Unknown product");
    final size = _nonNull(item["size"]);
    final color = _nonNull(item["color"]);
    final rentalPrice = _nonNull(
      item["rental_price"] ?? item["rent"] ?? item["price"],
      "0",
    );
    final securityDeposit = _nonNull(item["security_deposit"] ?? "0", "0");
    final discount = _nonNull(
      item["discount_percent"] ?? item["discount"] ?? "0",
      "0",
    );
    final effectivePrice = _nonNull(
      item["effective_price"] ?? item["finalPrice"] ?? item["price"],
      "0",
    );
    final originalPrice = _nonNull(
      item["original_price"] ?? item["price"],
      "0",
    );
    final categoryName = _nonNull(
      item["category_name"] ?? item["category"],
      "Unknown category",
    );
    final stock = _nonNull(item["stock"] ?? "0", "0");

    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PRODUCT IMAGE
            Container(
              height: 350,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(
                  imageUrl,
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

            /// PRODUCT DETAILS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// SIZE
                  Row(
                    children: [
                      const Icon(Icons.straighten, size: 18),
                      const SizedBox(width: 6),
                      Text("Size: $size"),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// COLOR
                  Row(
                    children: [
                      const Icon(Icons.palette, size: 18),
                      const SizedBox(width: 6),
                      Text("Color: $color"),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// RENTAL PRICE
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      children: [
                        const TextSpan(
                          text: "Rental: ",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "₹$rentalPrice/day"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// SECURITY
                  Text(
                    "Security: ₹$securityDeposit",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  /// DISCOUNT
                  Text(
                    "Discount: $discount%",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// FINAL PRICE
                  Text(
                    "₹$effectivePrice/day",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Beautiful traditional red silk saree with zari work",
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 150,
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Icon(Icons.check, color: Colors.white),
                          SizedBox(width: 3),
                          Text(
                            "Available for Rent",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text("Only 2 left in stock"),
                  const SizedBox(height: 20),

                  /// QUANTITY SELECTOR
                  Row(
                    children: [
                      const Text("Quantity:", style: TextStyle(fontSize: 16)),

                      const SizedBox(width: 10),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              },
                              icon: const Icon(Icons.remove),
                            ),

                            Text(
                              quantity.toString(),
                              style: const TextStyle(fontSize: 16),
                            ),

                            IconButton(
                              onPressed: () {
                                setState(() {
                                  quantity++;
                                });
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  /// ADD TO CART BUTTON
                  Row(
                    children: [
                      /// ADD TO CART
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              addToCart(quantity);
                            },
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text(
                              "Add to Cart",
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// ADD TO WISHLIST
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              addTowishlist();
                            },
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            label: const Text(
                              "Add to Wishlist",
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// DESCRIPTION
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title Row
                        Row(
                          children: const [
                            Icon(Icons.info_outline, size: 22),
                            SizedBox(width: 8),
                            Text(
                              "Rental Information",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// Bullet Points
                        buildBullet("Free delivery & pickup included"),
                        buildBullet(
                          "Professional dry cleaning after every use",
                        ),
                        buildBullet("Flexible rental periods (3–14 days)"),
                        buildBullet("Quality check & ironing before delivery"),
                        buildBullet("Easy cancellation policy"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                const Text(
                  "Product Details",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                /// CARD 1
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      detailsRow("Category", categoryName),
                      const SizedBox(height: 12),

                      detailsRow("Size", size),
                      const SizedBox(height: 12),

                      detailsRow("Color", color),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// CARD 2
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      detailsRow("Product Price", "₹$originalPrice"),

                      const SizedBox(height: 12),

                      detailsRow("Rental Price", "₹$rentalPrice per day"),

                      const SizedBox(height: 12),

                      detailsRow(
                        "Security Deposit",
                        "₹$securityDeposit",
                        valueColor: Colors.red,
                      ),

                      const SizedBox(height: 12),

                      detailsRow(
                        "Availability",
                        stock,
                        valueColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ShopFooter(),
          ],
        ),
      ),
    );
  }
}

Widget detailsRow(String title, String value, {Color? valueColor}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),

      Text(
        value,
        style: TextStyle(fontSize: 16, color: valueColor ?? Colors.black87),
      ),
    ],
  );
}

Widget buildBullet(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("•", style: TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
      ],
    ),
  );
}
