import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/news_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/bookmark_provider.dart';
import '../widgets/news_card.dart';
import 'article_detail_screen.dart';
import 'category_screen.dart';
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
    {'name': 'All News', 'value': 'general'},
    {'name': 'Sports', 'value': 'sports'},
    {'name': 'World', 'value': 'general'},
    {'name': 'Business', 'value': 'business'},
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

  void search() {
    final query = searchController.text.trim();

    if (query.isNotEmpty) {
      context.read<NewsProvider>().searchNews(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final news = context.watch<NewsProvider>();
    final auth = context.watch<AuthProvider>();
    final bookmarks = context.watch<BookmarkProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F0),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: news.fetchNews,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'News Hub',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _iconButton(Icons.search),
                  const SizedBox(width: 8),
                  _iconButton(Icons.notifications_none),
                ],
              ),

              const SizedBox(height: 20),

              TextField(
                controller: searchController,
                onSubmitted: (_) => search(),
                decoration: InputDecoration(
                  hintText: 'Search news...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: search,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                height: 42,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_,_) =>
                      const SizedBox(width: 8),
                  itemBuilder: (_, index) {
                    final category = categories[index];

                    final selected =
                        news.selectedCategory == category['value'] &&
                            news.searchQuery.isEmpty;

                    return ChoiceChip(
                      label: Text(category['name']!),
                      selected: selected,
                      onSelected: (_) {
                        news.changeCategory(category['value']!);
                      },
                      selectedColor: Colors.black,
                      labelStyle: TextStyle(
                        color: selected
                            ? Colors.white
                            : Colors.black,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                        side: BorderSide.none,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Popular News',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See All'),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              if (news.isLoading)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (news.error != null)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 45,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        news.error!,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: news.fetchNews,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              else if (news.news.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: Text('No news found'),
                  ),
                )
              else
                ...news.news.map(
                  (article) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: NewsCard(
                      article: article,
                      isBookmarked:
                          bookmarks.isBookmarked(article.id),
                      onBookmark: () {
                        final user = auth.user;

                        if (user != null) {
                          bookmarks.toggleBookmark(
                            user.uid,
                            article,
                          );
                        }
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ArticleDetailScreen(
                              article: article,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CategoryScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const BookmarksScreen(),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon),
      ),
    );
  }
}