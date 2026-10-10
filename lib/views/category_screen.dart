import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'name': 'Technology', 'value': 'technology', 'icon': Icons.computer},
    {'name': 'Sports', 'value': 'sports', 'icon': Icons.sports_soccer},
    {'name': 'Business', 'value': 'business', 'icon': Icons.business_center},
    {
      'name': 'Entertainment',
      'value': 'entertainment',
      'icon': Icons.movie_outlined,
    },
    {'name': 'Science', 'value': 'science', 'icon': Icons.science_outlined},
    {
      'name': 'Health',
      'value': 'health',
      'icon': Icons.health_and_safety_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final news = context.read<NewsProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Categories',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Explore Categories',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Choose a category to discover the latest stories.',
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return GestureDetector(
                    onTap: () {
                      news.changeCategory(category['value']);

                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: const Color(0xFF303030)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              color: const Color(0xFF292929),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Icon(
                              category['icon'],
                              size: 30,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 14),

                          Text(
                            category['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
