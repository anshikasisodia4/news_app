import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/news_api_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsApiService _newsApiService = NewsApiService();

  List<NewsModel> _news = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'general';
  String _searchQuery = '';

  List<NewsModel> get news => _news;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  Future<void> fetchNews() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _news = await _newsApiService.fetchNews(
        category: _selectedCategory,
      );
    } catch (e) {
      _error = 'Unable to load news';
      _news = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeCategory(String category) async {
    _selectedCategory = category;
    _searchQuery = '';
    notifyListeners();

    await fetchNews();
  }

  Future<void> searchNews(String query) async {
    if (query.trim().isEmpty) {
      await fetchNews();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      _searchQuery = query;
      notifyListeners();

      _news = await _newsApiService.searchNews(query);
    } catch (e) {
      _error = 'Unable to search news';
      _news = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}