import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';
import 'package:shopnest/components/wishlist_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController(
    text: "Nikhil",
  );

  final TextEditingController emailController = TextEditingController(
    text: "unidentifiedemail1597@gmail.com",
  );

  final TextEditingController phoneController = TextEditingController(
    text: "9315885136",
  );

  final TextEditingController addressController = TextEditingController(
    text: "noida",
  );
  final List<Map<String, dynamic>> productlist = [
    {
      "image": "https://images.unsplash.com/photo-1490481651871-ab68de25d43d",
      "title": "Wedding Lehenga",
      "size": "M",
      "color": "Pink",
      "rent": 5000,
      "discount": 30,
      "finalPrice": 3500,
    },
    {
      "image": "https://images.unsplash.com/photo-1523381294911-8d3cead13475",
      "title": "Casual Hoodie",
      "size": "L",
      "color": "Green",
      "rent": 900,
      "discount": 8,
      "finalPrice": 828,
    },
    {
      "image": "https://images.unsplash.com/photo-1509631179647-0177331693ae",
      "title": "Formal Suit",
      "size": "XL",
      "color": "Navy Blue",
      "rent": 3200,
      "discount": 20,
      "finalPrice": 2560,
    },
  ];
  String selectedMenu = "Profile";
  @override
  Widget build(BuildContext context) {
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
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.save),
                            label: const Text("Update Profile"),
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
                            TextEditingController(),
                            obscure: true,
                          ),

                          _inputField(
                            "New Password",
                            TextEditingController(),
                            obscure: true,
                          ),

                          _inputField(
                            "Confirm New Password",
                            TextEditingController(),
                            obscure: true,
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
                            ),
                            onPressed: () {},
                            icon: const Icon(Icons.key),
                            label: const Text("Change Password"),
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
                  if (selectedMenu == "Addresses") ...[_addressSection()],
                  if (selectedMenu == "Wishlist") ...[
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            child: Column(
                              children: productlist.map((product) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: WishlistCard(item: product),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        enabled: enabled,
        obscureText: obscure,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
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

//---------------------------------------------------------------------
//Address widgets
Widget _addressSection() {
  return Column(
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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text("Add New Address"),
          ),
        ],
      ),

      const SizedBox(height: 20),

      /// ADDRESS CARD
      _addressCard(),

      const SizedBox(height: 25),

      /// ADD NEW ADDRESS BOX
      _addNewAddressBox(),

      const SizedBox(height: 25),

      /// ADDRESS GUIDELINES
      _addressGuidelines(),
    ],
  );
}

Widget _addressCard() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.orange, width: 2),
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
              child: const Row(
                children: [
                  Icon(Icons.home, size: 16),
                  SizedBox(width: 5),
                  Text("Home"),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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

        const Text(
          "Nikhil",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        const Row(
          children: [
            Icon(Icons.phone, size: 18),
            SizedBox(width: 8),
            Text("9315885136"),
          ],
        ),

        const SizedBox(height: 6),

        const Row(
          children: [
            Icon(Icons.location_on, size: 18),
            SizedBox(width: 8),
            Text("Noida"),
          ],
        ),

        const SizedBox(height: 15),

        Row(
          children: [
            /// EDIT BUTTON
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text("Edit"),
            ),

            const SizedBox(width: 10),

            /// SET DEFAULT
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.star),
              label: const Text("Default"),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _addNewAddressBox() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(40),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
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
