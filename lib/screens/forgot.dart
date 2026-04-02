import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/components/custom_snackbar.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/data/repositories/auth_repository.dart';

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
        CustomSnackbar.showSuccess(response["message"] ?? "Success");
        final token = response["data"]?["token"];
        if (token != null) {
          Get.to(() => ResetPasswordScreen(token: token));
        } else {
          CustomSnackbar.showError("Token not provided by server");
        }
      } else {
        CustomSnackbar.showError(response["message"] ?? "Failed");
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
                      _buildStepper(activeStep: 1),

                      const SizedBox(height: 25),

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
                        decoration: InputDecoration(
                          hintText: "Enter your registered email",
                          prefixIcon: const Icon(Icons.email),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: emailError ? Colors.red : Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: emailError
                                  ? Colors.red
                                  : Colors.deepOrange,
                            ),
                          ),
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
                          onPressed: _generateLink,
                          icon: const Icon(Icons.send),
                          label: const Text(
                            "Generate Reset Link",
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
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper({required int activeStep}) {
    Widget step(int number, String title) {
      bool active = number == activeStep;
      return Column(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: active ? Colors.deepOrange : Colors.grey.shade300,
            child: Text(
              "$number",
              style: TextStyle(color: active ? Colors.white : Colors.black),
            ),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        step(1, "Enter Email"),
        step(2, "Reset Password"),
        step(3, "Complete"),
      ],
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  final String token;
  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isLoading = false;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  void _resetPassword() async {
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (newPass.isEmpty || confirmPass.isEmpty) {
      CustomSnackbar.showError("Please fill all fields");
      return;
    }

    if (newPass != confirmPass) {
      CustomSnackbar.showError("Passwords do not match");
      return;
    }

    if (newPass.length < 6) {
      CustomSnackbar.showError("Password must be at least 6 characters");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await AuthRepository().resetpassword(
        token: widget.token,
        newpassword: newPass,
        confirmpass: confirmPass,
      );

      setState(() => isLoading = false);

      if (response["success"] == true) {
        CustomSnackbar.showSuccess(response["message"] ?? "Password updated");
        Get.offAllNamed("/login");
      } else {
        CustomSnackbar.showError(response["message"] ?? "Failed");
      }
    } catch (e) {
      setState(() => isLoading = false);
      CustomSnackbar.showError(e.toString().replaceAll("Exception: ", ""));
    }
  }

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
                width: width > 600 ? 480 : double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    _buildStepper(),
                    const SizedBox(height: 25),
                    const Icon(
                      Icons.lock_reset,
                      size: 60,
                      color: Colors.deepOrange,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Set New Password",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Enter your new password below",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 25),

                    // New Password
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "New Password",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _newPasswordController,
                      obscureText: _obscureNew,
                      decoration: InputDecoration(
                        hintText: "Enter new password",
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNew
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureNew = !_obscureNew;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Confirm Password",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        hintText: "Confirm your password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirm = !_obscureConfirm;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: const Text(
                          "Reset Password",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    GestureDetector(
                      onTap: () => Get.offAllNamed("/login"),
                      child: const Text(
                        "← Back to Login",
                        style: TextStyle(color: Colors.blue),
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

  Widget _buildStepper() {
    Widget step(int number, String title, bool active) {
      return Column(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: active ? Colors.deepOrange : Colors.grey.shade300,
            child: Text(
              "$number",
              style: TextStyle(color: active ? Colors.white : Colors.black),
            ),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        step(1, "Enter Email", true),
        step(2, "Reset Password", true),
        step(3, "Complete", false),
      ],
    );
  }
}
