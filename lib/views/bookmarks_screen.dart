import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/bookmark_provider.dart';
import 'article_detail_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().user;

      if (user != null) {
        context.read<BookmarkProvider>().loadBookmarks(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final bookmarks = context.watch<BookmarkProvider>();

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
          'Saved News',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF20251F),
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (auth.user == null) {
            return const Center(
              child: Text(
                'Please login to view your saved news',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF697268),
                ),
              ),
            );
          }

          if (bookmarks.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (bookmarks.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      bookmarks.error!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        bookmarks.loadBookmarks(auth.user!.uid);
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (bookmarks.bookmarks.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 70,
                      color: Color(0xFF9AA198),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'No Saved News',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF30362F),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Articles you bookmark will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF737A71),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 25),
            itemCount: bookmarks.bookmarks.length,
            itemBuilder: (context, index) {
              final article = bookmarks.bookmarks[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
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
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ArticleDetailScreen(article: article),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: article.imageUrl.isNotEmpty
                              ? Image.network(
                                  article.imageUrl,
                                  width: 105,
                                  height: 105,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) {
                                    return _placeholder();
                                  },
                                )
                              : _placeholder(),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.source,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF737A71),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                article.title,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.25,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF20251F),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        IconButton(
                          onPressed: () {
                            bookmarks.removeBookmark(
                              auth.user!.uid,
                              article.id,
                            );
                          },
                          icon: const Icon(
                            Icons.bookmark,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 105,
      height: 105,
      color: const Color(0xFFE7ECE5),
      child: const Icon(
        Icons.image_outlined,
        color: Colors.grey,
        size: 35,
      ),
    );
  }
}