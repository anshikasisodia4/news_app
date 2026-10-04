import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/news_provider.dart';
import 'home_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  static const List<Map<String, String>> categories = [
    {
      'name': 'General',
      'value': 'general',
    },
    {
      'name': 'Technology',
      'value': 'technology',
    },
    {
      'name': 'Sports',
      'value': 'sports',
    },
    {
      'name': 'Business',
      'value': 'business',
    },
    {
      'name': 'Entertainment',
      'value': 'entertainment',
    },
    {
      'name': 'Science',
      'value': 'science',
    },
    {
      'name': 'Health',
      'value': 'health',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.category),
              title: Text(
                category['name']!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
              onTap: () async {
                await context.read<NewsProvider>().changeCategory(
                      category['value']!,
                    );

                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}