import 'package:flutter/material.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/pagination.dart';
import 'package:shopnest/components/shopfooter_section.dart';
import 'package:shopnest/components/trendingCollection_card_for_screen.dart';

class RentclothesScreen extends StatefulWidget {
  const RentclothesScreen({super.key});

  @override
  State<RentclothesScreen> createState() => _RentclothesScreenState();
}

class _RentclothesScreenState extends State<RentclothesScreen> {
  int currentPage = 1;

  int totalpage = 5;

  bool isPageChanging = false;

  /// Dummy Product List
  final List<Map<String, dynamic>> productlist = [
    {
      "image": "https://images.unsplash.com/photo-1520975916090-3105956dac38",
      "title": "Kids Wear",
      "size": "M",
      "color": "Orange",
      "rent": 1600,
      "discount": 20,
      "finalPrice": 1280,
    },
    {
      "image": "https://images.unsplash.com/photo-1618354691373-d851c5c3a990",
      "title": "Designer Suit",
      "size": "L",
      "color": "Black",
      "rent": 2000,
      "discount": 15,
      "finalPrice": 1700,
    },
    {
      "image": "https://images.unsplash.com/photo-1593030761757-71fae45fa0e7",
      "title": "Wedding Sherwani",
      "size": "XL",
      "color": "Cream",
      "rent": 3500,
      "discount": 25,
      "finalPrice": 2625,
    },
    {
      "image": "https://images.unsplash.com/photo-1596755094514-f87e34085b2c",
      "title": "Party Gown",
      "size": "M",
      "color": "Red",
      "rent": 2200,
      "discount": 18,
      "finalPrice": 1804,
    },
    {
      "image": "https://images.unsplash.com/photo-1585487000160-6ebcfceb0d03",
      "title": "Traditional Kurta",
      "size": "L",
      "color": "Yellow",
      "rent": 1200,
      "discount": 10,
      "finalPrice": 1080,
    },
    {
      "image": "https://images.unsplash.com/photo-1520975661595-6453be3f7070",
      "title": "Western Dress",
      "size": "S",
      "color": "Blue",
      "rent": 1800,
      "discount": 12,
      "finalPrice": 1584,
    },
    {
      "image": "https://images.unsplash.com/photo-1503342217505-b0a15ec3261c",
      "title": "Men's Blazer",
      "size": "XL",
      "color": "Grey",
      "rent": 2500,
      "discount": 22,
      "finalPrice": 1950,
    },
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
  String selectedCategory = "All Categories";
  Widget categoryButton(String text) {
    bool isSelected = selectedCategory == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orangeAccent : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.orangeAccent : Colors.grey.shade300,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.orangeAccent.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.checkroom,
              size: 18,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// NAVBAR
              const SizedBox(height: 20),

              /// TITLE
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Rent Designer Clothes",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 15),

              /// CATEGORY BUTTONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      const SizedBox(width: 16),
                      categoryButton("All Categories"),
                      const SizedBox(width: 10),
                      categoryButton("Casual Wear"),
                      const SizedBox(width: 10),
                      categoryButton("Designer Wear"),
                      const SizedBox(width: 10),
                      categoryButton("Party Wear"),
                      const SizedBox(width: 10),
                      categoryButton("Traditional Wear"),
                      const SizedBox(width: 10),
                      categoryButton("Wedding Wear"),
                      const SizedBox(width: 10),
                      categoryButton("Western Wear"),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// PRODUCT LIST
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: productlist.map((product) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TrendingcollectionCardForScreen(item: product),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Pagination(
                  currentPage: currentPage,
                  totalPages: totalpage,
                  onPageChanged: (page) {
                    setState(() {
                      currentPage = page;
                      isPageChanging = true;
                    });
                    //fetchListings(reset: true);
                  },
                ),
              ),
              const SizedBox(height: 30),

              /// FOOTER
              const ShopFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
