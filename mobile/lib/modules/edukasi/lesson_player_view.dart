import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../services/auth_guard.dart';
import 'edukasi_controller.dart';
import 'edukasi_models.dart';
import 'exercise_view.dart';

class LessonPlayerController extends GetxController {
  final RxBool isCompleted = false.obs;

  void syncFromLesson(LessonModel lesson) {
    isCompleted.value = lesson.isCompleted;
  }

  void markCompleted(
    EdukasiController edukasiController,
    ClassModel classModel,
    LessonModel lesson,
  ) {
    edukasiController.markLessonCompleted(classModel, lesson, true);
    isCompleted.value = true;
  }
}

class LessonPlayerView extends StatelessWidget {
  final ClassModel classModel;
  final ModuleModel moduleModel;
  final LessonModel lessonModel;

  const LessonPlayerView({
    super.key,
    required this.classModel,
    required this.moduleModel,
    required this.lessonModel,
  });

  @override
  Widget build(BuildContext context) {
    final edukasiController = Get.put(EdukasiController());
    final controller = Get.put(LessonPlayerController());
    controller.syncFromLesson(lessonModel);

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          lessonModel.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLessonHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: _buildLessonBody(),
            ),
            if (lessonModel.exerciseId != null && lessonModel.exerciseId!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _PrimaryAction(
                label: 'Mulai Latihan',
                onTap: () {
                  HapticFeedback.lightImpact();
                  AuthGuard.requireAuth(
                    featureName: 'Simpan progres',
                    onAllowed: () {
                      Get.to(
                        () => ExerciseView(
                          classModel: classModel,
                          lessonModel: lessonModel,
                        ),
                        transition: Transition.rightToLeftWithFade,
                      );
                    },
                  );
                },
              ),
            ],
            const SizedBox(height: 12),
            Obx(() {
              return Row(
                children: [
                  Expanded(
                    child: _SecondaryAction(
                      label: controller.isCompleted.value
                          ? 'Sudah selesai'
                          : 'Tandai selesai',
                      onTap: controller.isCompleted.value
                          ? null
                          : () {
                            HapticFeedback.lightImpact();
                            AuthGuard.requireAuth(
                              featureName: 'Simpan progres',
                              onAllowed: () {
                                controller.markCompleted(
                                  edukasiController,
                                  classModel,
                                  lessonModel,
                                );
                              },
                            );
                          },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PrimaryAction(
                      label: 'Lanjut materi berikutnya',
                      onTap: () {
                        HapticFeedback.lightImpact();
                        if (AuthGuard.canAccess('Simpan progres')) {
                          controller.markCompleted(
                            edukasiController,
                            classModel,
                            lessonModel,
                          );
                        } else {
                          Get.snackbar(
                            'Tersimpan lokal',
                            'Masuk dulu biar progresmu nggak hilang.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white,
                            colorText: MuamalahColors.textPrimary,
                          );
                        }
                        final next = _getNextLesson();
                        if (next == null) {
                          Get.snackbar(
                            'Mantap',
                            'Kamu sudah sampai akhir kelas ini.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white,
                            colorText: MuamalahColors.textPrimary,
                          );
                          return;
                        }
                        Get.off(
                          () => LessonPlayerView(
                            classModel: classModel,
                            moduleModel: next.module,
                            lessonModel: next.lesson,
                          ),
                          transition: Transition.rightToLeftWithFade,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MuamalahColors.glassBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: MuamalahColors.neutralBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getLessonTypeIcon(lessonModel.type),
              color: MuamalahColors.textMuted,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lessonModel.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: MuamalahColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${lessonModel.durationMin} menit',
                  style: const TextStyle(
                    fontSize: 12,
                    color: MuamalahColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonBody() {
    switch (lessonModel.type) {
      case LessonType.reading:
        return _ReadingBody(lesson: lessonModel);
      case LessonType.video:
        return _VideoBody(lesson: lessonModel);
      case LessonType.audio:
        return _AudioBody(lesson: lessonModel);
    }
  }

  _NextLesson? _getNextLesson() {
    final modules = classModel.modules;
    for (var moduleIndex = 0; moduleIndex < modules.length; moduleIndex++) {
      final module = modules[moduleIndex];
      for (var lessonIndex = 0;
          lessonIndex < module.lessons.length;
          lessonIndex++) {
        final lesson = module.lessons[lessonIndex];
        if (lesson.id == lessonModel.id) {
          if (lessonIndex + 1 < module.lessons.length) {
            return _NextLesson(module, module.lessons[lessonIndex + 1]);
          }
          if (moduleIndex + 1 < modules.length) {
            final nextModule = modules[moduleIndex + 1];
            if (nextModule.lessons.isNotEmpty) {
              return _NextLesson(nextModule, nextModule.lessons.first);
            }
          }
        }
      }
    }
    return null;
  }

  IconData _getLessonTypeIcon(LessonType type) {
    switch (type) {
      case LessonType.reading:
        return Icons.article_rounded;
      case LessonType.video:
        return Icons.play_circle_outline_rounded;
      case LessonType.audio:
        return Icons.graphic_eq_rounded;
    }
  }
}

class _ReadingBody extends StatelessWidget {
  final LessonModel lesson;

  const _ReadingBody({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan materi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MuamalahColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            lesson.content.isNotEmpty ? lesson.content : lesson.summary,
            style: const TextStyle(
              fontSize: 13,
              color: MuamalahColors.textSecondary,
              height: 1.6,
            ),
          ),
          if (lesson.ayatReference.isNotEmpty ||
              lesson.ayatArabic.isNotEmpty ||
              lesson.ayatTranslation.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Rujukan Ayat',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: MuamalahColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MuamalahColors.neutralBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (lesson.ayatArabic.isNotEmpty)
                    Text(
                      lesson.ayatArabic,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.6,
                        fontFamily: 'Amiri',
                        color: MuamalahColors.textPrimary,
                      ),
                    ),
                  if (lesson.ayatTranslation.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      lesson.ayatTranslation,
                      style: const TextStyle(
                        fontSize: 13,
                        color: MuamalahColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ],
                  if (lesson.ayatReference.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      lesson.ayatReference,
                      style: const TextStyle(
                        fontSize: 12,
                        color: MuamalahColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VideoBody extends StatelessWidget {
  final LessonModel lesson;

  const _VideoBody({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: MuamalahColors.neutralBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.play_circle_fill_rounded, size: 56, color: MuamalahColors.textMuted),
                SizedBox(height: 8),
                Text('Video materi', style: TextStyle(color: MuamalahColors.textMuted)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            lesson.content.isNotEmpty ? lesson.content : lesson.summary,
            style: const TextStyle(
              fontSize: 13,
              color: MuamalahColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _AudioBody extends StatelessWidget {
  final LessonModel lesson;

  const _AudioBody({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: MuamalahColors.neutralBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  children: const [
                    Icon(Icons.graphic_eq_rounded, color: MuamalahColors.textMuted),
                    SizedBox(width: 8),
                    Text('Audio materi', style: TextStyle(color: MuamalahColors.textMuted)),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: MuamalahColors.glassBorder,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('0:00', style: TextStyle(fontSize: 11, color: MuamalahColors.textMuted)),
                    Text('6:30', style: TextStyle(fontSize: 11, color: MuamalahColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            lesson.content.isNotEmpty ? lesson.content : lesson.summary,
            style: const TextStyle(
              fontSize: 13,
              color: MuamalahColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;

  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: MuamalahColors.primaryEmerald,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: MuamalahColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: MuamalahColors.primaryEmerald,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _SecondaryAction({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: MuamalahColors.neutralBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: MuamalahColors.glassBorder),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: MuamalahColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _NextLesson {
  final ModuleModel module;
  final LessonModel lesson;

  const _NextLesson(this.module, this.lesson);
}
