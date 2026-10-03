import '../models/news_model.dart';
import '../providers/news_provider.dart';

class NewsController {
  final NewsProvider newsProvider;

  NewsController(this.newsProvider);

  List<NewsModel> get news => newsProvider.news;

  bool get isLoading => newsProvider.isLoading;

  String? get error => newsProvider.error;

  String get selectedCategory => newsProvider.selectedCategory;

  String get searchQuery => newsProvider.searchQuery;

  Future<void> fetchNews() async {
    await newsProvider.fetchNews();
  }

  Future<void> changeCategory(String category) async {
    await newsProvider.changeCategory(category);
  }

  Future<void> searchNews(String query) async {
    await newsProvider.searchNews(query);
  }

  void clearSearch() {
    newsProvider.clearSearch();
  }
}