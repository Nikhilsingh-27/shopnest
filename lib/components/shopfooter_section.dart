import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ShopFooter extends StatelessWidget {
  const ShopFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1F2428),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 700) {
            return const _MobileFooter();
          } else {
            return const _DesktopFooter();
          }
        },
      ),
    );
  }
}

class _DesktopFooter extends StatelessWidget {
  const _DesktopFooter();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Expanded(child: _BrandSection()),
            Expanded(child: _QuickLinks()),
            Expanded(child: _CustomerService()),
            Expanded(child: _ContactInfo()),
          ],
        ),

        const SizedBox(height: 40),

        const Divider(color: Colors.white24),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "© 2026 ShopNest. All Rights Reserved.",
              style: TextStyle(color: Colors.white70),
            ),
            Row(
              children: [
                Icon(Icons.credit_card, color: Colors.white54),
                SizedBox(width: 10),
                Icon(Icons.payment, color: Colors.white54),
                SizedBox(width: 10),
                Icon(Icons.account_balance_wallet, color: Colors.white54),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _MobileFooter extends StatelessWidget {
  const _MobileFooter();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BrandSection(),
        SizedBox(height: 30),

        _QuickLinks(),
        SizedBox(height: 30),

        _CustomerService(),
        SizedBox(height: 30),

        _ContactInfo(),
        SizedBox(height: 30),

        Divider(color: Colors.white24),

        SizedBox(height: 15),

        Text(
          "© 2026 ShopNest. All Rights Reserved.",
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}

class _BrandSection extends StatelessWidget {
  const _BrandSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Row(
          children: [
            Icon(Icons.checkroom, color: Colors.orange),
            SizedBox(width: 8),
            Text(
              "ShopNest",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Text(
          "Your one-stop destination for renting designer clothes at amazing prices.",
          style: TextStyle(color: Colors.white70, height: 1.5),
        ),
        SizedBox(height: 15),
        Row(
          children: const [
            Icon(Icons.facebook, color: Colors.white54),
            SizedBox(width: 15),

            FaIcon(FontAwesomeIcons.twitter, color: Colors.white54),
            SizedBox(width: 15),

            FaIcon(FontAwesomeIcons.instagram, color: Colors.white54),
            SizedBox(width: 15),

            FaIcon(FontAwesomeIcons.pinterest, color: Colors.white54),
          ],
        ),
      ],
    );
  }
}

class _QuickLinks extends StatelessWidget {
  const _QuickLinks();

  @override
  Widget build(BuildContext context) {
    return const _FooterColumn(
      title: "Quick Links",
      items: ["Home", "Rent Clothes", "Categories", "About Us", "Contact"],
    );
  }
}

class _CustomerService extends StatelessWidget {
  const _CustomerService();

  @override
  Widget build(BuildContext context) {
    return const _FooterColumn(
      title: "Customer Service",
      items: [
        "Shipping Policy",
        "Returns & Refunds",
        "Privacy Policy",
        "Terms & Conditions",
        "FAQ",
      ],
    );
  }
}

class _ContactInfo extends StatelessWidget {
  const _ContactInfo();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contact Info",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),

        Row(
          children: [
            Icon(Icons.location_on, color: Colors.orange, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "123 Fashion Street, Style City",
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),

        SizedBox(height: 10),

        Row(
          children: [
            Icon(Icons.phone, color: Colors.orange, size: 18),
            SizedBox(width: 8),
            Text("+91 98765 43210", style: TextStyle(color: Colors.white70)),
          ],
        ),

        SizedBox(height: 10),

        Row(
          children: [
            Icon(Icons.email, color: Colors.orange, size: 18),
            SizedBox(width: 8),
            Text(
              "support@shopnest.com",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),

        SizedBox(height: 10),

        Row(
          children: [
            Icon(Icons.access_time, color: Colors.orange, size: 18),
            SizedBox(width: 8),
            Text("Mon-Sun: 9AM-9PM", style: TextStyle(color: Colors.white70)),
          ],
        ),
      ],
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;

  const _FooterColumn({required this.title, required this.items});

  void _navigate(String item) {
    if (item == "Home") {
      Get.toNamed("/");
    } else if (item == "Rent Clothes") {
      Get.toNamed("/rentclothes");
    } else if (item == "Categories") {
      Get.toNamed("/categories");
    } else if (item == "Contact") {
      Get.toNamed("/contact");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 15),

        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => _navigate(item),
              child: Text(item, style: const TextStyle(color: Colors.white70)),
            ),
          ),
        ),
      ],
    );
  }
}
