import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:shopnest/components/main_layout_drawer.dart";
import "package:shopnest/components/shopfooter_section.dart";

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final nameController = TextEditingController(text: "Nikhil");
  final phoneController = TextEditingController(text: "9315885136");
  final addressController = TextEditingController(text: "noida");
  final instructionController = TextEditingController();

  DateTime startDate = DateTime(2026, 3, 11);
  DateTime returnDate = DateTime(2026, 3, 14);
  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  int getRentalDays() {
    return returnDate.difference(startDate).inDays;
  }

  String paymentMethod = "card";
  bool agree = false;

  void printData() {
    print("Start Date: $startDate");
    print("Return Date: $returnDate");
    print("Name: ${nameController.text}");
    print("Phone: ${phoneController.text}");
    print("Address: ${addressController.text}");
    print("Instructions: ${instructionController.text}");
    print("Payment Method: $paymentMethod");
    print("Agree Terms: $agree");
  }

  Widget inputField(label, controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  Widget dateBox(String label, DateTime value, bool isStart) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2024),
                lastDate: DateTime(2030),
              );

              if (picked != null) {
                String formatted =
                    "${picked.month}/${picked.day}/${picked.year}";

                if (picked != null) {
                  setState(() {
                    if (isStart) {
                      startDate = picked;
                    } else {
                      returnDate = picked;
                    }
                  });
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDate(value)),
                  const Icon(Icons.calendar_today, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget deliverySection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.local_shipping),
              SizedBox(width: 10),
              Text(
                "Delivery Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 10),
                    Text(
                      "Rental Period",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    dateBox("Start Date", startDate, true),
                    const SizedBox(width: 20),
                    dateBox("Return Date", returnDate, false),
                  ],
                ),

                const SizedBox(height: 10),

                Center(child: Text("Rental period: ${getRentalDays()} days")),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Shipping Address",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          inputField("Full Name", nameController),

          const SizedBox(height: 15),

          inputField("Phone Number", phoneController),

          const SizedBox(height: 15),

          inputField("Address", addressController),

          const SizedBox(height: 15),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Special Instructions (Optional)"),
              const SizedBox(height: 8),
              TextField(
                controller: instructionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText:
                      "Any special delivery instructions, timing preferences...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Row(
            children: [
              Icon(Icons.credit_card),
              SizedBox(width: 10),
              Text(
                "Payment Method",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 10),

          RadioListTile(
            value: "card",
            groupValue: paymentMethod,
            title: const Text("Credit/Debit Card"),
            onChanged: (v) {
              setState(() {
                paymentMethod = v!;
              });
            },
          ),

          RadioListTile(
            value: "cod",
            groupValue: paymentMethod,
            title: const Text("Cash on Delivery"),
            onChanged: (v) {
              setState(() {
                paymentMethod = v!;
              });
            },
          ),

          RadioListTile(
            value: "upi",
            groupValue: paymentMethod,
            title: const Text("UPI"),
            onChanged: (v) {
              setState(() {
                paymentMethod = v!;
              });
            },
          ),

          Row(
            children: [
              Checkbox(
                value: agree,
                onChanged: (v) {
                  setState(() {
                    agree = v!;
                  });
                },
              ),
              const Text("I agree to the "),
              const Text(
                "Rental Terms & Conditions",
                style: TextStyle(color: Colors.orange),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text("Back to Cart"),
              ),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 16,
                  ),
                  backgroundColor: Color(0xFFff834a),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  printData();
                },
                icon: const Icon(Icons.lock, color: Colors.white),
                label: const Text(
                  "Proceed to Payment",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget orderSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt),
              SizedBox(width: 10),
              Text(
                "Order Summary",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    "https://www.dizaartdemo.com/demo/shopnest/assets/images/products/1769865956_697e02e4654a0.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("tyvtgvtgvt"),
                  Text("Qty: 1"),
                  Text("₹1,600.00", style: TextStyle(color: Colors.blue)),
                ],
              ),
            ],
          ),

          const Divider(height: 30),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Rental Subtotal:"), Text("₹1,600.00")],
          ),

          const SizedBox(height: 8),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Delivery Charge:"), Text("₹99.00")],
          ),

          const SizedBox(height: 8),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("GST (18%):"), Text("₹288.00")],
          ),

          const Divider(height: 30),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Payable:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "₹1,987.00",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.credit_card, size: 30),
                      SizedBox(width: 10),
                      Text(
                        "Checkout",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  deliverySection(),

                  orderSummary(),
                ],
              ),
            ),

            // Footer without padding
            const ShopFooter(),
          ],
        ),
      ),
    );
  }
}
