import '../../services/api_client.dart';
import 'diskusi_models.dart';

class DiskusiRepository {
  Future<List<DiskusiThread>> fetchThreads() async {
    try {
      final response = await ApiClient.get('/forum/threads');
      final data = response.data as Map<String, dynamic>;
      final rows = List<Map<String, dynamic>>.from(data['data'] ?? []);
      return rows.map(_mapThread).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<DiskusiReply>> fetchReplies(String threadId) async {
    try {
      final response = await ApiClient.get('/forum/threads/$threadId');
      final data = response.data as Map<String, dynamic>;
      final thread = data['data'] as Map<String, dynamic>;
      final rows = List<Map<String, dynamic>>.from(thread['replies'] ?? []);
      return rows.map(_mapReply).toList();
    } catch (_) {
      return [];
    }
  }

  Future<DiskusiThread?> createThread({
    required String userId,
    required bool isAnonymous,
    required String category,
    required String title,
    required String body,
  }) async {
    final response = await ApiClient.post('/forum/threads', data: {
      'is_anonymous': isAnonymous,
      'category': category,
      'title': title,
      'body': body,
    });

    if (response.statusCode == 201) {
      return _mapThread(Map<String, dynamic>.from(response.data['data']));
    }

    return null;
  }

  Future<DiskusiReply?> createReply({
    required String threadId,
    required String userId,
    required String body,
  }) async {
    final response = await ApiClient.post('/forum/threads/$threadId/replies', data: {
      'body': body,
    });

    if (response.statusCode == 201) {
      return _mapReply(Map<String, dynamic>.from(response.data['data']));
    }

    return null;
  }

  Future<bool?> toggleLike({
    required String userId,
    required String targetType,
    required String targetId,
  }) async {
    final path = targetType == 'thread'
        ? '/forum/threads/$targetId/like'
        : '/forum/replies/$targetId/like';

    final response = await ApiClient.post(path);
    if (response.statusCode == 200) {
      return response.data['liked'] as bool?;
    }
    return null;
  }

  Future<void> markAccepted({
    required String threadId,
    required String replyId,
  }) async {}

  DiskusiThread _mapThread(Map<String, dynamic> row) {
    final userId = row['user_id'] as String?;
    final isAnonymous = row['is_anonymous'] as bool? ?? false;
    final replyCount = row['reply_count'] as int? ?? 0;
    return DiskusiThread(
      id: row['id']?.toString() ?? '',
      title: row['title'] as String? ?? '',
      description: row['body'] as String? ?? '',
      category: row['category'] as String? ?? 'Fiqh',
      author: DiskusiUser(
        id: userId ?? 'anon',
        name: isAnonymous || userId == null ? 'Anonim' : 'Member',
        isAnonymous: isAnonymous || userId == null,
      ),
      createdAt: DateTime.tryParse(row['created_at']?.toString() ?? '') ??
          DateTime.now(),
      helpfulCount: row['like_count'] as int? ?? 0,
      replyCount: replyCount,
      isAnswered: replyCount > 0,
    );
  }

  DiskusiReply _mapReply(Map<String, dynamic> row) {
    final userId = row['user_id'] as String?;
    return DiskusiReply(
      id: row['id']?.toString() ?? '',
      threadId: row['thread_id'] as String? ?? '',
      author: DiskusiUser(
        id: userId ?? 'anon',
        name: userId == null ? 'Anonim' : 'Member',
        isAnonymous: userId == null,
      ),
      content: row['body'] as String? ?? '',
      createdAt: DateTime.tryParse(row['created_at']?.toString() ?? '') ??
          DateTime.now(),
      helpfulCount: row['like_count'] as int? ?? 0,
      isAccepted: row['is_accepted'] as bool? ?? false,
    );
  }
}
