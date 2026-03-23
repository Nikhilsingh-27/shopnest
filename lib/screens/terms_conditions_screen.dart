import 'package:flutter/material.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // 🔷 Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              decoration: const BoxDecoration(
                color: Colors.white, // 👈 Changed from gradient to white
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // 👈 change text to dark
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please read these terms carefully before using ShopNest services.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black54, // 👈 softer grey text
                    ),
                  ),
                ],
              ),
            ),
            // 🔷 Content Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: const [
                  _PolicyCard(
                    title: 'Eligibility',
                    content:
                        'You must be 18+ and legally capable of entering into contracts. By using our service, you agree to the terms and local regulations.',
                  ),
                  SizedBox(height: 16),

                  _PolicyCard(
                    title: 'Account Responsibility',
                    content:
                        'Keep your account credentials secure. You are responsible for actions taken from your account.',
                  ),
                  SizedBox(height: 16),

                  _PolicyCard(
                    title: 'Rental Use',
                    content:
                        'Items are for personal occasion use only. Do not modify, resell, or transfer rented items. Return on time in reusable condition.',
                  ),
                  SizedBox(height: 16),

                  _PolicyCard(
                    title: 'Payment & Fees',
                    content:
                        'Full payment is due at checkout. Late returns and damages may incur additional charges as outlined in order details.',
                  ),
                  SizedBox(height: 16),

                  _PolicyCard(
                    title: 'Cancellation Policy',
                    content:
                        'Orders may be cancelled before dispatch for a full refund. After dispatch, rent applies and partial refunds may be reviewed case-by-case.',
                  ),
                  SizedBox(height: 16),

                  _PolicyCard(
                    title: 'Modifications',
                    content:
                        'We can update terms with notice. Continued use constitutes acceptance.',
                  ),
                  SizedBox(height: 24),

                  _ContactBox(),
                ],
              ),
            ),

            // 🔷 Footer
            const ShopFooter(),
          ],
        ),
      ),
    );
  }
}

// 🔹 Reusable Card Widget
class _PolicyCard extends StatelessWidget {
  final String title;
  final String content;

  const _PolicyCard({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black12, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.article_outlined, color: Color(0xFF6A5AE0)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15.5,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 Contact Box (Professional Touch)
class _ContactBox extends StatelessWidget {
  const _ContactBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E3FF)),
      ),
      child: const Row(
        children: [
          Icon(Icons.support_agent, color: Color(0xFF6A5AE0)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Need help? Contact us at terms@shopnest.com',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
