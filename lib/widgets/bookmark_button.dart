import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/news_model.dart';
import '../providers/auth_provider.dart';
import '../providers/bookmark_provider.dart';

class BookmarkButton extends StatelessWidget {
  final NewsModel article;

  const BookmarkButton({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final bookmarkProvider = context.watch<BookmarkProvider>();

    final user = authProvider.user;

    if (user == null) {
      return IconButton(
        onPressed: () {},
        icon: const Icon(Icons.bookmark_border),
      );
    }

    final isBookmarked = bookmarkProvider.isBookmarked(article.id);

    return IconButton(
      onPressed: () async {
        await bookmarkProvider.toggleBookmark(
          user.uid,
          article,
        );
      },
      icon: Icon(
        isBookmarked
            ? Icons.bookmark
            : Icons.bookmark_border,
      ),
    );
  }
}