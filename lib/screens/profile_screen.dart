import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/components/custom_snackbar.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';
import 'package:shopnest/components/wishlist_card.dart';
import 'package:shopnest/data/repositories/auth_repository.dart';
import 'package:shopnest/screens/addAddress_screen.dart';
import 'package:shopnest/screens/editaddress_screen.dart';
import 'package:shopnest/screens/rentaldetail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthRepository repo = Get.find<AuthRepository>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isUpdatingProfile = false;
  bool isUpdatingPassword = false;

  String? currentPasswordError;
  String? newPasswordError;
  String? confirmPasswordError;

  List<Map<String, dynamic>> allRentals = [];
  List<Map<String, dynamic>> activeRentals = [];
  List<Map<String, dynamic>> pastRentals = [];

  Map<String, List<Map<String, dynamic>>> separateRentals(
    Map<String, dynamic> response,
  ) {
    final List rentals = response["data"]["all"] ?? [];

    for (var rental in rentals) {
      final status = (rental["status"] ?? "").toString().toLowerCase();

      // Add to ALL
      allRentals.add(Map<String, dynamic>.from(rental));

      // ACTIVE → shipped or paid
      if (status == "shipped" || status == "paid") {
        activeRentals.add(Map<String, dynamic>.from(rental));
      }
      // PAST → delivered or canceled
      else if (status == "delivered" || status == "cancelled") {
        pastRentals.add(Map<String, dynamic>.from(rental));
      }
    }

    return {"all": allRentals, "active": activeRentals, "past": pastRentals};
  }

  List all = [];
  List active = [];
  List past = [];
  List<dynamic> wishlistlist = [];
  List<dynamic> addressList = [];
  bool isLoading = true;
  Future<void> fetchAddresses() async {
    try {
      final res = await repo.getaddressfun();
      addressList = res['data'] ?? [];
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchwishlist() async {
    try {
      final res = await repo.getwishlistfun();
      wishlistlist = res['data'] ?? [];
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAndSeparateRentals() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await repo.getrentalstatusfun();

      final separatedData = separateRentals(response);
      print(separatedData);
      setState(() {
        allRentals = separatedData["all"]!;
        activeRentals = separatedData["active"]!;
        pastRentals = separatedData["past"]!;
      });
      print(allRentals);
      print("--------------------");
      print(activeRentals);
      print("-------------------");
      print(pastRentals);
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //fetchAndSeparateRentals();
    fetchAddresses();
    fetchwishlist();
    _loadProfile();

    final args = Get.arguments;

    if (args != null && args["select"] != null) {
      selectedMenu = args["select"];
    }
  }

  Future<void> _loadProfile() async {
    try {
      final response = await repo.getprofile();
      if (response["success"] == true && response["data"] != null) {
        final userData = response["data"] as Map<String, dynamic>;

        setState(() {
          nameController.text = userData["name"]?.toString() ?? "";
          emailController.text = userData["email"]?.toString() ?? "";
          phoneController.text = userData["phone"]?.toString() ?? "";
          addressController.text = userData["address"]?.toString() ?? "";
        });
      }
    } catch (e) {
      debugPrint("Failed to load profile: $e");
    }
  }

  String selectedMenu = "Profile";
  @override
  Widget build(BuildContext context) {
    /// GET ARGUMENT FROM DRAWER
    // if (!argsLoaded) {
    //   final args = Get.arguments;
    //
    //   if (args != null && args["select"] != null) {
    //     selectedMenu = args["select"];
    //   }
    //
    //   argsLoaded = true;
    // }
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// PAGE CONTENT WITH PADDING
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// PROFILE HEADER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 6),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.orange.shade200,
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Nikhil",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          "Member since Mar 2026",
                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 25),

                        /// IMPROVED MENU BUTTONS
                        Column(
                          children: [
                            _menuItem(Icons.person, "Profile", active: true),
                            _menuItem(Icons.shopping_bag, "My Rentals"),
                            _menuItem(Icons.favorite, "Wishlist"),
                            _menuItem(Icons.location_on, "Addresses"),
                            InkWell(
                              onTap: () {
                                Get.toNamed("/login");
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 16,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Colors.red,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 14),
                                    Text(
                                      "Logout",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  if (selectedMenu == "Profile") ...[
                    /// PROFILE SETTINGS
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 6),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.settings),
                              SizedBox(width: 10),
                              Text(
                                "Profile Settings",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "Personal Information",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          _inputField("Full Name", nameController),

                          _inputField(
                            "Email Address",
                            emailController,
                            enabled: false,
                          ),

                          const Text(
                            "Email cannot be changed",
                            style: TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 15),

                          _inputField("Phone Number", phoneController),

                          _inputField(
                            "Address",
                            addressController,
                            maxLines: 3,
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              disabledBackgroundColor: Colors.orange.shade200,
                            ),
                            onPressed: isUpdatingProfile
                                ? null
                                : () async {
                                    if (isUpdatingProfile) return;

                                    setState(() {
                                      isUpdatingProfile = true;
                                    });

                                    try {
                                      final result = await repo.updateProfile(
                                        name: nameController.text.trim(),
                                        phone: phoneController.text.trim(),
                                        address: addressController.text.trim(),
                                      );

                                      if (result["success"] == true) {
                                        CustomSnackbar.showSuccess(
                                          result["message"] ??
                                              "Profile updated successfully",
                                        );

                                        /// Optionally refresh profile from server.
                                        await _loadProfile();

                                        /// Wait for snackbar to disappear (3 seconds)
                                        await Future.delayed(
                                          const Duration(seconds: 3),
                                        );
                                      } else {
                                        CustomSnackbar.showError(
                                          result["message"] ??
                                              "Unable to update profile",
                                        );

                                        /// Wait for snackbar to disappear (3 seconds)
                                        await Future.delayed(
                                          const Duration(seconds: 3),
                                        );
                                      }
                                    } catch (e) {
                                      CustomSnackbar.showError(
                                        "Update failed: ${e.toString()}",
                                      );

                                      /// Wait for snackbar to disappear (3 seconds)
                                      await Future.delayed(
                                        const Duration(seconds: 3),
                                      );
                                    } finally {
                                      if (mounted) {
                                        setState(() {
                                          isUpdatingProfile = false;
                                        });
                                      }
                                    }
                                  },
                            icon: isUpdatingProfile
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: isUpdatingProfile
                                ? const Text("Updating...")
                                : const Text("Update Profile"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    /// CHANGE PASSWORD
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 6),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.lock),
                              SizedBox(width: 10),
                              Text(
                                "Change Password",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          _inputField(
                            "Current Password",
                            currentPasswordController,
                            obscure: true,
                            errorText: currentPasswordError,
                            onChanged: (_) {
                              setState(() => currentPasswordError = null);
                            },
                          ),

                          _inputField(
                            "New Password",
                            newPasswordController,
                            obscure: true,
                            errorText: newPasswordError,
                            onChanged: (_) {
                              setState(() => newPasswordError = null);
                            },
                          ),

                          _inputField(
                            "Confirm New Password",
                            confirmPasswordController,
                            obscure: true,
                            errorText: confirmPasswordError,
                            onChanged: (_) {
                              setState(() => confirmPasswordError = null);
                            },
                          ),

                          const SizedBox(height: 15),

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              disabledBackgroundColor: Colors.orange.shade200,
                            ),
                            onPressed: isUpdatingPassword
                                ? null
                                : () async {
                                    if (isUpdatingPassword) return;

                                    /// Clear previous errors
                                    setState(() {
                                      currentPasswordError = null;
                                      newPasswordError = null;
                                      confirmPasswordError = null;
                                    });

                                    /// Validation
                                    bool isValid = true;
                                    final currPass = currentPasswordController
                                        .text
                                        .trim();
                                    final newPass = newPasswordController.text
                                        .trim();
                                    final confirmPass =
                                        confirmPasswordController.text.trim();

                                    if (currPass.isEmpty) {
                                      setState(() {
                                        currentPasswordError =
                                            "Current password is required";
                                      });
                                      isValid = false;
                                    }

                                    if (newPass.isEmpty) {
                                      setState(() {
                                        newPasswordError =
                                            "New password is required";
                                      });
                                      isValid = false;
                                    } else if (newPass.length < 6) {
                                      setState(() {
                                        newPasswordError =
                                            "Password must be at least 6 characters";
                                      });
                                      isValid = false;
                                    }

                                    if (confirmPass.isEmpty) {
                                      setState(() {
                                        confirmPasswordError =
                                            "Confirm password is required";
                                      });
                                      isValid = false;
                                    }

                                    if (isValid && newPass != confirmPass) {
                                      setState(() {
                                        confirmPasswordError =
                                            "Passwords do not match";
                                      });
                                      isValid = false;
                                    }

                                    if (!isValid) {
                                      return;
                                    }

                                    setState(() {
                                      isUpdatingPassword = true;
                                    });

                                    try {
                                      final result = await repo.updatePassword(
                                        currPassword: currentPasswordController
                                            .text
                                            .trim(),
                                        newPassword: newPasswordController.text
                                            .trim(),
                                        confirmPassword:
                                            confirmPasswordController.text
                                                .trim(),
                                      );

                                      if (result["success"] == true) {
                                        CustomSnackbar.showSuccess(
                                          result["message"] ??
                                              "Password changed successfully",
                                        );

                                        currentPasswordController.clear();
                                        newPasswordController.clear();
                                        confirmPasswordController.clear();

                                        await Future.delayed(
                                          const Duration(seconds: 3),
                                        );
                                      } else {
                                        CustomSnackbar.showError(
                                          result["message"] ??
                                              "Unable to change password",
                                        );

                                        await Future.delayed(
                                          const Duration(seconds: 3),
                                        );
                                      }
                                    } catch (e) {
                                      CustomSnackbar.showError(
                                        "Error: ${e.toString()}",
                                      );

                                      await Future.delayed(
                                        const Duration(seconds: 3),
                                      );
                                    } finally {
                                      if (mounted) {
                                        setState(() {
                                          isUpdatingPassword = false;
                                        });
                                      }
                                    }
                                  },
                            icon: isUpdatingPassword
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.key),
                            label: isUpdatingPassword
                                ? const Text("Changing...")
                                : const Text("Change Password"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    /// STATS
                    Row(
                      children: [
                        Expanded(
                          child: _statCard(
                            Icons.inventory,
                            "0",
                            "Active Rentals",
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _statCard(
                            Icons.history,
                            "0",
                            "Past Rentals",
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _statCard(
                            Icons.favorite,
                            "0",
                            "Wishlist Items",
                            Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (selectedMenu == "Addresses") ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TITLE + ADD BUTTON
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.location_on),
                                SizedBox(width: 8),
                                Text(
                                  "My Addresses",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () async {
                                final res = await Get.to(
                                  () => const AddAddressScreen(),
                                );

                                if (res == true) {
                                  fetchAddresses(); // 🔄 refresh list
                                }
                              },
                              icon: const Icon(Icons.add),
                              label: const Text("Add New Address"),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// ADDRESS CARD
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : addressList.isEmpty
                            ? const Text("No Address Found")
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: addressList.length,
                                itemBuilder: (context, index) {
                                  return _addressCard(
                                    addressList[index],
                                    fetchAddresses,
                                  );
                                },
                              ),

                        const SizedBox(height: 25),

                        /// ADD NEW ADDRESS BOX
                        _addNewAddressBox(fetchAddresses),

                        const SizedBox(height: 25),

                        /// ADDRESS GUIDELINES
                        _addressGuidelines(),
                      ],
                    ),
                  ],
                  if (selectedMenu == "Wishlist") ...[
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Column(
                              children: wishlistlist.map((product) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: WishlistCard(
                                    item: product,
                                    onDelete: fetchwishlist,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// CONTINUE SHOPPING BUTTON
                                OutlinedButton.icon(
                                  onPressed: () {
                                    Get.toNamed("/rentclothes");
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.blue,
                                  ),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (selectedMenu == "My Rentals") ...[
                    /// TOP BUTTONS
                    RentalTopButtons(
                      onRentNew: () {
                        Get.toNamed("/rentclothes");
                      },
                    ),

                    const SizedBox(height: 20),

                    /// FILTER BUTTONS
                    RentalFilterButtons(),
                  ],
                ],
              ),
            ),

            /// FULL WIDTH FOOTER
            const ShopFooter(),
          ],
        ),
      ),
    );
  }

  /// MODERN MENU BUTTON
  Widget _menuItem(
    IconData icon,
    String title, {
    bool active = false,
    Color color = const Color(0xff2c3e50),
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: selectedMenu == title
            ? const Color(0xffff7a3d)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              selectedMenu = title;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selectedMenu == title ? Colors.white : color,
                  size: 22,
                ),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: selectedMenu == title ? Colors.white : color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// INPUT FIELD
  Widget _inputField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
    int maxLines = 1,
    bool obscure = false,
    String? errorText,
    Function(String)? onChanged,
  }) {
    final hasError = errorText != null && errorText.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            enabled: enabled,
            obscureText: obscure,
            maxLines: maxLines,
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.grey.shade300,
                  width: hasError ? 2 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasError ? Colors.red : Colors.orange,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                errorText!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// STAT CARD
  Widget _statCard(IconData icon, String value, String title, Color color) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),

            const SizedBox(height: 6),

            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
            ),
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

//---------------------------------------------------------------------
//Address widgets

// Widget _addressCard() {
//   return Container(
//     width: double.infinity,
//     padding: const EdgeInsets.all(20),
//     decoration: BoxDecoration(
//       color: Colors.grey.shade100,
//       borderRadius: BorderRadius.circular(15),
//       border: Border.all(color: Colors.orange, width: 2),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         /// TOP LABELS
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade100,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: const Row(
//                 children: [
//                   Icon(Icons.home, size: 16),
//                   SizedBox(width: 5),
//                   Text("Home"),
//                 ],
//               ),
//             ),
//
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               decoration: BoxDecoration(
//                 color: Colors.green,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: const Text(
//                 "Default",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 15),
//
//         const Text(
//           "Nikhil",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//
//         const SizedBox(height: 8),
//
//         const Row(
//           children: [
//             Icon(Icons.phone, size: 18),
//             SizedBox(width: 8),
//             Text("9315885136"),
//           ],
//         ),
//
//         const SizedBox(height: 6),
//
//         const Row(
//           children: [
//             Icon(Icons.location_on, size: 18),
//             SizedBox(width: 8),
//             Text("Noida"),
//           ],
//         ),
//
//         const SizedBox(height: 15),
//
//         Row(
//           children: [
//             /// EDIT BUTTON
//             OutlinedButton.icon(
//               onPressed: () {},
//               icon: const Icon(Icons.edit),
//               label: const Text("Edit"),
//             ),
//
//             const SizedBox(width: 10),
//
//             /// SET DEFAULT
//             OutlinedButton.icon(
//               onPressed: () {},
//               icon: const Icon(Icons.star),
//               label: const Text("Default"),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
Widget _addressCard(dynamic data, Function onRefresh) {
  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: data['is_default'] == 1 ? Colors.orange : Colors.grey.shade300,
        width: 2,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TOP LABELS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.home, size: 16),
                  const SizedBox(width: 5),
                  Text((data['address_type'] ?? 'home').toUpperCase()),
                ],
              ),
            ),

            if (data['is_default'] == 1)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Default",
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),

        const SizedBox(height: 15),

        Text(
          data['full_name'] ?? '',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            const Icon(Icons.phone, size: 18),
            const SizedBox(width: 8),
            Text(data['phone'] ?? ''),
          ],
        ),

        const SizedBox(height: 6),

        Row(
          children: [
            const Icon(Icons.location_on, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "${data['address'] ?? ''}, "
                "${data['city'] ?? ''}, "
                "${data['state'] ?? ''} - "
                "${data['pincode'] ?? ''}",
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () async {
                final res = await Get.to(() => EditAddressScreen(data: data));

                if (res == true) {
                  onRefresh(); // 🔄 refresh list
                }
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit"),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: data['is_default'] == 1
                  ? null
                  : () async {
                      try {
                        final res = await Get.find<AuthRepository>()
                            .setdefaultaddressfun(id: data['id'].toString());

                        if (res["success"] == true) {
                          CustomSnackbar.showSuccess(
                            res["message"] ?? "Default address updated",
                          );

                          /// 🔄 Refresh address list

                          onRefresh();
                        } else {
                          CustomSnackbar.showError(
                            res["message"] ??
                                "Failed to update default address",
                          );
                        }
                      } catch (e) {
                        CustomSnackbar.showError(e.toString());
                      }
                    },
              icon: const Icon(Icons.star),
              label: const Text("Set Default"),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: () {
                Get.defaultDialog(
                  title: "Delete Address",
                  middleText: "Are you sure you want to delete this address?",
                  textConfirm: "Delete",
                  textCancel: "Cancel",
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.red,
                  onConfirm: () async {
                    Get.back(); // close dialog

                    try {
                      final res = await Get.find<AuthRepository>()
                          .deleteaddressfun(id: data['id'].toString());

                      if (res["success"] == true) {
                        CustomSnackbar.showSuccess(
                          res["message"] ?? "Address deleted successfully",
                        );

                        onRefresh(); // 🔄 refresh list
                      } else {
                        CustomSnackbar.showError(
                          res["message"] ?? "Failed to delete address",
                        );
                      }
                    } catch (e) {
                      CustomSnackbar.showError(e.toString());
                    }
                  },
                );
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _addNewAddressBox(Function fetchAddresses) {
  return InkWell(
    onTap: () async {
      final res = await Get.to(() => const AddAddressScreen());

      if (res == true) {
        fetchAddresses(); // 🔄 refresh after adding
      }
    },
    borderRadius: BorderRadius.circular(15),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        children: const [
          Icon(Icons.add, size: 40, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "Add New Address",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text("Click to add a new delivery address"),
        ],
      ),
    ),
  );
}

Widget _addressGuidelines() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info),
            SizedBox(width: 8),
            Text(
              "Address Guidelines",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        SizedBox(height: 10),

        Text("• Ensure your address is accurate for smooth delivery"),
        Text("• Include landmark details for easy location"),
        Text("• Provide a working phone number for delivery updates"),
        Text("• You can have multiple addresses for different purposes"),
        Text("• Set one address as default for quicker checkout"),
      ],
    ),
  );
}

