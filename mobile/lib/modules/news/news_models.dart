class NewsItem {
  final String id;
  final String title;
  final String source;
  final String url;
  final String? imageUrl;
  final DateTime publishedAt;
  final bool isLocal;

  const NewsItem({
    required this.id,
    required this.title,
    required this.source,
    required this.url,
    required this.publishedAt,
    this.imageUrl,
    this.isLocal = false,
  });
}
