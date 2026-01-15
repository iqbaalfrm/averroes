import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'edukasi_dummy_data.dart';
import 'edukasi_models.dart';
import 'edukasi_repository.dart';
import '../../services/auth_guard.dart';
import '../../services/app_session_controller.dart';
import '../../config/env_config.dart';

class EdukasiController extends GetxController {
  final RxList<ClassModel> classes = <ClassModel>[].obs;
  final RxSet<String> bookmarkedIds = <String>{}.obs;
  final RxInt popularIndex = 0.obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  late final PageController popularController;
  final EdukasiRepository _repository = EdukasiRepository();
  final AppSessionController _session = Get.find<AppSessionController>();

  @override
  void onInit() {
    super.onInit();
    popularController = PageController(viewportFraction: 0.86);
    loadClasses();
  }

  @override
  void onClose() {
    popularController.dispose();
    super.onClose();
  }

  ClassModel get continueClass {
    if (classes.isEmpty) {
      if (!EnvConfig.isProduction) {
        return edukasiDummyClasses().first;
      }
      return ClassModel(
        id: 'empty',
        title: '',
        subtitle: '',
        level: 'Pemula',
        duration: '',
        lessonsCount: 0,
        progress: 0.0,
        tags: const [],
        coverTheme: CoverTheme.forest,
        description: '',
        outcomes: const [],
        modules: const [],
        isLocal: true,
      );
    }
    return classes.firstWhere(
      (item) => item.progress > 0,
      orElse: () => classes.first,
    );
  }

  List<ClassModel> get popularClasses {
    final withTags = classes
        .where((item) => item.tags.any(
              (tag) => tag == 'Populer' || tag == 'Trending' || tag == 'Rekomendasi',
            ))
        .toList();
    if (withTags.isNotEmpty) {
      return withTags;
    }
    return classes.take(4).toList();
  }

  List<Map<String, String>> get forYouItems {
    final suggestions = [
      {
        'title': 'Dasar Crypto Syariah',
        'reason': 'Cocok buat pemula yang baru mulai',
      },
      {
        'title': 'Fiqh Muamalah untuk Aset Digital',
        'reason': 'Biar makin mantap soal akad',
      },
      {
        'title': 'Menghindari Gharar & Maisir dalam Trading',
        'reason': 'Relevan buat kamu yang aktif trading',
      },
      {
        'title': 'Zakat Aset Digital',
        'reason': 'Praktis buat bersih-bersih harta',
      },
    ];

    final result = <Map<String, String>>[];
    for (final item in suggestions) {
      final classModel = _getClassByTitle(item['title'] ?? '');
      if (classModel != null) {
        result.add({
          'classId': classModel.id,
          'reason': item['reason'] ?? '',
        });
      }
    }
    if (result.isNotEmpty) {
      return result;
    }
    return classes.take(3).map((item) {
      return {
        'classId': item.id,
        'reason': 'Pelan-pelan aja, yang penting paham',
      };
    }).toList();
  }

  ClassModel? getClassById(String id) {
    return classes.firstWhereOrNull((item) => item.id == id);
  }

  ClassModel? _getClassByTitle(String title) {
    return classes.firstWhereOrNull(
      (item) => item.title.toLowerCase() == title.toLowerCase(),
    );
  }

  Future<void> loadClasses() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final remoteClasses = await _repository.fetchClasses();
      if (remoteClasses.isNotEmpty) {
        classes.assignAll(remoteClasses);
      } else if (_session.isDemoMode.value && !EnvConfig.isProduction) {
        classes.assignAll(edukasiDummyClasses());
      } else {
        classes.clear();
      }

      if (!_session.isGuest.value) {
        await _loadBookmarks();
        await _loadProgress();
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat kelas edukasi.';
      if (_session.isDemoMode.value && !EnvConfig.isProduction) {
        classes.assignAll(edukasiDummyClasses());
      } else {
        classes.clear();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadBookmarks() async {
    final userId = _session.userId.value;
    if (userId == null) return;
    try {
      final ids = await _repository.fetchBookmarks(userId);
      bookmarkedIds
        ..clear()
        ..addAll(ids);
    } catch (_) {}
  }

  Future<void> _loadProgress() async {
    final userId = _session.userId.value;
    if (userId == null) return;
    try {
      final rows = await _repository.fetchProgressForUser(userId);
      final progressByClass = {
        for (final row in rows) row['class_id'] as String: row,
      };

      for (final classModel in classes) {
        final row = progressByClass[classModel.id];
        if (row == null) continue;
        final completed = (row['completed_lessons'] as List?)?.map((e) => e.toString()).toSet() ?? {};
        for (final module in classModel.modules) {
          for (final lesson in module.lessons) {
            lesson.isCompleted = completed.contains(lesson.id);
          }
        }
        classModel.progress = (row['progress'] as num?)?.toDouble() ?? 0.0;
      }
      classes.refresh();
    } catch (_) {}
  }

  void toggleBookmark(ClassModel classModel) {
    AuthGuard.requireAuth(
      featureName: 'Bookmark',
      onAllowed: () async {
        final isSaved = bookmarkedIds.contains(classModel.id);
        if (isSaved) {
          bookmarkedIds.remove(classModel.id);
        } else {
          bookmarkedIds.add(classModel.id);
        }
        if (!_session.isGuest.value && !classModel.isLocal) {
          final userId = _session.userId.value;
          if (userId != null) {
            if (isSaved) {
              await _repository.removeBookmark(userId, classModel.id);
            } else {
              await _repository.addBookmark(userId, classModel.id);
            }
          }
        }
      },
    );
  }

  bool isBookmarked(ClassModel classModel) {
    return bookmarkedIds.contains(classModel.id);
  }

  LessonModel getLastLesson(ClassModel classModel) {
    for (final module in classModel.modules) {
      for (final lesson in module.lessons) {
        if (!lesson.isCompleted) {
          return lesson;
        }
      }
    }
    return classModel.modules.first.lessons.first;
  }

  ModuleModel getModuleForLesson(ClassModel classModel, LessonModel lesson) {
    return classModel.modules.firstWhere(
      (module) => module.lessons.contains(lesson),
      orElse: () => classModel.modules.first,
    );
  }

  void markLessonCompleted(ClassModel classModel, LessonModel lesson, bool completed) {
    if (!AuthGuard.canAccess('Simpan progres')) {
      return;
    }
    lesson.isCompleted = completed;
    _refreshProgress(classModel);
    _persistProgress(classModel, lesson);
  }

  void _refreshProgress(ClassModel classModel) {
    final totalLessons = classModel.modules.fold<int>(
      0,
      (sum, module) => sum + module.lessons.length,
    );
    if (totalLessons == 0) return;
    final completed = classModel.modules.fold<int>(
      0,
      (sum, module) =>
          sum + module.lessons.where((lesson) => lesson.isCompleted).length,
    );
    classModel.progress = completed / totalLessons;
    classes.refresh();
  }

  Future<void> _persistProgress(ClassModel classModel, LessonModel lastLesson) async {
    if (classModel.isLocal) return;
    final userId = _session.userId.value;
    if (userId == null) return;
    final completed = <String>[];
    for (final module in classModel.modules) {
      for (final lesson in module.lessons) {
        if (lesson.isCompleted) {
          completed.add(lesson.id);
        }
      }
    }
    await _repository.upsertProgress(
      userId: userId,
      classId: classModel.id,
      lastLessonId: lastLesson.id,
      progress: classModel.progress,
      completedLessons: completed,
    );
  }
}
