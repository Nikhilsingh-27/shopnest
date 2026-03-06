import 'package:flutter/material.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';

class SingleproductScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const SingleproductScreen({super.key, required this.item});

  @override
  State<SingleproductScreen> createState() => _SingleproductScreenState();
}

class _SingleproductScreenState extends State<SingleproductScreen> {
  int quantity = 1;
  Map<String, dynamic> productDetails = {
    "category": "Traditional Wear",
    "size": "M",
    "color": "Gold",
    "productPrice": 0,
    "rentalPrice": 450,
    "securityDeposit": 0,
    "availability": "In Stock (2 available)",
  };
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PRODUCT IMAGE
              Container(
                height: 350,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(widget.item["image"], fit: BoxFit.cover),
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
                      widget.item["title"],
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
                        Text("Size: ${widget.item["size"]}"),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// COLOR
                    Row(
                      children: [
                        const Icon(Icons.palette, size: 18),
                        const SizedBox(width: 6),
                        Text("Color: ${widget.item["color"]}"),
                      ],
                    ),

                    const SizedBox(height: 15),

                    /// RENTAL PRICE
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(
                            text: "Rental: ",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: "₹${widget.item["rent"]}/day"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// SECURITY
                    const Text(
                      "Security: ₹2,500",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// DISCOUNT
                    Text(
                      "Discount: ${widget.item["discount"]}%",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// FINAL PRICE
                    Text(
                      "₹${widget.item["finalPrice"]}/day",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

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
                              onPressed: () {},
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
                              onPressed: () {},
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
                    const Text(
                      "Product Description",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "This designer outfit is perfect for weddings, parties, and special occasions. "
                      "Made with high quality fabric and elegant design to give you a premium look. "
                      "Rent it for your special day and enjoy luxury fashion at an affordable price.",
                      style: TextStyle(fontSize: 15, height: 1.5),
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
                        detailsRow("Category", productDetails["category"]),
                        const SizedBox(height: 12),

                        detailsRow("Size", productDetails["size"]),
                        const SizedBox(height: 12),

                        detailsRow("Color", productDetails["color"]),
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
                        detailsRow(
                          "Product Price",
                          "₹${productDetails["productPrice"]}.00",
                        ),

                        const SizedBox(height: 12),

                        detailsRow(
                          "Rental Price",
                          "₹${productDetails["rentalPrice"]}.00 per day",
                        ),

                        const SizedBox(height: 12),

                        detailsRow(
                          "Security Deposit",
                          "₹${productDetails["securityDeposit"]}.00",
                          valueColor: Colors.red,
                        ),

                        const SizedBox(height: 12),

                        detailsRow(
                          "Availability",
                          productDetails["availability"],
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
