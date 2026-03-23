import 'package:flutter/material.dart';
import 'package:shopnest/components/main_layout_drawer.dart';
import 'package:shopnest/components/shopfooter_section.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      child: Container(
        color: const Color(0xFFF5F7FB), // soft background
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔷 HERO SECTION
              Container(
                width: double.infinity,
                height: 220,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1520975916090-3105956dac38?auto=format&fit=crop&w=1600&q=80',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  color: Colors.black.withOpacity(0.45),
                  child: const Text(
                    'About ShopNest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // 🔷 CONTENT
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Our Story',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'ShopNest started with a simple idea: make premium fashion affordable and sustainable by turning clothes into a shared experience.',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),

                    SizedBox(height: 24),

                    Text(
                      'Mission',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'To deliver a convenient and responsible fashion rental platform.',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),

                    SizedBox(height: 24),

                    Text(
                      'Vision',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'To become the first choice for style-conscious consumers.',
                      style: TextStyle(fontSize: 15, height: 1.6),
                    ),

                    SizedBox(height: 24),

                    Text(
                      'Values',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 14),
                  ],
                ),
              ),

              // 🔷 VALUE CARDS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: const [
                    _ValueCard(
                      title: 'Quality',
                      description:
                          'Premium outfits cleaned and inspected for every rental.',
                    ),
                    SizedBox(height: 12),
                    _ValueCard(
                      title: 'Sustainability',
                      description:
                          'Less buying, more renting means less waste.',
                    ),
                    SizedBox(height: 12),
                    _ValueCard(
                      title: 'Service',
                      description:
                          'Fast delivery, easy returns, and friendly support.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🔷 FOOTER (NOW SAFE)
              const ShopFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  final String title;
  final String description;

  const _ValueCard({required this.title, required this.description});

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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(description, style: const TextStyle(fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }
}
