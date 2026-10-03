import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/news_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _bookmarks(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('bookmarks');
  }

  Future<void> addBookmark(
    String userId,
    NewsModel article,
  ) async {
    await _bookmarks(userId)
        .doc(article.id)
        .set(article.toMap());
  }

  Future<void> removeBookmark(
    String userId,
    String articleId,
  ) async {
    await _bookmarks(userId)
        .doc(articleId)
        .delete();
  }

  Future<List<NewsModel>> getBookmarks(
    String userId,
  ) async {
    final snapshot = await _bookmarks(userId).get();

    return snapshot.docs
        .map((doc) => NewsModel.fromMap(doc.data()))
        .toList();
  }

  Future<bool> isBookmarked(
    String userId,
    String articleId,
  ) async {
    final document = await _bookmarks(userId)
        .doc(articleId)
        .get();

    return document.exists;
  }
}