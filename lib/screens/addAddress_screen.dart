import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/components/custom_snackbar.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/data/repositories/auth_repository.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final repo = Get.find<AuthRepository>();

  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final landmarkController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();

  String addressType = "home";
  bool isDefault = false;

  bool isLoading = false;

  Future<void> submit() async {
    if (fullNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        cityController.text.isEmpty ||
        stateController.text.isEmpty ||
        pincodeController.text.isEmpty) {
      CustomSnackbar.showError("Please fill all required fields");
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await repo.addaddressfun(
        addressType: addressType,
        fullName: fullNameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        landmark: landmarkController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        pincode: pincodeController.text.trim(),
        isDefault: isDefault,
      );

      if (res["success"] == true) {
        CustomSnackbar.showSuccess(
          res["message"] ?? "Address added successfully",
        );
        Navigator.pop(context, true);
      } else {
        CustomSnackbar.showError(res["message"] ?? "Failed to add address");
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// 🔹 Input Field with Placeholder
  Widget input(
    String label,
    String hint,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    controller: controller,
                    maxLines: maxLines,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(color: Colors.grey.shade500),
                      isCollapsed: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Address Type Chip
  Widget addressTypeChip(String type, IconData icon) {
    final isSelected = addressType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => addressType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.black54),
              const SizedBox(height: 5),
              Text(
                type.capitalizeFirst!,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔙 Back Button
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),

            /// 🧾 Heading
            const Text(
              "Add Address",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            const Text(
              "Enter your delivery details",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// 📦 FORM CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  /// Address Type Chips
                  Row(
                    children: [
                      addressTypeChip("home", Icons.home),
                      const SizedBox(width: 10),
                      addressTypeChip("work", Icons.work),
                      const SizedBox(width: 10),
                      addressTypeChip("other", Icons.location_on),
                    ],
                  ),

                  const SizedBox(height: 20),

                  input(
                    "Full Name",
                    "Enter your full name",
                    fullNameController,
                    Icons.person,
                  ),
                  input(
                    "Phone",
                    "Enter your phone number",
                    phoneController,
                    Icons.phone,
                  ),
                  input(
                    "Address",
                    "House no, street, area",
                    addressController,
                    Icons.home,
                    maxLines: 3,
                  ),
                  input(
                    "Landmark",
                    "Nearby landmark (optional)",
                    landmarkController,
                    Icons.place,
                  ),
                  input(
                    "City",
                    "Enter your city",
                    cityController,
                    Icons.location_city,
                  ),
                  input(
                    "State",
                    "Enter your state",
                    stateController,
                    Icons.map,
                  ),
                  input(
                    "Pincode",
                    "Enter 6-digit pincode",
                    pincodeController,
                    Icons.pin_drop,
                  ),

                  const SizedBox(height: 10),

                  /// Default Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: isDefault,
                        activeColor: Colors.orange,
                        onChanged: (val) {
                          setState(() => isDefault = val!);
                        },
                      ),
                      const Text("Set as default address"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// 🚀 Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Address",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
