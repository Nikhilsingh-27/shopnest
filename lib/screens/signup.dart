import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:new_app/data/services/authentication_service.dart';
import 'package:shopnest/components/custom_snackbar.dart';
import 'package:shopnest/components/main_layout_drawer.dart';

class ShopNestSignup extends StatefulWidget {
  const ShopNestSignup({super.key});

  @override
  State<ShopNestSignup> createState() => _ShopNestSignupState();
}

class _ShopNestSignupState extends State<ShopNestSignup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool isLoading = false;

  bool nameError = false;
  bool emailError = false;
  bool phoneError = false;
  bool addressError = false;
  bool passwordError = false;
  bool confirmPasswordError = false;
  bool termsError = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// ================= VALIDATION =================
  Future<void> _handleSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    setState(() {
      nameError = false;
      emailError = false;
      phoneError = false;
      addressError = false;
      passwordError = false;
      confirmPasswordError = false;
      termsError = false;
    });

    if (name.isEmpty) {
      setState(() => nameError = true);
      CustomSnackbar.showError("Full Name is required");
      return;
    }

    if (email.isEmpty) {
      setState(() => emailError = true);
      CustomSnackbar.showError("Email is required");
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      setState(() => emailError = true);
      CustomSnackbar.showError("Enter a valid email address");
      return;
    }

    if (phone.isEmpty) {
      setState(() => phoneError = true);
      CustomSnackbar.showError("Phone number is required");
      return;
    }

    if (address.isEmpty) {
      setState(() => addressError = true);
      CustomSnackbar.showError("Delivery address is required");
      return;
    }

    if (password.isEmpty) {
      setState(() => passwordError = true);
      CustomSnackbar.showError("Password is required");
      return;
    }

    if (password.length < 6) {
      setState(() => passwordError = true);
      CustomSnackbar.showError("Password must be at least 6 characters");
      return;
    }

    if (confirmPassword.isEmpty) {
      setState(() => confirmPasswordError = true);
      CustomSnackbar.showError("Confirm your password");
      return;
    }

    if (password != confirmPassword) {
      setState(() => confirmPasswordError = true);
      CustomSnackbar.showError("Passwords do not match");
      return;
    }

    if (!_agreeToTerms) {
      setState(() => termsError = true);
      CustomSnackbar.showError("Please accept Rental Terms & Conditions");
      return;
    }

    setState(() => isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      setState(() => isLoading = false);

      CustomSnackbar.showSuccessSlow("Account created successfully!");
      Get.offAllNamed("/home");
    } catch (e) {
      setState(() => isLoading = false);
      CustomSnackbar.showError("Something went wrong. Try again.");
    }
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return MainLayout(
      //backgroundColor: const Color(0xfff4f4f4),
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: width > 600 ? 500 : double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    const Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_add_alt_1,
                            size: 60,
                            color: Colors.deepOrange,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Join ShopNest Rentals",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Rent premium clothing for every occasion",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    _buildTextField(
                      "Full Name",
                      "Enter your full name",
                      _nameController,
                      nameError,
                      Icons.person,
                    ),

                    _buildTextField(
                      "Email",
                      "Enter your email",
                      _emailController,
                      emailError,
                      Icons.email,
                    ),

                    _buildTextField(
                      "Phone Number",
                      "Enter phone number",
                      _phoneController,
                      phoneError,
                      Icons.phone,
                    ),

                    _buildTextField(
                      "Delivery Address",
                      "Enter your complete address for delivery",
                      _addressController,
                      addressError,
                      Icons.home,
                      maxLines: 3,
                    ),

                    _buildPasswordField(
                      "Password",
                      "Create password",
                      _passwordController,
                      passwordError,
                      _obscurePassword,
                      () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),

                    _buildPasswordField(
                      "Confirm Password",
                      "Confirm password",
                      _confirmPasswordController,
                      confirmPasswordError,
                      _obscureConfirmPassword,
                      () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// WHY RENT SECTION
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, size: 18),
                              SizedBox(width: 8),
                              Text(
                                "Why Rent with Us?",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "✓ Rent designer clothes at 10% of retail price",
                          ),
                          Text("✓ Free delivery & pickup"),
                          Text("✓ Professional dry cleaning included"),
                          Text("✓ Flexible rental periods"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// TERMS
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (val) {
                            setState(() {
                              _agreeToTerms = val ?? false;
                              termsError = false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            "I agree to the Rental Terms & Conditions",
                            style: TextStyle(
                              color: termsError ? Colors.red : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _handleSignup,
                        icon: const Icon(Icons.person_add),
                        label: const Text(
                          "Create Account",
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: const Text.rich(
                          TextSpan(
                            text: "Already have an account? ",
                            children: [
                              TextSpan(
                                text: "Login here",
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  /// ================= COMMON TEXT FIELD =================
  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
    bool error,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: error ? Colors.red : Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: error ? Colors.red : Colors.deepOrange,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    String hint,
    TextEditingController controller,
    bool error,
    bool obscure,
    VoidCallback toggle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: toggle,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: error ? Colors.red : Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: error ? Colors.red : Colors.deepOrange,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
