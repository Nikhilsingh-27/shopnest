import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:new_app/data/services/authentication_service.dart';
import 'package:shopnest/components/custom_snackbar.dart';

class ShopNestLogin extends StatefulWidget {
  const ShopNestLogin({super.key});

  @override
  State<ShopNestLogin> createState() => _ShopNestLoginState();
}

class _ShopNestLoginState extends State<ShopNestLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool isLoading = false;

  bool emailError = false;
  bool passwordError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// ================= LOGIN LOGIC =================
  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    setState(() {
      emailError = false;
      passwordError = false;
    });

    if (email.isEmpty) {
      setState(() => emailError = true);
      CustomSnackbar.showError("Email address is required");
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      setState(() => emailError = true);
      CustomSnackbar.showError("Please enter a valid email address");
      return;
    }

    if (password.isEmpty) {
      setState(() => passwordError = true);
      CustomSnackbar.showError("Password is required");
      return;
    }

    setState(() => isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      setState(() => isLoading = false);

      CustomSnackbar.showSuccessSlow("Login successful!");
      Get.offAllNamed("/home");
    } catch (e) {
      setState(() => isLoading = false);
      CustomSnackbar.showError("Invalid credentials. Please try again.");
    }
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: width > 600 ? 450 : double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// ICON
                    const Icon(
                      Icons.login_rounded,
                      size: 60,
                      color: Colors.deepOrange,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Login to your ShopNest account",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// EMAIL
                    _buildTextField(
                      label: "Email Address",
                      hint: "Enter your email",
                      controller: _emailController,
                      error: emailError,
                      icon: Icons.email,
                    ),

                    const SizedBox(height: 18),

                    /// PASSWORD
                    _buildPasswordField(),

                    const SizedBox(height: 15),

                    /// REMEMBER + FORGOT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                            const Text("Remember me"),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed("/forgot");
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// LOGIN BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _handleLogin,
                        icon: const Icon(Icons.login),
                        label: const Text(
                          "Login",
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

                    const SizedBox(height: 25),

                    /// REGISTER LINK
                    GestureDetector(
                      onTap: () => Get.toNamed("/signup"),
                      child: const Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          children: [
                            TextSpan(
                              text: "Register here",
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
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
  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool error,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
              BorderSide(color: error ? Colors.red : Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
              BorderSide(color: error ? Colors.red : Colors.deepOrange),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Password",
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: "Enter your password",
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
              BorderSide(color: passwordError ? Colors.red : Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
              BorderSide(color: passwordError ? Colors.red : Colors.deepOrange),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}