//--------------------------------------------------------------------

//---------------------------------------------------------------------
// My Rental

class RentalTopButtons extends StatelessWidget {
  final VoidCallback onRentNew;

  const RentalTopButtons({super.key, required this.onRentNew});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// LEFT SIDE (ICON + TITLE)
        Row(
          children: const [
            Icon(Icons.inventory_2_outlined, size: 20),
            SizedBox(width: 8),
            Text(
              "My Rentals",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),

        /// RIGHT SIDE BUTTON
        ElevatedButton.icon(
          onPressed: onRentNew,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Rent New Outfit",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF7A45),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }
}

class RentalFilterButtons extends StatefulWidget {
  const RentalFilterButtons({super.key});

  @override
  State<RentalFilterButtons> createState() => _RentalFilterButtonsState();
}

class _RentalFilterButtonsState extends State<RentalFilterButtons> {
  Widget buildRentalList(
    List<Map<String, dynamic>> rentals,
    Widget emptyWidget,
  ) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (rentals.isEmpty) {
      return emptyWidget;
    }

    return Column(
      children: rentals.map((rental) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RentalOrderCard(
            orderId: rental["id"].toString(),
            status: rental["status"],
            price: rental["total_price"],
            date: rental["start_date"],
            items: getTotalItemCount(rental["items"]),
            borderColor: Colors.grey,
            onViewDetails: () {
              Get.to(
                () => RentalDetailsScreen(
                  items: List<Map<String, dynamic>>.from(rental["items"]),
                  orderId: rental["id"].toString(),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  String getTotalItemCount(List<dynamic> items) {
    int total = 0;

    for (var item in items) {
      total += int.tryParse(item['quantity'].toString()) ?? 0;
    }

    return total.toString();
  }

  bool isLoading = true;
  String selectedFilter = "All Rentals";

  final List<String> filters = ["All Rentals", "Active", "Upcoming", "Past"];
  List<Map<String, dynamic>> allRentals = [];
  List<Map<String, dynamic>> activeRentals = [];
  List<Map<String, dynamic>> pastRentals = [];
  List<Map<String, dynamic>> upcomingRentals = [];

  final AuthRepository repo = Get.find<AuthRepository>();

  Map<String, List<Map<String, dynamic>>> separateRentals(
    Map<String, dynamic> response,
  ) {
    final List rentals = response["data"]["all"] ?? [];

    for (var rental in rentals) {
      final status = (rental["status"] ?? "").toString().toLowerCase();

      // Add to ALL
      allRentals.add(Map<String, dynamic>.from(rental));

      // ACTIVE → shipped or paid
      if (status == "shipped" || status == "paid") {
        activeRentals.add(Map<String, dynamic>.from(rental));
      }
      // PAST → delivered or canceled
      else if (status == "delivered" || status == "cancelled") {
        pastRentals.add(Map<String, dynamic>.from(rental));
      } else if (status == "pending") {
        upcomingRentals.add(Map<String, dynamic>.from(rental));
      }
    }

    return {"all": allRentals, "active": activeRentals, "past": pastRentals};
  }

  Future<void> fetchAndSeparateRentals() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await repo.getrentalstatusfun();

      final separatedData = separateRentals(response);
      print(separatedData);
      setState(() {
        allRentals = separatedData["all"]!;
        activeRentals = separatedData["active"]!;
        pastRentals = separatedData["past"]!;
      });
      print(allRentals);
      print("--------------------");
      print(activeRentals);
      print("-------------------");
      print(pastRentals);
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndSeparateRentals();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// FILTER BUTTONS
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((filter) {
              bool isSelected = selectedFilter == filter;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 24),
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    border: isSelected
                        ? const Border(
                            bottom: BorderSide(color: Colors.black, width: 2),
                          )
                        : null,
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.black : Colors.blue,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 20),

        /// RENTAL CARDS
        if (selectedFilter == "All Rentals") ...[
          buildRentalList(allRentals, const NoActiveRentals()),
        ],

        if (selectedFilter == "Active") ...[
          buildRentalList(activeRentals, const NoActiveRentals()),
        ],

        if (selectedFilter == "Upcoming") ...[
          buildRentalList(upcomingRentals, const NoUpcomingRentals()),
        ],

        if (selectedFilter == "Past") ...[
          buildRentalList(pastRentals, const NoPastRentals()),
        ],
        const SizedBox(height: 20),

        /// NEED HELP SECTION
        const NeedHelpSection(),
      ],
    );
  }
}

class NoActiveRentals extends StatelessWidget {
  const NoActiveRentals({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// ICON CIRCLE
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.access_time, size: 40, color: Colors.white),
          ),

          const SizedBox(height: 24),

          /// TITLE
          const Text(
            "No active rentals",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),

          /// DESCRIPTION
          const Text(
            "You don't have any active rentals at the moment.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class NoUpcomingRentals extends StatelessWidget {
  const NoUpcomingRentals({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// ICON CIRCLE
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.access_time, size: 40, color: Colors.white),
          ),

          const SizedBox(height: 24),

          /// TITLE
          const Text(
            "No Upcoming rentals",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),

          /// DESCRIPTION
          const Text(
            "You don't have any upcoming rentals scheduled.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class NoPastRentals extends StatelessWidget {
  const NoPastRentals({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// ICON CIRCLE
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.access_time, size: 40, color: Colors.white),
          ),

          const SizedBox(height: 24),

          /// TITLE
          const Text(
            "No Past rentals",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 12),

          /// DESCRIPTION
          const Text(
            "You haven't completed any rentals yet.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class RentalOrderCard extends StatelessWidget {
  final String orderId;
  final String status;
  final String price;
  final String date;
  final String items;
  final Color borderColor;
  final VoidCallback onViewDetails;

  const RentalOrderCard({
    super.key,
    required this.orderId,
    required this.status,
    required this.price,
    required this.date,
    required this.items,
    required this.borderColor,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          /// LEFT COLORED BORDER
          Container(
            width: 5,
            height: 140,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),

          /// CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ORDER + STATUS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff2d3e50),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "ORDER #0000$orderId",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// PRICE
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// DATE
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 6),
                      Text(date),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// ITEMS
                  Row(
                    children: [
                      const Icon(Icons.checkroom, size: 18),
                      const SizedBox(width: 6),
                      Text("$items items"),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// BUTTON
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: onViewDetails,
                      icon: const Icon(Icons.remove_red_eye, size: 18),
                      label: const Text("View Details"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NeedHelpSection extends StatelessWidget {
  const NeedHelpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE ROW
          Row(
            children: const [
              Icon(Icons.help_outline, size: 22),
              SizedBox(width: 8),
              Text(
                "Need Help?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// DESCRIPTION
          const Text(
            "If you have any questions about your rentals:",
            style: TextStyle(fontSize: 14),
          ),

          const SizedBox(height: 10),

          /// SUPPORT EMAIL
          const Text(
            "• Contact our support team at support@shopnest.com",
            style: TextStyle(fontSize: 14),
          ),

          const SizedBox(height: 6),

          /// PHONE
          const Text(
            "• Call us at +1 234 567 8900",
            style: TextStyle(fontSize: 14),
          ),

          const SizedBox(height: 6),

          /// FAQ LINK
          Row(
            children: const [
              Text("• Check our "),
              Text(
                "FAQ section",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
