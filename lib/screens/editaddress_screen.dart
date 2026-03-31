import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
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
  bool fullNameError = false;
  bool phoneError = false;
  bool addressError = false;
  bool cityError = false;
  bool stateError = false;
  bool pincodeError = false;
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

  /// 🚀 GET CURRENT LOCATION (SAME AS ADD SCREEN)
  Future<void> getCurrentLocation() async {
    try {
      setState(() => isLoading = true);

      var status = await Permission.location.request();

      if (status.isDenied) {
        CustomSnackbar.showError("Location permission denied");
        return;
      }

      if (status.isPermanentlyDenied) {
        openAppSettings();
        return;
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        CustomSnackbar.showError("Please enable location services");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];

      /// ✅ Autofill
      addressController.text =
          "${place.street}, ${place.subLocality}, ${place.locality}";
      cityController.text = place.locality ?? "";
      stateController.text = place.administrativeArea ?? "";
      pincodeController.text = place.postalCode ?? "";

      CustomSnackbar.showSuccess("Location fetched successfully");
    } catch (e) {
      CustomSnackbar.showError("Failed to get location");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> submit() async {
    final phone = phoneController.text.trim();

    final phoneRegex = RegExp(r'^[0-9]{10}$');
    final pincodeRegex = RegExp(r'^[0-9]{6}$');

    setState(() {
      fullNameError = false;
      phoneError = false;
      addressError = false;
      cityError = false;
      stateError = false;
      pincodeError = false;
    });

    /// 🔴 VALIDATIONS WITH STATE UPDATE

    if (fullNameController.text.trim().isEmpty) {
      setState(() => fullNameError = true);
      CustomSnackbar.showError("Full Name required");
      return;
    }

    if (phone.isEmpty) {
      setState(() => phoneError = true);
      CustomSnackbar.showError("Phone required");
      return;
    }

    if (!phoneRegex.hasMatch(phone)) {
      setState(() => phoneError = true);
      CustomSnackbar.showError("Phone must be exactly 10 digits");
      return;
    }

    if (addressController.text.trim().isEmpty) {
      setState(() => addressError = true);
      CustomSnackbar.showError("Address required");
      return;
    }

    if (cityController.text.trim().isEmpty) {
      setState(() => cityError = true);
      CustomSnackbar.showError("City required");
      return;
    }

    if (stateController.text.trim().isEmpty) {
      setState(() => stateError = true);
      CustomSnackbar.showError("State required");
      return;
    }

    if (pincodeController.text.trim().isEmpty) {
      setState(() => pincodeError = true);
      CustomSnackbar.showError("Pincode required");
      return;
    }

    if (!pincodeRegex.hasMatch(pincodeController.text.trim())) {
      setState(() => pincodeError = true);
      CustomSnackbar.showError("Pincode must be 6 digits");
      return;
    }

    /// 🚀 API CALL
    setState(() => isLoading = true);

    try {
      final res = await repo.updateaddressfun(
        id: widget.data['id'].toString(),
        addressType: addressType,
        fullName: fullNameController.text.trim(),
        phone: phone,
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
      CustomSnackbar.showError("Something went wrong");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget input(
    String label,
    String hint,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
    bool showLocationButton = false,
    bool error = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (showLocationButton)
                ElevatedButton.icon(
                  onPressed: isLoading ? null : getCurrentLocation,
                  icon: const Icon(Icons.my_location, size: 14),
                  label: const Text("Use Current"),
                ),
            ],
          ),
          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),

              /// 🔴 ERROR BORDER
              border: Border.all(
                color: error ? Colors.red : Colors.grey.shade300,
                width: error ? 1.5 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: error ? Colors.red : Colors.grey.shade700,
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    controller: controller,
                    maxLines: maxLines,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    textAlignVertical: TextAlignVertical.top,

                    /// 🔥 AUTO REMOVE ERROR
                    onChanged: (value) {
                      if (error && onChanged != null) {
                        onChanged(value);
                      }
                    },

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

          /// 👇 ERROR TEXT BELOW FIELD
          if (error)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 6),
              child: Text(
                "This field is required",
                style: const TextStyle(color: Colors.red, fontSize: 12),
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
            const Text(
              "Edit Address",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

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
                    "Enter full name",
                    fullNameController,
                    Icons.person,
                    error: fullNameError,
                    onChanged: (_) {
                      if (fullNameError) {
                        setState(() => fullNameError = false);
                      }
                    },
                  ),

                  input(
                    "Phone",
                    "Enter phone",
                    phoneController,
                    Icons.phone,
                    error: phoneError,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onChanged: (_) {
                      if (phoneError) {
                        setState(() => phoneError = false);
                      }
                    },
                  ),

                  input(
                    "Address",
                    "House, street",
                    addressController,
                    Icons.home,
                    maxLines: 3,
                    showLocationButton: true,
                    error: addressError,
                  ),

                  input(
                    "Landmark",
                    "Nearby landmark",
                    landmarkController,
                    Icons.place,
                    error: false,
                  ), // optional field → no validation

                  input(
                    "City",
                    "City",
                    cityController,
                    Icons.location_city,
                    error: cityError,
                  ),

                  input(
                    "State",
                    "State",
                    stateController,
                    Icons.map,
                    error: stateError,
                  ),

                  input(
                    "Pincode",
                    "Pincode",
                    pincodeController,
                    Icons.pin_drop,
                    error: pincodeError,
                  ),

                  const SizedBox(height: 10),

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
