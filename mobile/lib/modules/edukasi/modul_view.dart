import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import 'edukasi_models.dart';
import 'lesson_player_view.dart';

class ModulView extends StatelessWidget {
  final ClassModel classModel;
  final ModuleModel moduleModel;

  const ModulView({super.key, required this.classModel, required this.moduleModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Modul'),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        children: [
          Text(
            moduleModel.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MuamalahColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            classModel.title,
            style: const TextStyle(
              fontSize: 13,
              color: MuamalahColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          ...moduleModel.lessons.map((lesson) {
            return _LessonTile(
              lesson: lesson,
              onTap: () {
                HapticFeedback.lightImpact();
                Get.to(
                  () => LessonPlayerView(
                    classModel: classModel,
                    moduleModel: moduleModel,
                    lessonModel: lesson,
                  ),
                  transition: Transition.rightToLeftWithFade,
                  duration: const Duration(milliseconds: 300),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback onTap;

  const _LessonTile({required this.lesson, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: MuamalahColors.glassBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
                _getLessonTypeIcon(lesson.type),
                color: MuamalahColors.textMuted,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: MuamalahColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${lesson.durationMin} menit',
                    style: const TextStyle(
                      fontSize: 12,
                      color: MuamalahColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (lesson.isCompleted)
              const Icon(Icons.check_circle_rounded, color: MuamalahColors.halal)
            else
              const Icon(Icons.chevron_right_rounded, color: MuamalahColors.textMuted),
          ],
        ),
      ),
    );
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
