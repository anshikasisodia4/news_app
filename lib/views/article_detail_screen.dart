import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/news_model.dart';
import '../providers/auth_provider.dart';
import '../providers/bookmark_provider.dart';

class ArticleDetailScreen extends StatelessWidget {
  final NewsModel article;

  const ArticleDetailScreen({
    super.key,
    required this.article,
  });

  Future<void> openArticle() async {
    final url = Uri.parse(article.articleUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final bookmarkProvider = context.watch<BookmarkProvider>();

    final isBookmarked = bookmarkProvider.isBookmarked(article.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
        actions: [
          IconButton(
            onPressed: () {
              final user = authProvider.user;

              if (user != null) {
                context.read<BookmarkProvider>().toggleBookmark(
                      user.uid,
                      article,
                    );
              }
            },
            icon: Icon(
              isBookmarked
                  ? Icons.bookmark
                  : Icons.bookmark_border,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl.isNotEmpty)
              Image.network(
                article.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 250,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 60,
                      ),
                    ),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.source,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          article.source,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(article.publishedAt),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    article.description,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (article.content.isNotEmpty)
                    Text(
                      article.content,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: openArticle,
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text(
                        'Read Full Article',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}