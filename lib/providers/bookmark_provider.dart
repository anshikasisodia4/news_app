import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/firestore_service.dart';

class BookmarkProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<NewsModel> _bookmarks = [];
  bool _isLoading = false;
  String? _error;

  List<NewsModel> get bookmarks => _bookmarks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadBookmarks(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _bookmarks = await _firestoreService.getBookmarks(userId);
    } catch (e) {
      _error = 'Unable to load bookmarks';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBookmark(
    String userId,
    NewsModel article,
  ) async {
    try {
      await _firestoreService.addBookmark(
        userId,
        article,
      );

      if (!_bookmarks.any((item) => item.id == article.id)) {
        _bookmarks.add(article);
      }

      notifyListeners();
    } catch (e) {
      _error = 'Unable to save bookmark';
      notifyListeners();
    }
  }

  Future<void> removeBookmark(
    String userId,
    String articleId,
  ) async {
    try {
      await _firestoreService.removeBookmark(
        userId,
        articleId,
      );

      _bookmarks.removeWhere(
        (article) => article.id == articleId,
      );

      notifyListeners();
    } catch (e) {
      _error = 'Unable to remove bookmark';
      notifyListeners();
    }
  }

  bool isBookmarked(String articleId) {
    return _bookmarks.any(
      (article) => article.id == articleId,
    );
  }

  Future<void> toggleBookmark(
    String userId,
    NewsModel article,
  ) async {
    if (isBookmarked(article.id)) {
      await removeBookmark(
        userId,
        article.id,
      );
    } else {
      await addBookmark(
        userId,
        article,
      );
    }
  }
}