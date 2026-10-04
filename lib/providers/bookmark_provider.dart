import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/news_model.dart';

class BookmarkProvider extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<NewsModel> bookmarks = [];
  bool isLoading = false;
  String? error;

  Future<void> loadBookmarks(String userId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final snapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('bookmarks')
          .get();

      bookmarks = snapshot.docs
          .map((doc) => NewsModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> addBookmark(
    String userId,
    NewsModel article,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('bookmarks')
          .doc(article.id)
          .set(article.toMap());

      bookmarks.removeWhere(
        (item) => item.id == article.id,
      );

      bookmarks.add(article);

      error = null;
      notifyListeners();

      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeBookmark(
    String userId,
    String articleId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('bookmarks')
          .doc(articleId)
          .delete();

      bookmarks.removeWhere(
        (item) => item.id == articleId,
      );

      error = null;
      notifyListeners();

      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  bool isBookmarked(String articleId) {
    return bookmarks.any(
      (item) => item.id == articleId,
    );
  }

  Future<void> toggleBookmark(
    String userId,
    NewsModel article,
  ) async {
    if (isBookmarked(article.id)) {
      await removeBookmark(userId, article.id);
    } else {
      await addBookmark(userId, article);
    }
  }
}