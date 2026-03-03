import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/components/custom_snackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool emailError = false;
  bool isLoading = false;

  void _generateLink() async {
    final email = _emailController.text.trim();
    final emailRegex =
    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

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

    await Future.delayed(const Duration(seconds: 2));

    setState(() => isLoading = false);

    Get.to(() => const ResetLinkScreen());
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildStepper(activeStep: 1),

                    const SizedBox(height: 25),

                    const Icon(Icons.key,
                        size: 60, color: Colors.deepOrange),

                    const SizedBox(height: 15),

                    const Text("Forgot Password",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),

                    const SizedBox(height: 6),

                    const Text(
                      "Enter your email to reset password",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 30),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Email Address",
                          style: TextStyle(
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 6),

                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Enter your registered email",
                        prefixIcon: const Icon(Icons.email),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                          borderSide: BorderSide(
                              color: emailError
                                  ? Colors.red
                                  : Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                          borderSide: BorderSide(
                              color: emailError
                                  ? Colors.red
                                  : Colors.deepOrange),
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(40),
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
                                    fontWeight:
                                    FontWeight.bold))
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
                child:
                CircularProgressIndicator(color: Colors.white),
              ),
            )
        ],
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
            backgroundColor:
            active ? Colors.deepOrange : Colors.grey.shade300,
            child: Text("$number",
                style: TextStyle(
                    color: active
                        ? Colors.white
                        : Colors.black)),
          ),
          const SizedBox(height: 6),
          Text(title,
              style: const TextStyle(fontSize: 14))
        ],
      );
    }

    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceEvenly,
      children: [
        step(1, "Enter Email"),
        step(2, "Reset Password"),
        step(3, "Complete"),
      ],
    );
  }
}


class ResetLinkScreen extends StatelessWidget {
  const ResetLinkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    const resetLink =
        "http://www.dizaartdemo.com/shopnest_with_id/user/forgot-password.php?token=example123456";

    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      body: Center(
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

                const Icon(Icons.key,
                    size: 60, color: Colors.deepOrange),

                const SizedBox(height: 15),

                const Text("Forgot Password",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold)),

                const SizedBox(height: 6),

                const Text(
                  "Copy the reset link below",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 25),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.deepOrange,
                        style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      const Text("Reset Link:",
                          style: TextStyle(
                              fontWeight:
                              FontWeight.bold)),
                      const SizedBox(height: 10),
                      SelectableText(
                        resetLink,
                        style: const TextStyle(
                            color: Colors.pink),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          CustomSnackbar.showSuccess(
                              "Link copied!");
                        },
                        child: const Text("Copy Link"),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time, size: 18),
                    SizedBox(width: 6),
                    Text("This link expires in 1 hour"),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      Colors.deepOrange,
                      padding:
                      const EdgeInsets.symmetric(
                          vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            40),
                      ),
                    ),
                    child:
                    const Text("Open Reset Link"),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Get.offAll(
                              () => const ForgotPasswordScreen());
                    },
                    child:
                    const Text("Generate New Link"),
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () => Get.offAllNamed("/login"),
                  child: const Text("← Back to Login",
                      style: TextStyle(
                          color: Colors.blue)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepper() {
    Widget step(int number, String title,
        bool active) {
      return Column(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: active
                ? Colors.green
                : Colors.grey.shade300,
            child: Text("$number",
                style: TextStyle(
                    color: active
                        ? Colors.white
                        : Colors.black)),
          ),
          const SizedBox(height: 6),
          Text(title,
              style: const TextStyle(fontSize: 14))
        ],
      );
    }

    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceEvenly,
      children: [
        step(1, "Enter Email", true),
        step(2, "Reset Password", false),
        step(3, "Complete", false),
      ],
    );
  }
}