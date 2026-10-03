import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsApiService {
  static const String apiKey = 'YOUR_NEWS_API_KEY';
  static const String baseUrl = 'https://newsapi.org/v2';

  Future<List<NewsModel>> fetchTopHeadlines({
    String category = 'general',
  }) async {
    final url = Uri.parse(
      '$baseUrl/top-headlines?country=us&category=$category&apiKey=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final articles = data['articles'] as List;

      return articles
          .map((article) => NewsModel.fromJson(article))
          .toList();
    } else {
      throw Exception('Failed to load news');
    }
  }

  Future<List<NewsModel>> searchNews(String query) async {
    final url = Uri.parse(
      '$baseUrl/everything?q=$query&sortBy=publishedAt&apiKey=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final articles = data['articles'] as List;

      return articles
          .map((article) => NewsModel.fromJson(article))
          .toList();
    } else {
      throw Exception('Failed to search news');
    }
  }
}