import 'package:flutter/material.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';

class ReturnsRefundsScreen extends StatelessWidget {
  const ReturnsRefundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Container(
        color: const Color(0xFFF5F7FB), // 👈 light app background
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔷 HEADER CARD
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
                      'Returns & Refunds',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'We want you to be fully satisfied with every order. If there is any issue, our returns and refund policy makes it easy.',
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
                      title: 'Return Window',
                      content:
                          'You can request a return within 24 hours after delivery. Items must be returned by the agreed date to avoid late fees.',
                      icon: Icons.access_time,
                    ),
                    SizedBox(height: 14),

                    _PolicyCard(
                      title: 'Return Process',
                      content:
                          'Go to order details, tap Return, and choose pickup slot. Our team will collect and inspect within 2 days.',
                      icon: Icons.assignment_return,
                    ),
                    SizedBox(height: 14),

                    _PolicyCard(
                      title: 'Refund Eligibility',
                      content:
                          'Refunds are allowed for canceled bookings before dispatch and approved damaged items.',
                      icon: Icons.verified,
                    ),
                    SizedBox(height: 14),

                    _PolicyCard(
                      title: 'Refund Timeframe',
                      content:
                          'Refunds are processed within 7 business days after approval to your original payment method.',
                      icon: Icons.payments,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🔷 HELP TEXT
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Need help? Contact support@shopnest.com or use live chat in the app.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Footer
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

          // 🔷 Text Content
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
