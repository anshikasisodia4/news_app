import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import 'home_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final categories = [
    {
      'name': 'General',
      'value': 'general',
      'icon': Icons.public,
    },
    {
      'name': 'Technology',
      'value': 'technology',
      'icon': Icons.computer,
    },
    {
      'name': 'Sports',
      'value': 'sports',
      'icon': Icons.sports_soccer,
    },
    {
      'name': 'Business',
      'value': 'business',
      'icon': Icons.business_center,
    },
    {
      'name': 'Entertainment',
      'value': 'entertainment',
      'icon': Icons.movie_outlined,
    },
    {
      'name': 'Science',
      'value': 'science',
      'icon': Icons.science_outlined,
    },
    {
      'name': 'Health',
      'value': 'health',
      'icon': Icons.health_and_safety_outlined,
    },
    {
      'name': 'World',
      'value': 'world',
      'icon': Icons.language,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F5F0),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        title: const Text(
          'Categories',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF20251F),
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.25,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            return _CategoryCard(
              name: category['name'] as String,
              icon: category['icon'] as IconData,
              onTap: () async {
                await context
                    .read<NewsProvider>()
                    .changeCategory(category['value'] as String);

                if (!context.mounted) return;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4EE),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Icon(
                icon,
                size: 27,
                color: const Color(0xFF30362F),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF252A24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}