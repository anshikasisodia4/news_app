class NewsModel {
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final String publishedAt;
  final String articleUrl;

  NewsModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
    required this.articleUrl,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      imageUrl: json['urlToImage'] ?? '',
      source: json['source']?['name'] ?? 'Unknown Source',
      publishedAt: json['publishedAt'] ?? '',
      articleUrl: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'source': source,
      'publishedAt': publishedAt,
      'articleUrl': articleUrl,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      source: map['source'] ?? '',
      publishedAt: map['publishedAt'] ?? '',
      articleUrl: map['articleUrl'] ?? '',
    );
  }
}