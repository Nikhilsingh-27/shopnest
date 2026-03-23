import 'package:flutter/material.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Container(
        color: const Color(0xFFF5F7FB), // 🔷 soft background
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔷 HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Your privacy is important to us. Learn how we collect, use, and protect your data.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔷 CONTENT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: const [
                    _PolicyCard(
                      title: 'Data We Collect',
                      content:
                          'We collect only necessary data like contact info, address, payment details, and order history for smooth service.',
                      icon: Icons.storage,
                    ),
                    SizedBox(height: 14),

                    _PolicyCard(
                      title: 'How We Use Data',
                      content:
                          'Your data is used for order fulfillment, personalization, fraud prevention, and marketing (with consent).',
                      icon: Icons.analytics,
                    ),
                    SizedBox(height: 14),

                    _PolicyCard(
                      title: 'Security Measures',
                      content:
                          'We use encrypted storage, secure servers, and strict access controls to protect your data.',
                      icon: Icons.security,
                    ),
                    SizedBox(height: 14),

                    _PolicyCard(
                      title: 'Cookies & Tracking',
                      content:
                          'Cookies improve your experience and analytics. You can disable non-essential cookies anytime.',
                      icon: Icons.cookie,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🔷 CONTACT TEXT
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Questions? Contact privacy@shopnest.com and we will respond within 48 hours.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔷 FOOTER
              const ShopFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PolicyCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const _PolicyCard({
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔷 Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EDFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF5B6EF5)),
          ),

          const SizedBox(width: 12),

          // 🔷 Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
