import 'package:flutter/material.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';

class ShippingPolicyScreen extends StatelessWidget {
  const ShippingPolicyScreen({super.key});

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
                      'Shipping Policy',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Fast, reliable, and secure delivery for your rentals.',
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

              // 🔷 CONTENT CARDS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: const [
                    _PolicyCard(
                      title: 'Order Confirmation',
                      content:
                          'Orders are confirmed within 1-2 hours with delivery details via email and app notification.',
                      icon: Icons.check_circle_outline,
                    ),
                    SizedBox(height: 14),

                    _PolicyCard(
                      title: 'Delivery Time',
                      content:
                          '2-4 days in metro cities and 3-5 days elsewhere. Express delivery is available in select locations.',
                      icon: Icons.local_shipping_outlined,
                    ),
                    SizedBox(height: 14),

                    _PolicyCard(
                      title: 'Shipping Fees',
                      content:
                          'Flat shipping fee based on order value and distance. Free shipping above ₹4,999.',
                      icon: Icons.payments_outlined,
                    ),
                    SizedBox(height: 14),

                    _PolicyCard(
                      title: 'Tracking',
                      content:
                          'Track your order in real-time with updates for dispatch, out for delivery, and delivered.',
                      icon: Icons.track_changes,
                    ),
                    SizedBox(height: 14),

                    _PolicyCard(
                      title: 'Return Pickup',
                      content:
                          'Pickup is scheduled on your selected date. Items must be returned in proper condition.',
                      icon: Icons.assignment_return_outlined,
                    ),
                    SizedBox(height: 14),

                    _PolicyCard(
                      title: 'Customer Support',
                      content:
                          'Reach us via chat or support@shopnest.com. We respond within 2 hours.',
                      icon: Icons.support_agent,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🔷 FOOTER TEXT
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Thank you for choosing ShopNest. Your delivery experience is our priority.',
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
