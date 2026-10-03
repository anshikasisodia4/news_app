import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/bookmark_provider.dart';
import '../models/news_model.dart';
import 'article_detail_screen.dart';
import 'bookmarks_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();

  final categories = [
    {'name': 'General', 'value': 'general'},
    {'name': 'Technology', 'value': 'technology'},
    {'name': 'Sports', 'value': 'sports'},
    {'name': 'Business', 'value': 'business'},
    {'name': 'Entertainment', 'value': 'entertainment'},
    {'name': 'Science', 'value': 'science'},
    {'name': 'Health', 'value': 'health'},
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsProvider>().fetchNews();

      final user = context.read<AuthProvider>().user;
      if (user != null) {
        context.read<BookmarkProvider>().loadBookmarks(user.uid);
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void searchNews() {
    final query = searchController.text.trim();

    if (query.isNotEmpty) {
      context.read<NewsProvider>().searchNews(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = context.watch<NewsProvider>();
    final authProvider = context.watch<AuthProvider>();
    final bookmarkProvider = context.watch<BookmarkProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookmarksScreen(),
                ),
              );
            },
            icon: const Icon(Icons.bookmark),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => searchNews(),
              decoration: InputDecoration(
                hintText: 'Search news...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: searchNews,
                  icon: const Icon(Icons.arrow_forward),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(category['name']!),
                    selected:
                        newsProvider.selectedCategory == category['value'] &&
                        newsProvider.searchQuery.isEmpty,
                    onSelected: (_) {
                      context.read<NewsProvider>().changeCategory(
                            category['value']!,
                          );
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: newsProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : newsProvider.error != null
                    ? Center(
                        child: Text(newsProvider.error!),
                      )
                    : newsProvider.news.isEmpty
                        ? const Center(
                            child: Text('No news found'),
                          )
                        : RefreshIndicator(
                            onRefresh: newsProvider.fetchNews,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: newsProvider.news.length,
                              itemBuilder: (context, index) {
                                final article = newsProvider.news[index];

                                return _NewsCard(
                                  article: article,
                                  isBookmarked:
                                      bookmarkProvider.isBookmarked(article.id),
                                  onBookmark: () {
                                    final user = authProvider.user;

                                    if (user != null) {
                                      context
                                          .read<BookmarkProvider>()
                                          .toggleBookmark(
                                            user.uid,
                                            article,
                                          );
                                    }
                                  },
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
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsModel article;
  final bool isBookmarked;
  final VoidCallback onBookmark;
  final VoidCallback onTap;

  const _NewsCard({
    required this.article,
    required this.isBookmarked,
    required this.onBookmark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl.isNotEmpty)
              Image.network(
                article.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${article.source} • ${article.publishedAt}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onBookmark,
                        icon: Icon(
                          isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
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
}