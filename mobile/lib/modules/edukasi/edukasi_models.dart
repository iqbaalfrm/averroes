import 'package:flutter/material.dart';

enum LessonType { reading, video, audio }

enum CoverTheme {
  forest,
  sand,
  dusk,
  clay,
  sea,
  berry,
}

class CoverThemeData {
  final List<Color> gradient;
  final Color accent;
  final IconData icon;

  const CoverThemeData({
    required this.gradient,
    required this.accent,
    required this.icon,
  });
}

class LessonModel {
  final String id;
  final String title;
  final LessonType type;
  final int durationMin;
  final String summary;
  final String content;
  final String videoUrl;
  final String ayatReference;
  final String ayatArabic;
  final String ayatTranslation;
  final String? exerciseId;
  bool isCompleted;

  LessonModel({
    required this.id,
    required this.title,
    required this.type,
    required this.durationMin,
    required this.summary,
    this.content = '',
    this.videoUrl = '',
    this.ayatReference = '',
    this.ayatArabic = '',
    this.ayatTranslation = '',
    this.exerciseId,
    this.isCompleted = false,
  });
}

class ModuleModel {
  final String id;
  final String title;
  final List<LessonModel> lessons;

  ModuleModel({
    required this.id,
    required this.title,
    required this.lessons,
  });
}

class ClassModel {
  final String id;
  final String title;
  final String subtitle;
  final String level;
  final String duration;
  final int lessonsCount;
  double progress;
  final List<String> tags;
  final CoverTheme coverTheme;
  final String description;
  final List<String> outcomes;
  final List<ModuleModel> modules;
  final ExamModel? exam;
  final bool isLocal;

  ClassModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.level,
    required this.duration,
    required this.lessonsCount,
    required this.progress,
    required this.tags,
    required this.coverTheme,
    required this.description,
    required this.outcomes,
    required this.modules,
    this.exam,
    this.isLocal = false,
  });
}

class ExerciseModel {
  final String id;
  final String lessonId;
  final String title;
  final String instructions;
  final int passingScore;
  final int? maxAttempts;
  final List<QuestionModel> questions;

  ExerciseModel({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.instructions,
    required this.passingScore,
    required this.maxAttempts,
    required this.questions,
  });
}

class ExamModel {
  final String id;
  final String classId;
  final String title;
  final String description;
  final int passingScore;
  final int? durationMin;
  final int? maxAttempts;
  final List<QuestionModel> questions;

  ExamModel({
    required this.id,
    required this.classId,
    required this.title,
    required this.description,
    required this.passingScore,
    required this.durationMin,
    required this.maxAttempts,
    required this.questions,
  });
}

class QuestionModel {
  final String id;
  final String text;
  final int order;
  final int points;
  final List<OptionModel> options;

  QuestionModel({
    required this.id,
    required this.text,
    required this.order,
    required this.points,
    required this.options,
  });
}

class OptionModel {
  final String id;
  final String text;
  final int order;

  OptionModel({
    required this.id,
    required this.text,
    required this.order,
  });
}

class CertificateModel {
  final String id;
  final String classId;
  final String classTitle;
  final String certificateNumber;
  final int finalScore;
  final DateTime? issuedAt;
  final String qrPayload;

  CertificateModel({
    required this.id,
    required this.classId,
    required this.classTitle,
    required this.certificateNumber,
    required this.finalScore,
    required this.issuedAt,
    required this.qrPayload,
  });
}

CoverThemeData getCoverThemeData(CoverTheme theme) {
  switch (theme) {
    case CoverTheme.forest:
      return const CoverThemeData(
        gradient: [Color(0xFF0F3D33), Color(0xFF1C6B5A)],
        accent: Color(0xFF8ED6C3),
        icon: Icons.spa_rounded,
      );
    case CoverTheme.sand:
      return const CoverThemeData(
        gradient: [Color(0xFF9C6B3A), Color(0xFFF3D3A1)],
        accent: Color(0xFF7A4C1E),
        icon: Icons.auto_awesome_rounded,
      );
    case CoverTheme.dusk:
      return const CoverThemeData(
        gradient: [Color(0xFF2C2230), Color(0xFF6C4F72)],
        accent: Color(0xFFD8B4FE),
        icon: Icons.nights_stay_rounded,
      );
    case CoverTheme.clay:
      return const CoverThemeData(
        gradient: [Color(0xFF5B3A2E), Color(0xFFE8B89A)],
        accent: Color(0xFFA0623B),
        icon: Icons.local_florist_rounded,
      );
    case CoverTheme.sea:
      return const CoverThemeData(
        gradient: [Color(0xFF123A4A), Color(0xFF2CA6A4)],
        accent: Color(0xFFA7F3D0),
        icon: Icons.waves_rounded,
      );
    case CoverTheme.berry:
      return const CoverThemeData(
        gradient: [Color(0xFF3E1C2A), Color(0xFFB24D6E)],
        accent: Color(0xFFFBCFE8),
        icon: Icons.favorite_rounded,
      );
  }
}
