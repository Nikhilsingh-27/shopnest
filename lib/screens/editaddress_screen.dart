import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/components/custom_snackbar.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/data/repositories/auth_repository.dart';

class EditAddressScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditAddressScreen({super.key, required this.data});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final repo = Get.find<AuthRepository>();

  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController landmarkController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController pincodeController;

  late String addressType;
  late bool isDefault;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final d = widget.data;

    fullNameController = TextEditingController(text: d['full_name']);
    phoneController = TextEditingController(text: d['phone']);
    addressController = TextEditingController(text: d['address']);
    landmarkController = TextEditingController(text: d['landmark'] ?? "");
    cityController = TextEditingController(text: d['city']);
    stateController = TextEditingController(text: d['state']);
    pincodeController = TextEditingController(text: d['pincode']);

    addressType = d['address_type'] ?? "home";
    isDefault = d['is_default'] == 1;
  }

  Future<void> submit() async {
    setState(() => isLoading = true);

    try {
      final res = await repo.updateaddressfun(
        id: widget.data['id'].toString(),
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
          res["message"] ?? "Address updated successfully",
        );

        Navigator.pop(context, true);
      } else {
        CustomSnackbar.showError(res["message"] ?? "Update failed");
      }
    } catch (e) {
      CustomSnackbar.showError(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget input(
    String label,
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
              crossAxisAlignment: CrossAxisAlignment.start, // 👈 KEY
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 10),

                // 👇 TextField takes remaining space
                Expanded(
                  child: TextField(
                    controller: controller,
                    maxLines: maxLines,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      isCollapsed: true, // 👈 removes default padding
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
            /// 🧾 Heading
            const Text(
              "Edit Address",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
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
                    offset: Offset(0, 4),
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

                  input("Full Name", fullNameController, Icons.person),
                  input("Phone", phoneController, Icons.phone),
                  input("Address", addressController, Icons.home, maxLines: 3),
                  input("Landmark", landmarkController, Icons.place),
                  input("City", cityController, Icons.location_city),
                  input("State", stateController, Icons.map),
                  input("Pincode", pincodeController, Icons.pin_drop),

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
                        "Update Address",
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
