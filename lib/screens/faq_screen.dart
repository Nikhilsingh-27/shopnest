import 'package:flutter/material.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'FAQ',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Answers to the most common questions about renting with ShopNest.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 24),

                  _FAQItem(
                    question: 'How do I rent an outfit?',
                    answer:
                        'Browse products, select dates, choose size, and checkout. Delivery and return pickup are handled by us.',
                  ),
                  SizedBox(height: 10),

                  _FAQItem(
                    question: 'What is the deposit policy?',
                    answer:
                        'Certain items may require a security deposit which is released after successful return inspection.',
                  ),
                  SizedBox(height: 10),

                  _FAQItem(
                    question: 'Can I extend my rental period?',
                    answer:
                        'Yes, extensions are available via the order details page depending on availability.',
                  ),
                  SizedBox(height: 10),

                  _FAQItem(
                    question: 'What if the item gets damaged?',
                    answer:
                        'Report within 24 hours. We evaluate and may charge repair/replacement fees if not due to normal wear.',
                  ),
                  SizedBox(height: 10),

                  _FAQItem(
                    question: 'When will I get a refund?',
                    answer:
                        'Refunds are typically processed within 7 business days after approval.',
                  ),

                  SizedBox(height: 24),

                  Text(
                    'Still need help? Reach out to support@shopnest.com with your question and order ID.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const ShopFooter(),
          ],
        ),
      ),
    );
  }
}

class _FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        title: Text(
          question,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        children: [
          Text(
            answer,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
