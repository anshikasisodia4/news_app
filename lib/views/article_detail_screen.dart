import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/news_model.dart';

class ArticleDetailScreen extends StatelessWidget {
  final NewsModel article;

  const ArticleDetailScreen({
    super.key,
    required this.article,
  });

  Future<void> _openFullArticle(BuildContext context) async {
    final url = article.articleUrl.trim();

    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Article link is not available'),
        ),
      );
      return;
    }

    final uri = Uri.tryParse(url);

    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid article link'),
        ),
      );
      return;
    }

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the article in browser'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open browser'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Article',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl.isNotEmpty)
              Image.network(
                article.imageUrl,
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    width: double.infinity,
                    height: 240,
                    color: const Color(0xFF1E1E1E),
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.white54,
                      size: 55,
                    ),
                  );
                },
              )
            else
              Container(
                width: double.infinity,
                height: 240,
                color: const Color(0xFF1E1E1E),
                child: const Icon(
                  Icons.newspaper,
                  color: Colors.white54,
                  size: 55,
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                22,
                20,
                30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.source,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    article.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (article.publishedAt.isNotEmpty)
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          color: Colors.white54,
                          size: 14,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            article.publishedAt,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  if (article.description.isNotEmpty)
                    Text(
                      article.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.6,
                      ),
                    ),
                  if (article.content.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      article.content,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.7,
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _openFullArticle(context);
                      },
                      icon: const Icon(
                        Icons.open_in_new,
                        size: 20,
                      ),
                      label: const Text(
                        'View Full Article',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
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