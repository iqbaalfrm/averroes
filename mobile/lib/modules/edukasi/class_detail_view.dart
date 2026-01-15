import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import 'edukasi_controller.dart';
import 'edukasi_models.dart';
import 'lesson_player_view.dart';
import 'modul_view.dart';
import '../pustaka/pustaka_view.dart';

class KelasDetailView extends StatelessWidget {
  final ClassModel classModel;

  const KelasDetailView({super.key, required this.classModel});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EdukasiController());
    final coverTheme = getCoverThemeData(classModel.coverTheme);
    final progressValue = classModel.progress;

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Full Width
            _buildHeader(context, coverTheme),

            // Content Area
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classModel.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: MuamalahColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    classModel.subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: MuamalahColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildMetaRow(),
                  const SizedBox(height: 20),
                  
                  _buildProgress(progressValue),
                  const SizedBox(height: 24),
                  
                  _buildActionButtons(controller, progressValue),
                  const SizedBox(height: 28),

                  _buildPustakaLink(),
                  const SizedBox(height: 24),
                  
                  _buildSectionTitle('Yang akan kamu dapat'),
                  const SizedBox(height: 12),
                  ...classModel.outcomes.map((item) => _buildOutcomeItem(item)),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('Modul'),
                  const SizedBox(height: 8),
                  ...classModel.modules.map((module) => _buildModuleAccordion(context, module)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER SECTIONS ---

  Widget _buildHeader(BuildContext context, CoverThemeData coverTheme) {
    return Container(
      width: double.infinity,
      height: 230,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: coverTheme.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.zero, // Membuat header benar-benar full kotak
      ),
      child: Stack(
        children: [
          // Background Decorative Icon
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              coverTheme.icon,
              size: 140,
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          // Content Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  classModel.level,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                classModel.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow() {
    return Row(
      children: [
        _MetaChip(
          label: classModel.level,
          background: MuamalahColors.neutralBg,
          textColor: _getLevelColor(classModel.level),
        ),
        const SizedBox(width: 8),
        _MetaChip(
          label: classModel.duration,
          background: MuamalahColors.neutralBg,
          textColor: MuamalahColors.textMuted,
        ),
        const SizedBox(width: 8),
        _MetaChip(
          label: '${classModel.lessonsCount} lesson',
          background: MuamalahColors.neutralBg,
          textColor: MuamalahColors.textMuted,
        ),
      ],
    );
  }

  Widget _buildProgress(double progressValue) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MuamalahColors.neutralBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress belajar',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: MuamalahColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 8,
              backgroundColor: MuamalahColors.glassBorder,
              valueColor: const AlwaysStoppedAnimation<Color>(
                MuamalahColors.primaryEmerald,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progressValue * 100).toInt()}% selesai',
            style: const TextStyle(
              fontSize: 12,
              color: MuamalahColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(EdukasiController controller, double progressValue) {
    return Row(
      children: [
        Expanded(
          child: _PrimaryButton(
            label: progressValue > 0 ? 'Lanjut dari terakhir' : 'Mulai kelas',
            onTap: () {
              HapticFeedback.lightImpact();
              final lesson = controller.getLastLesson(classModel);
              final module = controller.getModuleForLesson(classModel, lesson);
              Get.to(
                () => LessonPlayerView(
                  classModel: classModel,
                  moduleModel: module,
                  lessonModel: lesson,
                ),
                transition: Transition.rightToLeftWithFade,
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Obx(() {
          final isSaved = controller.isBookmarked(classModel);
          return _SecondaryButton(
            label: isSaved ? 'Tersimpan' : 'Simpan',
            onTap: () {
              HapticFeedback.lightImpact();
              controller.toggleBookmark(classModel);
            },
          );
        }),
      ],
    );
  }

  Widget _buildOutcomeItem(String item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: MuamalahColors.primaryEmerald,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item,
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

  Widget _buildPustakaLink() {
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MuamalahColors.neutralBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.menu_book_rounded, size: 18, color: MuamalahColors.textMuted),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buka Pustaka',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: MuamalahColors.textPrimary),
                ),
                SizedBox(height: 4),
                Text(
                  'Cari referensi tambahan untuk kelas ini.',
                  style: TextStyle(fontSize: 12, color: MuamalahColors.textMuted),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Get.to(() => const PustakaView()),
            child: const Icon(Icons.chevron_right_rounded, color: MuamalahColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleAccordion(BuildContext context, ModuleModel module) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: MuamalahColors.glassBorder),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          title: Text(
            module.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: MuamalahColors.textPrimary,
            ),
          ),
          subtitle: Text(
            '${module.lessons.length} lesson',
            style: const TextStyle(
              fontSize: 12,
              color: MuamalahColors.textMuted,
            ),
          ),
          trailing: const Icon(Icons.expand_more_rounded),
          children: [
            ...module.lessons.take(3).map((lesson) => _buildLessonRow(lesson)),
            const SizedBox(height: 6),
            _SecondaryButton(
              label: 'Buka modul',
              onTap: () {
                HapticFeedback.lightImpact();
                Get.to(
                  () => ModulView(classModel: classModel, moduleModel: module),
                  transition: Transition.rightToLeftWithFade,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonRow(LessonModel lesson) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(_getLessonTypeIcon(lesson.type), size: 16, color: MuamalahColors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              lesson.title,
              style: const TextStyle(fontSize: 12, color: MuamalahColors.textSecondary),
            ),
          ),
          Text(
            '${lesson.durationMin}m',
            style: const TextStyle(fontSize: 11, color: MuamalahColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: MuamalahColors.textPrimary,
      ),
    );
  }

  // --- LOGIC HELPER ---

  Color _getLevelColor(String level) {
    switch (level) {
      case 'Pemula': return MuamalahColors.halal;
      case 'Menengah': return MuamalahColors.proses;
      case 'Mahir': return MuamalahColors.risikoTinggi;
      default: return MuamalahColors.textPrimary;
    }
  }

  IconData _getLessonTypeIcon(LessonType type) {
    switch (type) {
      case LessonType.reading: return Icons.article_rounded;
      case LessonType.video: return Icons.play_circle_outline_rounded;
      case LessonType.audio: return Icons.graphic_eq_rounded;
    }
  }
}

// --- SUB-WIDGETS (COMPONENTS) ---

class _MetaChip extends StatelessWidget {
  final String label;
  final Color background;
  final Color textColor;

  const _MetaChip({required this.label, required this.background, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(12)),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: MuamalahColors.primaryEmerald,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: MuamalahColors.primaryEmerald.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: MuamalahColors.neutralBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: MuamalahColors.glassBorder),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: MuamalahColors.textSecondary),
        ),
      ),
    );
  }
}
