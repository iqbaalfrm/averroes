import '../../services/api_client.dart';
import 'news_models.dart';

class NewsRepository {
  Future<List<NewsItem>> getLatest({int limit = 5}) async {
    try {
      final response = await ApiClient.get('/articles/latest', query: {
        'limit': limit,
      });
      final data = response.data as Map<String, dynamic>;
      final rows = List<Map<String, dynamic>>.from(data['data'] ?? []);
      return rows.map(_mapRow).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<NewsItem>> getPage({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final page = (offset ~/ limit) + 1;
      final response = await ApiClient.get('/articles', query: {
        'page': page,
        'per_page': limit,
      });
      final data = response.data as Map<String, dynamic>;
      final rows = List<Map<String, dynamic>>.from(data['data'] ?? []);
      return rows.map(_mapRow).toList();
    } catch (_) {
      return [];
    }
  }

  NewsItem _mapRow(Map<String, dynamic> row) {
    return NewsItem(
      id: row['id']?.toString() ?? '',
      title: row['title'] as String? ?? '',
      source: row['source'] as String? ?? 'Google News',
      url: row['url'] as String? ?? '',
      imageUrl: row['image_url'] as String?,
      publishedAt: DateTime.tryParse(row['published_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
