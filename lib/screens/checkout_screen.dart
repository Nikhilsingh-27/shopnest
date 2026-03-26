import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:razorpay_flutter/razorpay_flutter.dart';
import "package:shopnest/components/custom_snackbar.dart";
import "package:shopnest/components/main_layout_drawer.dart";
import "package:shopnest/components/shopfooter_section.dart";
import "package:shopnest/core/network/dio_client.dart";
import "package:shopnest/screens/homescreen.dart";

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? orderId;
  late Razorpay _razorpay;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // ❌ Payment Failed
  void handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar("Payment Failed", response.message ?? "Something went wrong");
  }

  // 💳 Wallet
  void handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar("Wallet Selected", response.walletName ?? "");
  }

  // ✅ Open Razorpay
  void openRazorpay(String razorpayOrderId, double totalAmount) {
    try {
      var options = {
        'key': 'rzp_test_SAOQiZzVCq4nYw', // ✅ Only KEY_ID
        'amount': (totalAmount * 100).toInt(),
        'order_id': razorpayOrderId,
        'name': 'ShopNest',
        'description': 'Rental Payment',
        'prefill': {
          'contact': phoneController.text,
          'email': emailController.text,
        },
        'theme': {'color': '#ff834a'},
      };

      _razorpay.open(options);
    } catch (e) {
      Get.snackbar("Error", "Unable to open payment gateway");
    }
  }

  Future<void> handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      if (orderId == null) {
        Get.snackbar("Error", "Order ID missing");
        return;
      }

      final data = await verifyPayment(
        orderId: orderId!,
        razorpayPaymentId: response.paymentId ?? "",
        razorpayOrderId: response.orderId ?? "",
        razorpaySignature: response.signature ?? "",
      );
      print(data);
      if (data["status"] == true || data["success"] == true) {
        CustomSnackbar.showSuccess("Payment Verified ✅");
        Get.offAll(Homescreen());
      } else {
        CustomSnackbar.showError(data["message"] ?? "Verification Failed");
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    }
  }

  final Dio dio = DioClient().dio;
  // ✅ Checkout API
  Future<Map<String, dynamic>> checkout({
    required String name,
    required String phone,
    required String address,
    required DateTime startDate,
    required int rentalDays,
    required String paymentMethod,
  }) async {
    try {
      final response = await dio.post(
        "https://www.dizaartdemo.com/demo/shopnest/php-api-server/api/orders/checkout",
        data: {
          "name": name,
          "phone": phone,
          "address": address,
          "city": "Noida",
          "state": "UP",
          "pincode": "201301",
          "start_date": startDate.toString().split(" ")[0],
          "rental_days": rentalDays,
          "payment_method": paymentMethod,
        },
        options: Options(extra: {"requiresToken": true}),
      );

      if (response.data == null) {
        throw Exception("Empty response from server");
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?["message"] ?? e.message ?? "Checkout API error";

      throw Exception(errorMessage);
    }
  }

  // ✅ Payment Success
  Future<Map<String, dynamic>> verifyPayment({
    required String orderId,
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  }) async {
    try {
      final response = await dio.post(
        "https://www.dizaartdemo.com/demo/shopnest/php-api-server/api/orders/verify-payment",
        data: {
          "order_id": orderId,
          "razorpay_payment_id": razorpayPaymentId,
          "razorpay_order_id": razorpayOrderId,
          "razorpay_signature": razorpaySignature,
        },
        options: Options(extra: {"requiresToken": true}),
      );

      if (response.data == null) {
        throw Exception("Empty response from server");
      }

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?["message"] ??
          e.message ??
          "Payment verification failed";

      throw Exception(errorMessage);
    }
  }
  // ---------------- FORM ----------------

  final nameController = TextEditingController(text: "Nikhil");
  final phoneController = TextEditingController(text: "9315885136");
  final addressController = TextEditingController(text: "noida");
  final instructionController = TextEditingController();
  final emailController = TextEditingController(text: "test@gmail.com");

  bool validate() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Enter full name");
      return false;
    }

    if (phoneController.text.length != 10) {
      Get.snackbar("Error", "Enter valid phone number");
      return false;
    }

    if (addressController.text.isEmpty) {
      Get.snackbar("Error", "Enter address");
      return false;
    }

    if (!agree) {
      Get.snackbar("Error", "Accept terms & conditions");
      return false;
    }

    if (getRentalDays() <= 0) {
      Get.snackbar("Error", "Invalid rental dates");
      return false;
    }

    return true;
  }

  DateTime startDate = DateTime.now();
  DateTime returnDate = DateTime.now().add(const Duration(days: 3));

  int getRentalDays() {
    return returnDate.difference(startDate).inDays;
  }

  String paymentMethod = "razorpay";
  bool agree = false;

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Checkout",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  // 👤 Name
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Full Name"),
                  ),

                  const SizedBox(height: 10),

                  // 📞 Phone
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 📧 Email
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),

                  const SizedBox(height: 10),

                  // 📍 Address
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: "Address"),
                  ),

                  const SizedBox(height: 20),

                  // 📅 Start Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Start: ${startDate.toLocal().toString().split(' ')[0]}",
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: startDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => startDate = picked);
                          }
                        },
                        child: const Text("Select"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 📅 Return Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Return: ${returnDate.toLocal().toString().split(' ')[0]}",
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: returnDate,
                            firstDate: startDate.add(const Duration(days: 1)),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => returnDate = picked);
                          }
                        },
                        child: const Text("Select"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text("Rental Days: ${getRentalDays()}"),

                  const SizedBox(height: 20),

                  // 💳 Payment Method
                  const Text("Payment Method"),
                  Row(
                    children: [
                      Radio(
                        value: "razorpay",
                        groupValue: paymentMethod,
                        onChanged: (val) {
                          setState(() => paymentMethod = val!);
                        },
                      ),
                      const Text("Online (Razorpay)"),

                      Radio(
                        value: "cod",
                        groupValue: paymentMethod,
                        onChanged: (val) {
                          setState(() => paymentMethod = val!);
                        },
                      ),
                      const Text("Cash on Delivery"),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ✅ Terms
                  Row(
                    children: [
                      Checkbox(
                        value: agree,
                        onChanged: (val) {
                          setState(() => agree = val!);
                        },
                      ),
                      const Expanded(
                        child: Text("I agree to Terms & Conditions"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🚀 Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (!validate()) return;

                              try {
                                setState(() => isLoading = true);

                                final res = await checkout(
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  address: addressController.text,
                                  startDate: startDate,
                                  rentalDays: getRentalDays(),
                                  paymentMethod: paymentMethod,
                                );

                                // ✅ go inside "data"
                                final data = res["data"];

                                // ✅ store orderId
                                orderId = data["order_id"].toString();

                                if (paymentMethod == "razorpay") {
                                  final razorpayOrder = data["razorpay_order"];

                                  if (razorpayOrder == null) {
                                    Get.snackbar(
                                      "Error",
                                      "Razorpay order not found",
                                    );
                                    return;
                                  }

                                  openRazorpay(
                                    razorpayOrder["id"],
                                    razorpayOrder["amount"].toDouble(),
                                  );
                                } else {
                                  Get.snackbar(
                                    "Success",
                                    "Order placed successfully",
                                  );
                                }
                              } catch (e) {
                                Get.snackbar("Error", e.toString());
                              } finally {
                                setState(() => isLoading = false);
                              }
                            },
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Proceed to Payment"),
                    ),
                  ),
                ],
              ),
            ),

            const ShopFooter(),
          ],
        ),
      ),
    );
  }
}
