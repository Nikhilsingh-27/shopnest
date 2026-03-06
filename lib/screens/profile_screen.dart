import 'package:flutter/material.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';

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
                            _menuItem(
                              Icons.logout,
                              "Logout",
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

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

                        _inputField("Address", addressController, maxLines: 3),

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
        color: active ? const Color(0xffff7a3d) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: active ? Colors.white : color, size: 22),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: active ? Colors.white : color,
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
