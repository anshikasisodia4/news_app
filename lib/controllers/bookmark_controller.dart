import '../models/news_model.dart';
import '../providers/bookmark_provider.dart';

class BookmarkController {
  final BookmarkProvider bookmarkProvider;

  BookmarkController(this.bookmarkProvider);

  List<NewsModel> get bookmarks => bookmarkProvider.bookmarks;

  bool get isLoading => bookmarkProvider.isLoading;

  String? get error => bookmarkProvider.error;

  Future<void> loadBookmarks(String userId) async {
    await bookmarkProvider.loadBookmarks(userId);
  }

  Future<void> addBookmark(
    String userId,
    NewsModel article,
  ) async {
    await bookmarkProvider.addBookmark(
      userId,
      article,
    );
  }

  Future<void> removeBookmark(
    String userId,
    String articleId,
  ) async {
    await bookmarkProvider.removeBookmark(
      userId,
      articleId,
    );
  }

  Future<void> toggleBookmark(
    String userId,
    NewsModel article,
  ) async {
    await bookmarkProvider.toggleBookmark(
      userId,
      article,
    );
  }

  bool isBookmarked(String articleId) {
    return bookmarkProvider.isBookmarked(articleId);
  }
}