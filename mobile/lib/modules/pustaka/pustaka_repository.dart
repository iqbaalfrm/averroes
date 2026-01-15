import '../../services/api_client.dart';
import 'pustaka_models.dart';

class PustakaRepository {
  Future<List<BookModel>> fetchBooks() async {
    try {
      final response = await ApiClient.get('/books');
      final data = response.data as Map<String, dynamic>;
      final rows = List<Map<String, dynamic>>.from(data['data'] ?? []);
      return rows.map(_mapBook).toList();
    } catch (_) {
      return [];
    }
  }

  Future<Set<String>> fetchBookmarks(String userId) async {
    return <String>{};
  }

  Future<List<BookProgress>> fetchProgressForUser(String userId) async {
    return [];
  }

  Future<void> addBookmark(String userId, String bookId) async {
    await ApiClient.post('/bookmarks', data: {
      'type': 'book',
      'ref_id': bookId,
    });
  }

  Future<void> removeBookmark(String userId, String bookId) async {
    await ApiClient.delete('/bookmarks', data: {
      'type': 'book',
      'ref_id': bookId,
    });
  }

  Future<void> upsertProgress({
    required String userId,
    required String bookId,
    required int lastPage,
    required int pageCount,
  }) async {}

  Future<String?> resolvePdfUrl(String? pdfUrl) async {
    if (pdfUrl == null || pdfUrl.isEmpty) return null;
    return pdfUrl;
  }

  BookModel _mapBook(Map<String, dynamic> row) {
    final displayTitle = row['display_title'] as String? ?? row['title_readable'] as String? ?? '';
    final originalTitle = row['original_title'] as String? ?? row['title_original'] as String?;

    return BookModel(
      id: row['id']?.toString() ?? '',
      title: displayTitle,
      titleOriginal: originalTitle,
      titleReadable: displayTitle,
      author: row['author'] as String? ?? '',
      language: row['language'] as String? ?? 'INDONESIA',
      category: row['category'] as String? ?? 'Referensi',
      pages: row['pages'] as int?,
      description: row['description'] as String? ?? '',
      pdfUrl: row['pdf_url'] as String?,
      coverUrl: row['cover_url'] as String?,
      isPremium: false,
      isLocal: false,
    );
  }
}
