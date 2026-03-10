import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/components/cart_card.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> productlist = [
    {
      "image": "https://images.unsplash.com/photo-1523381294911-8d3cead13475",
      "title": "Casual Hoodie",
      "size": "L",
      "color": "Green",
      "rent": 900,
      "discount": 8,
      "finalPrice": 828,
    },
    {
      "image": "https://images.unsplash.com/photo-1509631179647-0177331693ae",
      "title": "Formal Suit",
      "size": "XL",
      "color": "Navy Blue",
      "rent": 3200,
      "discount": 20,
      "finalPrice": 2560,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.shopping_cart,
                        size: 36,
                        color: Colors.black87,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Your Rental Cart",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff2c3e50),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: productlist.map((product) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: CartCard(item: product),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// CONTINUE SHOPPING BUTTON
                      OutlinedButton.icon(
                        onPressed: () {
                          Get.toNamed("/rentclothes");
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.blue),
                        label: const Text(
                          "Continue Shopping",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// RENTAL SUMMARY CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: const LinearGradient(
                            colors: [Color(0xff6a7bd1), Color(0xff7a4fa3)],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// TITLE
                            const Row(
                              children: [
                                Icon(
                                  Icons.receipt_long,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Rental Summary",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            /// PRICE ROWS
                            _priceRow("Rental Subtotal:", "₹729.00"),
                            const SizedBox(height: 12),

                            _priceRow("Delivery Charge:", "₹99.00"),
                            const SizedBox(height: 12),

                            _priceRow("Tax (18% GST):", "₹131.22"),

                            const SizedBox(height: 20),

                            const Divider(color: Colors.white54),

                            const SizedBox(height: 15),

                            /// TOTAL
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Payable:",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "₹959.22",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            /// CHECKOUT BUTTON
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.credit_card),
                                label: const Text(
                                  "Proceed to Checkout",
                                  style: TextStyle(fontSize: 18),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      /// RENTAL POLICIES CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.shield_outlined),
                                SizedBox(width: 10),
                                Text(
                                  "Rental Policies",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 15),

                            Row(
                              children: [
                                Icon(Icons.check, color: Colors.green),
                                SizedBox(width: 10),
                                Text("Free pickup after rental"),
                              ],
                            ),

                            SizedBox(height: 10),

                            Row(
                              children: [
                                Icon(Icons.check, color: Colors.green),
                                SizedBox(width: 10),
                                Text("Professional cleaning included"),
                              ],
                            ),

                            SizedBox(height: 10),

                            Row(
                              children: [
                                Icon(Icons.check, color: Colors.green),
                                SizedBox(width: 10),
                                Text("Easy cancellation"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ShopFooter(),
          ],
        ),
      ),
    );
  }
}

Widget _priceRow(String title, String price) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
      Text(price, style: const TextStyle(color: Colors.white, fontSize: 18)),
    ],
  );
}
