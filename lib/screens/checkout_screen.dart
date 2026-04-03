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

  // Price data from cart
  double subtotalWithGst = 0;
  double deliveryCharge = 0;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

    // Read arguments from cart screen
    final args = Get.arguments;
    if (args != null) {
      if (args['address'] != null) {
        addressController.text = args['address'].toString();
      }
      if (args['subtotalWithGst'] != null) {
        subtotalWithGst = (args['subtotalWithGst'] as num).toDouble();
      }
      if (args['delivery'] != null) {
        deliveryCharge = (args['delivery'] as num).toDouble();
      }
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void handlePaymentError(PaymentFailureResponse response) {
    CustomSnackbar.showSuccess("Payment Failed");
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    CustomSnackbar.showSuccess("Wallet Selected");
  }

  void openRazorpay(String razorpayOrderId, double totalAmount) {
    try {
      var options = {
        'key': 'rzp_test_SAOQiZzVCq4nYw',
        'amount': (totalAmount * 100).toInt(),
        'order_id': razorpayOrderId,
        'name': 'ShopNest',
        'description': 'Rental Payment',
        'prefill': {
          'contact': phoneController.text,
          'email': emailController.text,
        },
        'theme': {'color': '#6a7bd1'},
      };
      _razorpay.open(options);
    } catch (e) {
      CustomSnackbar.showError("Unable to open payment gateway");
    }
  }

  Future<void> handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      if (orderId == null) {
        CustomSnackbar.showError("Order ID missing");
        return;
      }
      final data = await verifyPayment(
        orderId: orderId!,
        razorpayPaymentId: response.paymentId ?? "",
        razorpayOrderId: response.orderId ?? "",
        razorpaySignature: response.signature ?? "",
      );
      if (data["status"] == true || data["success"] == true) {
        CustomSnackbar.showSuccess("Payment Successfull ✅");
        Get.offAll(Homescreen());
      } else {
        CustomSnackbar.showError(data["message"] ?? "Verification Failed");
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    }
  }

  final Dio dio = DioClient().dio;

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
      if (response.data == null) throw Exception("Empty response from server");
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?["message"] ?? e.message ?? "Checkout API error";
      throw Exception(errorMessage);
    }
  }

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
      if (response.data == null) throw Exception("Empty response from server");
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
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final instructionController = TextEditingController();
  final emailController = TextEditingController();

  // Field error states
  String? nameError;
  String? phoneError;
  String? emailError;
  String? addressError;

  bool validate() {
    bool isValid = true;

    setState(() {
      nameError = null;
      phoneError = null;
      emailError = null;
      addressError = null;
    });

    if (nameController.text.trim().isEmpty) {
      setState(() => nameError = "Full name is required");
      CustomSnackbar.showError("Please enter your full name");
      isValid = false;
    } else if (phoneController.text.trim().isEmpty) {
      setState(() => phoneError = "Phone number is required");
      CustomSnackbar.showError("Please enter your phone number");
      isValid = false;
    } else if (phoneController.text.trim().length != 10) {
      setState(() => phoneError = "Enter a valid 10-digit phone number");
      CustomSnackbar.showError("Phone number must be 10 digits");
      isValid = false;
    } else if (emailController.text.trim().isEmpty) {
      setState(() => emailError = "Email address is required");
      CustomSnackbar.showError("Please enter your email address");
      isValid = false;
    } else if (addressController.text.trim().isEmpty) {
      setState(() => addressError = "Delivery address is required");
      CustomSnackbar.showError("Please enter a delivery address");
      isValid = false;
    } else if (!agree) {
      CustomSnackbar.showError("Please accept the Terms & Conditions");
      isValid = false;
    } else if (getRentalDays() <= 0) {
      CustomSnackbar.showError("Return date must be after start date");
      isValid = false;
    }

    return isValid;
  }

  DateTime startDate = DateTime.now();
  DateTime returnDate = DateTime.now().add(const Duration(days: 3));

  int getRentalDays() => returnDate.difference(startDate).inDays;

  double getTotalWithDays() {
    return double.parse(
      (subtotalWithGst * getRentalDays() + deliveryCharge).toStringAsFixed(2),
    );
  }

  String paymentMethod = "razorpay";
  bool agree = false;

  // --------------- HELPERS ---------------

  InputDecoration _inputDecoration(
    String label,
    IconData icon, {
    String? errorText,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: hasError ? Colors.red.shade700 : Colors.black,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon: Icon(
        icon,
        color: hasError ? Colors.red.shade700 : Colors.black,
        size: 20,
      ),
      errorText: errorText,
      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
      filled: true,
      fillColor: hasError ? Colors.red.shade50 : const Color(0xFFF4F6FF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: hasError ? Colors.red.shade700 : Colors.black,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: hasError ? Colors.red.shade700 : Colors.black,
          width: hasError ? 1.5 : 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: hasError ? Colors.red.shade700 : Colors.black,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
    );
  }

  // --------------- UI ---------------

  @override
  Widget build(BuildContext context) {
    final rentalDays = getRentalDays();
    final totalPayable = getTotalWithDays();

    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // ─── HEADER GRADIENT ────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff6a7bd1), Color(0xff7a4fa3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Checkout",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Complete your rental order",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── DELIVERY INFORMATION ──────────────────
                  _sectionHeader(Icons.person_outline, "Contact Information"),
                  const SizedBox(height: 14),

                  TextField(
                    controller: nameController,
                    onChanged: (_) => setState(() => nameError = null),
                    decoration: _inputDecoration(
                      "Full Name",
                      Icons.person_outline,
                      errorText: nameError,
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => setState(() => phoneError = null),
                    decoration: _inputDecoration(
                      "Phone Number",
                      Icons.phone_outlined,
                      errorText: phoneError,
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: emailController,
                    onChanged: (_) => setState(() => emailError = null),
                    decoration: _inputDecoration(
                      "Email Address",
                      Icons.email_outlined,
                      errorText: emailError,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ─── DELIVERY ADDRESS ──────────────────────
                  _sectionHeader(
                    Icons.location_on_outlined,
                    "Delivery Address",
                  ),
                  const SizedBox(height: 14),

                  TextField(
                    controller: addressController,
                    maxLines: 3,
                    onChanged: (_) => setState(() => addressError = null),
                    decoration: _inputDecoration(
                      "Delivery Address",
                      Icons.home_outlined,
                      errorText: addressError,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ─── RENTAL DATES ──────────────────────────
                  _sectionHeader(
                    Icons.calendar_today_outlined,
                    "Rental Duration",
                  ),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _dateCard(
                          label: "Start Date",
                          date: startDate,
                          icon: Icons.flight_takeoff_rounded,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: startDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              builder: (context, child) => Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xff6a7bd1),
                                  ),
                                ),
                                child: child!,
                              ),
                            );
                            if (picked != null)
                              setState(() => startDate = picked);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _dateCard(
                          label: "Return Date",
                          date: returnDate,
                          icon: Icons.flight_land_rounded,
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: returnDate,
                              firstDate: startDate.add(const Duration(days: 1)),
                              lastDate: DateTime(2100),
                              builder: (context, child) => Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xff6a7bd1),
                                  ),
                                ),
                                child: child!,
                              ),
                            );
                            if (picked != null)
                              setState(() => returnDate = picked);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Rental Days Indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0FF),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xff6a7bd1).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          color: Color(0xff6a7bd1),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Rental Duration: ",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "$rentalDays ${rentalDays == 1 ? 'day' : 'days'}",
                          style: const TextStyle(
                            color: Color(0xff6a7bd1),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── ORDER SUMMARY ─────────────────────────
                  _sectionHeader(Icons.receipt_long_outlined, "Order Summary"),
                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff6a7bd1), Color(0xff7a4fa3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _summaryRow(
                          "Price per day (incl. GST)",
                          "₹${subtotalWithGst.toStringAsFixed(2)}",
                        ),
                        const SizedBox(height: 10),
                        _summaryRow(
                          "× $rentalDays ${rentalDays == 1 ? 'day' : 'days'}",
                          "₹${(subtotalWithGst * rentalDays).toStringAsFixed(2)}",
                        ),
                        const SizedBox(height: 10),
                        _summaryRow(
                          "Delivery Charge",
                          "+ ₹${deliveryCharge.toStringAsFixed(0)}",
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(color: Colors.white38),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Payable",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "₹$totalPayable",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── PAYMENT METHOD ────────────────────────
                  _sectionHeader(Icons.payment_outlined, "Payment Method"),
                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: _paymentMethodCard(
                          label: "Online Payment",
                          subtitle: "Razorpay",
                          icon: Icons.credit_card_rounded,
                          value: "razorpay",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _paymentMethodCard(
                          label: "Cash on Delivery",
                          subtitle: "Pay at door",
                          icon: Icons.money_rounded,
                          value: "cod",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ─── TERMS ────────────────────────────────
                  GestureDetector(
                    onTap: () => setState(() => agree = !agree),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: agree
                                ? const Color(0xff6a7bd1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xff6a7bd1)),
                          ),
                          child: agree
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "I agree to the Terms & Conditions and Rental Policy",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ─── CHECKOUT BUTTON ──────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
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
                                final data = res["data"];
                                orderId = data["order_id"].toString();

                                if (paymentMethod == "razorpay") {
                                  final razorpayOrder = data["razorpay_order"];
                                  if (razorpayOrder == null) {
                                    CustomSnackbar.showError(
                                      "Razorpay order not found",
                                    );
                                    return;
                                  }
                                  openRazorpay(
                                    razorpayOrder["id"],
                                    razorpayOrder["amount"].toDouble(),
                                  );
                                } else {
                                  CustomSnackbar.showSuccess(
                                    "Order placed successfully",
                                  );
                                }
                              } catch (e) {
                                CustomSnackbar.showError(e.toString());
                              } finally {
                                setState(() => isLoading = false);
                              }
                            },
                      icon: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.lock_outlined,
                              color: Colors.white,
                            ),
                      label: Text(
                        isLoading
                            ? "Processing..."
                            : "Confirm & Pay  ₹$totalPayable",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6a7bd1),
                        disabledBackgroundColor: const Color(
                          0xff6a7bd1,
                        ).withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Secure payment note
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Secured with 256-bit SSL encryption",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            const ShopFooter(),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xff6a7bd1), size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xff2c3e50),
          ),
        ),
      ],
    );
  }

  Widget _dateCard({
    required String label,
    required DateTime date,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xff6a7bd1).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xff6a7bd1), size: 16),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "${date.day} ${_monthName(date.month)} ${date.year}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xff2c3e50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _paymentMethodCard({
    required String label,
    required String subtitle,
    required IconData icon,
    required String value,
  }) {
    final isSelected = paymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => paymentMethod = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEEF0FF) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xff6a7bd1) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xff6a7bd1) : Colors.grey,
              size: 26,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xff6a7bd1) : Colors.black87,
                fontSize: 13,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
