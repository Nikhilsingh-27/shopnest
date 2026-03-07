import 'package:flutter/material.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController documentController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  String? selectedIdType;
  String? selectedFileName;

  List<String> idTypes = [
    "Aadhar Card",
    "PAN Card",
    "Passport",
    "Driving License",
  ];

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime(2000),
    );

    if (pickedDate != null) {
      dobController.text =
          "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}";
    }
  }

  void submitForm() {
    if (_formKey.currentState!.validate() && selectedFileName != null) {
      print("ID Type: $selectedIdType");
      print("Document Number: ${documentController.text}");
      print("Full Name: ${nameController.text}");
      print("DOB: ${dobController.text}");
      print("File: $selectedFileName");
    } else if (selectedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload front side image")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// PAGE CONTENT WITH PADDING
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// Title
                  Row(
                    children: const [
                      Icon(Icons.badge_outlined, size: 26),
                      SizedBox(width: 10),
                      Text(
                        "ID Verification",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Card Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Submit ID Proof",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            "Upload a clear image of your government ID",
                            style: TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 20),

                          /// ID Type
                          const Text("ID Type"),
                          const SizedBox(height: 6),

                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            hint: const Text("Select Document"),
                            value: selectedIdType,
                            items: idTypes
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                            validator: (value) =>
                                value == null ? "Please select ID type" : null,
                            onChanged: (value) {
                              setState(() {
                                selectedIdType = value;
                              });
                            },
                          ),

                          const SizedBox(height: 16),

                          /// Document Number
                          const Text("Document Number"),
                          const SizedBox(height: 6),

                          TextFormField(
                            controller: documentController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value!.isEmpty
                                ? "Document number required"
                                : null,
                          ),

                          const SizedBox(height: 16),

                          /// Full Name
                          const Text("Full Name (as on document)"),
                          const SizedBox(height: 6),

                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Full name required" : null,
                          ),

                          const SizedBox(height: 16),

                          /// Date of Birth
                          const Text("Date of Birth"),
                          const SizedBox(height: 6),

                          TextFormField(
                            controller: dobController,
                            readOnly: true,
                            onTap: pickDate,
                            decoration: const InputDecoration(
                              hintText: "mm/dd/yyyy",
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "DOB required" : null,
                          ),

                          const SizedBox(height: 20),

                          /// Upload File
                          const Text("Front Side Image (Required)"),
                          const SizedBox(height: 8),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedFileName = "id_image.jpg";
                                    });
                                  },
                                  child: const Text("Choose file"),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    selectedFileName ?? "No file chosen",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            "Max 5MB. JPG, PNG, PDF only.",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),

                          const SizedBox(height: 24),

                          /// Buttons
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: submitForm,
                                icon: const Icon(
                                  Icons.upload,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Submit for Verification",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 14,
                                  ),
                                  backgroundColor: Color(0xFF0d6efd),
                                ),
                              ),

                              const SizedBox(width: 12),

                              ElevatedButton(
                                onPressed: () {
                                  _formKey.currentState!.reset();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                ),

                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
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
}
