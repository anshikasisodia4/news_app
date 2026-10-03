import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsApiService {
  static const String apiKey = 'a1d7dd52543073543cdcdd5f1a875b7c';
  static const String baseUrl = 'https://gnews.io/api/v4';

  Future<List<NewsModel>> fetchNews({
    String category = 'general',
  }) async {
    final url = Uri.parse(
      '$baseUrl/top-headlines?category=$category&lang=en&country=in&max=10&apikey=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load news');
    }

    final data = jsonDecode(response.body);

    final articles = data['articles'] as List;

    return articles
        .map((article) => NewsModel.fromJson(article))
        .toList();
  }

  Future<List<NewsModel>> searchNews(String query) async {
    final url = Uri.parse(
      '$baseUrl/search?q=${Uri.encodeQueryComponent(query)}&lang=en&country=in&max=10&sortby=publishedAt&apikey=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to search news');
    }

    final data = jsonDecode(response.body);

    final articles = data['articles'] as List;

    return articles
        .map((article) => NewsModel.fromJson(article))
        .toList();
  }
}