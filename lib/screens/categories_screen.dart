import 'package:flutter/material.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<Map<String, dynamic>> categories = [
    {"title": "All Products", "icon": Icons.grid_view},
    {"title": "Casual Wear", "icon": Icons.checkroom},
    {"title": "Designer Wear", "icon": Icons.checkroom},
    {"title": "Party Wear", "icon": Icons.checkroom},
    {"title": "Traditional Wear", "icon": Icons.checkroom},
    {"title": "Wedding Wear", "icon": Icons.checkroom},
    {"title": "Western Wear", "icon": Icons.checkroom},
  ];

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

                  /// TITLE
                  const Text(
                    "Browse Categories",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// SUBTITLE
                  const Text(
                    "Find the perfect outfit for every occasion",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// MAIN CONTAINER
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// QUICK FILTER HEADER
                        Row(
                          children: const [
                            Icon(Icons.filter_alt, size: 22),
                            SizedBox(width: 10),
                            Text(
                              "Quick Filter",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// CATEGORY BUTTONS
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: categories.map((item) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(item["icon"], size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    item["title"],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// WHY RENT SECTION
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2B3F52),
                          Color(0xFF1F2E3C),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: const [
                            Icon(Icons.percent, color: Colors.white),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Why Rent Instead of Buy?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "Save up to 90% on designer outfits. Wear different styles for every occasion without the cost of buying.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 25),

                        _feature(Icons.check_circle, "90% Savings",
                            "Compared to buying", Colors.green),

                        const SizedBox(height: 15),

                        _feature(Icons.local_shipping, "Free Delivery",
                            "Doorstep service", Colors.blue),

                        const SizedBox(height: 15),

                        _feature(Icons.cleaning_services,
                            "Professional Cleaning", "Included in rental",
                            Colors.purple),

                        const SizedBox(height: 30),

                        /// COST CARD
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [

                              const Text(
                                "Cost Comparison",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 20),

                              const Text(
                                "Buy Price",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),

                              const Text(
                                "₹15,000",
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.red,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 15),

                              const Text(
                                "Rent for 3 days",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                              ),

                              const Text(
                                "₹1,500",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 20),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Text(
                                  "90% Savings",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                              const SizedBox(height: 20),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF6B35),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                    ),
                                  ),
                                  icon: const Icon(Icons.checkroom,color:Colors.white,fontWeight: FontWeight.bold,),
                                  label: const Text("Start Renting",style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// HOW SHOPNEST WORKS
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    color: const Color(0xfff5f6f7),
                    child: Column(
                      children: [

                        const Text(
                          "How ShopNest Works",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2c3e50),
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Rent designer clothes in 3 simple steps",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          height: 260,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [

                              _card(
                                number: "1",
                                icon: Icons.search,
                                title: "Browse & Select",
                                desc:
                                "Choose from our curated collection of designer outfits",
                              ),

                              const SizedBox(width: 20),

                              _card(
                                number: "2",
                                icon: Icons.calendar_today,
                                title: "Choose Dates",
                                desc:
                                "Select your rental period (3-14 days)",
                              ),

                              const SizedBox(width: 20),

                              _card(
                                number: "3",
                                icon: Icons.local_shipping,
                                title: "Wear & Return",
                                desc:
                                "Free delivery, wear it, and we'll pick it up",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// FOOTER FULL WIDTH
            const ShopFooter(),
          ],
        ),
      ),
    );
  }
}


Widget _card({
  required String number,
  required IconData icon,
  required String title,
  required String desc,
}) {
  return Container(
    width: 260,
    padding: const EdgeInsets.all(25),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.black12),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          spreadRadius: 1,
        )
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        /// NUMBER CIRCLE
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Color(0xffFF6B35),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 20),

        /// ICON
        Icon(
          icon,
          color: const Color(0xffFF6B35),
          size: 36,
        ),

        const SizedBox(height: 20),

        /// TITLE
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff2c3e50),
          ),
        ),

        const SizedBox(height: 10),

        /// DESCRIPTION
        Text(
          desc,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        )
      ],
    ),
  );
}


Widget _feature(IconData icon, String title, String subtitle, Color color) {
  return Row(
    children: [
      Icon(icon, color: color, size: 26),
      const SizedBox(width: 12),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      )
    ],
  );
}