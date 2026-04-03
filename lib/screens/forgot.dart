import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/components/custom_snackbar.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/data/repositories/auth_repository.dart';
import 'package:shopnest/screens/homescreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool emailError = false;
  bool isLoading = false;

  void _generateLink() async {
    final email = _emailController.text.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    setState(() => emailError = false);

    if (email.isEmpty) {
      setState(() => emailError = true);
      CustomSnackbar.showError("Email address is required");
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      setState(() => emailError = true);
      CustomSnackbar.showError("Enter a valid email address");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await AuthRepository().forgotpassgentoken(email: email);

      setState(() => isLoading = false);

      if (response["success"] == true) {
        CustomSnackbar.showSuccess("Password Reset link sent to your email");
        Get.offAll(() => Homescreen());
      } else {
        CustomSnackbar.showError(
          response["message"] ?? "Failed to send reset link",
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      CustomSnackbar.showError(e.toString().replaceAll("Exception: ", ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return MainLayout(
      child: Scaffold(
        backgroundColor: const Color(0xfff4f4f4),
        body: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: width > 600 ? 480 : double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.key, size: 60, color: Colors.deepOrange),

                      const SizedBox(height: 15),

                      const Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "Enter your email to reset password",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 30),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Email Address",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 6),

                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) => setState(() => emailError = false),
                        decoration: InputDecoration(
                          hintText: "Enter your registered email",
                          prefixIcon: Icon(
                            Icons.email,
                            color: emailError ? Colors.red : Colors.grey,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: emailError ? Colors.red : Colors.grey,
                              width: emailError ? 1.5 : 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: emailError
                                  ? Colors.red
                                  : Colors.deepOrange,
                              width: 1.5,
                            ),
                          ),
                          errorText: emailError
                              ? "Please enter a valid email"
                              : null,
                          filled: true,
                          fillColor: emailError
                              ? Colors.red.shade50
                              : const Color(0xFFF9F9F9),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "We'll generate a password reset link for you",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: isLoading ? null : _generateLink,
                          icon: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.send),
                          label: Text(
                            isLoading ? "Sending..." : "Generate Reset Link",
                            style: const TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.deepOrange
                                .withOpacity(0.6),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Text.rich(
                          TextSpan(
                            text: "Remember your password? ",
                            children: [
                              TextSpan(
                                text: "Back to Login",
                                style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
