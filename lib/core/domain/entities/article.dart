import 'dart:convert';
import 'package:crypto/crypto.dart';

/// =============================================================================
/// ARTICLE ENTITY
/// =============================================================================
/// Domain entity untuk artikel dari RSS feed
/// =============================================================================

class Article {
  final String id;
  final String title;
  final String link;
  final String source;
  final DateTime publishedAt;
  final String? snippet;
  final String? imageUrl;
  final String queryTag;
  final String? content; // Full article content

  const Article({
    required this.id,
    required this.title,
    required this.link,
    required this.source,
    required this.publishedAt,
    this.snippet,
    this.imageUrl,
    required this.queryTag,
    this.content,
  });

  /// Generate ID from link hash
  static String generateId(String link) {
    final bytes = utf8.encode(link);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// To JSON for caching
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'link': link,
      'source': source,
      'publishedAt': publishedAt.toIso8601String(),
      'snippet': snippet,
      'imageUrl': imageUrl,
      'queryTag': queryTag,
      'content': content,
    };
  }

  /// From JSON for caching
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as String,
      title: json['title'] as String,
      link: json['link'] as String,
      source: json['source'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      snippet: json['snippet'] as String?,
      imageUrl: json['imageUrl'] as String?,
      queryTag: json['queryTag'] as String,
      content: json['content'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Article && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
