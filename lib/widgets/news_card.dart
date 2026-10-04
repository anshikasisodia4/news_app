import 'package:flutter/material.dart';

import '../models/news_model.dart';

class NewsCard extends StatelessWidget {
  final NewsModel article;
  final bool isBookmarked;
  final VoidCallback onTap;
  final VoidCallback onBookmark;

  const NewsCard({
    super.key,
    required this.article,
    required this.isBookmarked,
    required this.onTap,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
                child: Image.network(
                  article.imageUrl,
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      height: 190,
                      color: const Color(0xFFE8ECE7),
                      child: const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 45,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          article.source,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6C756B),
                          ),
                        ),
                      ),
                      Text(
                        _formatDate(article.publishedAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8A9188),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 19,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF20251F),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          article.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: Color(0xFF737A71),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F4EF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          onPressed: onBookmark,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            size: 21,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty) {
      return '';
    }

    try {
      final parsedDate = DateTime.parse(date);
      final difference = DateTime.now().difference(parsedDate);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} min ago';
      }

      if (difference.inHours < 24) {
        return '${difference.inHours} hr ago';
      }

      if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      }

      return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
    } catch (_) {
      return date;
    }
  }
}