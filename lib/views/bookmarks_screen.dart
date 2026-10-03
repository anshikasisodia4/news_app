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
    final bookmarkProvider = context.watch<BookmarkProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Articles',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: bookmarkProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : bookmarkProvider.error != null
              ? Center(
                  child: Text(bookmarkProvider.error!),
                )
              : bookmarkProvider.bookmarks.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bookmark_border,
                            size: 70,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'No saved articles',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Bookmark articles to read them later',
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: bookmarkProvider.bookmarks.length,
                      itemBuilder: (context, index) {
                        final article =
                            bookmarkProvider.bookmarks[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ArticleDetailScreen(
                                    article: article,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(8),
                                    child: article.imageUrl.isNotEmpty
                                        ? Image.network(
                                            article.imageUrl,
                                            width: 110,
                                            height: 90,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                width: 110,
                                                height: 90,
                                                alignment:
                                                    Alignment.center,
                                                child: const Icon(
                                                  Icons
                                                      .image_not_supported,
                                                ),
                                              );
                                            },
                                          )
                                        : Container(
                                            width: 110,
                                            height: 90,
                                            alignment:
                                                Alignment.center,
                                            child: const Icon(
                                              Icons.newspaper,
                                              size: 35,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          article.title,
                                          maxLines: 3,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          article.source,
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          article.publishedAt,
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      final user =
                                          authProvider.user;

                                      if (user != null) {
                                        context
                                            .read<BookmarkProvider>()
                                            .removeBookmark(
                                              user.uid,
                                              article.id,
                                            );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}