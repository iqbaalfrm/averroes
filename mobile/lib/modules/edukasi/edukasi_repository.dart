import '../../services/api_client.dart';
import 'edukasi_models.dart';

class EdukasiRepository {
  Future<List<ClassModel>> fetchClasses() async {
    try {
      final response = await ApiClient.get('/classes');
      final data = response.data as Map<String, dynamic>;
      final rows = List<Map<String, dynamic>>.from(data['data'] ?? []);
      if (rows.isEmpty) return [];

      return rows.map((row) {
        final modules = _mapModules(row['modules'], row['lessons']);
        return ClassModel(
          id: row['id'] as String,
          title: row['title'] as String? ?? '',
          subtitle: row['short_desc'] as String? ?? row['subtitle'] as String? ?? '',
          level: row['level'] as String? ?? 'Pemula',
          duration: row['duration_text'] as String? ?? '',
          lessonsCount: row['lessons_count'] as int? ?? modules.fold<int>(
            0,
            (sum, module) => sum + module.lessons.length,
          ),
          progress: 0.0,
          tags: _buildTags(row['level'] as String?, row['cover_theme'] as String?),
          coverTheme: _parseCoverTheme(row['cover_theme'] as String?),
          description: row['description'] as String? ?? '',
          outcomes: _parseOutcomes(row['outcomes']),
          modules: modules,
          isLocal: false,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> fetchProgress(String userId, String classId) async {
    try {
      final response = await ApiClient.get('/classes/$classId/progress');
      final data = response.data as Map<String, dynamic>;
      return data['data'] as Map<String, dynamic>?;
    } catch (_) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchProgressForUser(String userId) async {
    return [];
  }

  Future<List<String>> fetchBookmarks(String userId) async {
    return [];
  }

  Future<void> addBookmark(String userId, String classId) async {
    await ApiClient.post('/bookmarks', data: {
      'type': 'class',
      'ref_id': classId,
    });
  }

  Future<void> removeBookmark(String userId, String classId) async {
    await ApiClient.delete('/bookmarks', data: {
      'type': 'class',
      'ref_id': classId,
    });
  }

  Future<void> upsertProgress({
    required String userId,
    required String classId,
    String? lastLessonId,
    required double progress,
    required List<String> completedLessons,
  }) async {
    await ApiClient.post('/classes/$classId/progress', data: {
      'last_lesson_id': lastLessonId,
      'progress': progress,
      'completed_lessons': completedLessons,
    });
  }

  List<ModuleModel> _mapModules(dynamic modules, dynamic lessons) {
    if (modules is List && modules.isNotEmpty) {
      return modules.map((module) {
        final lessons = _mapLessons((module as Map<String, dynamic>)['lessons']);
        return ModuleModel(
          id: module['id'] as String,
          title: module['title'] as String? ?? '',
          lessons: lessons,
        );
      }).toList();
    }
    final lessonList = _mapLessons(lessons);
    if (lessonList.isEmpty) return [];
    return [
      ModuleModel(
        id: 'default',
        title: 'Materi',
        lessons: lessonList,
      ),
    ];
  }

  List<LessonModel> _mapLessons(dynamic lessons) {
    if (lessons is! List) return [];
    return lessons.map((row) {
      return LessonModel(
        id: row['id'] as String,
        title: row['title'] as String? ?? '',
        type: _parseLessonType(row['type'] as String?),
        durationMin: row['duration_min'] as int? ?? 0,
        summary: row['content'] as String? ?? '',
      );
    }).toList();
  }

  CoverTheme _parseCoverTheme(String? theme) {
    switch (theme) {
      case 'forest':
        return CoverTheme.forest;
      case 'sand':
        return CoverTheme.sand;
      case 'dusk':
        return CoverTheme.dusk;
      case 'clay':
        return CoverTheme.clay;
      case 'sea':
        return CoverTheme.sea;
      case 'berry':
        return CoverTheme.berry;
      default:
        return CoverTheme.forest;
    }
  }

  List<String> _parseOutcomes(dynamic outcomes) {
    if (outcomes is List) {
      return outcomes.map((item) => item.toString()).toList();
    }
    if (outcomes is String && outcomes.trim().isNotEmpty) {
      return outcomes.split(',').map((item) => item.trim()).toList();
    }
    return [];
  }

  LessonType _parseLessonType(String? type) {
    switch (type) {
      case 'video':
        return LessonType.video;
      case 'audio':
        return LessonType.audio;
      default:
        return LessonType.reading;
    }
  }

  List<String> _buildTags(String? level, String? theme) {
    final tags = <String>[];
    if (level != null && level.isNotEmpty) {
      tags.add(level);
    }
    if (theme == 'sand') {
      tags.add('Populer');
    }
    return tags;
  }
}
