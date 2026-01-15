import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import 'class_detail_view.dart';
import 'edukasi_controller.dart';
import 'edukasi_models.dart';
import 'lesson_player_view.dart';

class EdukasiHomeView extends StatelessWidget {
  final bool showBackButton;

  const EdukasiHomeView({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EdukasiController());

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.classes.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: MuamalahColors.primaryEmerald),
            );
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(controller),
                const SizedBox(height: 24),
                if (controller.errorMessage.value.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: MuamalahColors.prosesBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(fontSize: 12, color: MuamalahColors.textSecondary),
                    ),
                  ),
                const SizedBox(height: 16),
                _buildContinueLearning(controller),
                const SizedBox(height: 32),
                _buildPopularSection(controller),
                const SizedBox(height: 32),
                _buildForYouSection(controller),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader(EdukasiController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBackButton)
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: MuamalahColors.neutralBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_rounded, size: 18),
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Edukasi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MuamalahColors.textPrimary,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Belajar pelan-pelan, biar paham beneran',
                style: TextStyle(
                  fontSize: 13,
                  color: MuamalahColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            _showFilterSheet();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MuamalahColors.neutralBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune_rounded, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueLearning(EdukasiController controller) {
    final classModel = controller.continueClass;
    final theme = getCoverThemeData(classModel.coverTheme);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.gradient.first, theme.gradient.last.withOpacity(0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  theme.icon,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classModel.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _Badge(
                          label: classModel.level,
                          background: Colors.white.withOpacity(0.18),
                          textColor: Colors.white,
                        ),
                        _Badge(
                          label: classModel.duration,
                          background: Colors.white.withOpacity(0.18),
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: classModel.progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(theme.accent),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${(classModel.progress * 100).toInt()}% selesai',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
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
                duration: const Duration(milliseconds: 300),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'Lanjut dikit yuk ?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: MuamalahColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularSection(EdukasiController controller) {
    final popularClasses = controller.popularClasses;
    if (popularClasses.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kelas Populer Minggu Ini',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MuamalahColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: controller.popularController,
            itemCount: popularClasses.length,
            onPageChanged: (index) => controller.popularIndex.value = index,
            itemBuilder: (context, index) {
              final item = popularClasses[index];
              final theme = getCoverThemeData(item.coverTheme);
              final topOffset = index.isEven ? 0.0 : 14.0;
              return Transform.translate(
                offset: Offset(0, topOffset),
                child: _PopularCard(
                  classModel: item,
                  theme: theme,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Get.to(
                      () => KelasDetailView(classModel: item),
                      transition: Transition.rightToLeftWithFade,
                      duration: const Duration(milliseconds: 300),
                    );
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(popularClasses.length, (index) {
              final isActive = controller.popularIndex.value == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 20 : 8,
                height: 6,
                decoration: BoxDecoration(
                  color: isActive
                      ? MuamalahColors.primaryEmerald
                      : MuamalahColors.glassBorder,
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _buildForYouSection(EdukasiController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Untuk Kamu Hari Ini',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MuamalahColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        ...controller.forYouItems.map((item) {
          final classModel = controller.getClassById(item['classId'] ?? '');
          if (classModel == null) return const SizedBox.shrink();
          return _ForYouCard(
            title: classModel.title,
            reason: item['reason'] ?? '',
            onTap: () {
              HapticFeedback.lightImpact();
              Get.to(
                () => KelasDetailView(classModel: classModel),
                transition: Transition.rightToLeftWithFade,
                duration: const Duration(milliseconds: 300),
              );
            },
          );
        }),
      ],
    );
  }

  void _showFilterSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: MuamalahColors.glassBorder,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Filter cepat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                _FilterChip(label: 'Pemula'),
                _FilterChip(label: 'Menengah'),
                _FilterChip(label: 'Mahir'),
                _FilterChip(label: 'Baru'),
                _FilterChip(label: 'Populer'),
              ],
            ),
            const SizedBox(height: 20),
            _SheetButton(
              label: 'Tutup',
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}

class EdukasiPageView extends StatelessWidget {
  final bool showBackButton;

  const EdukasiPageView({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return EdukasiHomeView(showBackButton: showBackButton);
  }
}

class _PopularCard extends StatelessWidget {
  final ClassModel classModel;
  final CoverThemeData theme;
  final VoidCallback onTap;

  const _PopularCard({
    required this.classModel,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tag = classModel.tags.isNotEmpty ? classModel.tags.first : 'Trending';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(theme.icon, color: Colors.white.withOpacity(0.8)),
              ],
            ),
            const Spacer(),
            Text(
              classModel.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                _Badge(
                  label: classModel.level,
                  background: Colors.white.withOpacity(0.18),
                  textColor: Colors.white,
                ),
                _Badge(
                  label: classModel.duration,
                  background: Colors.white.withOpacity(0.18),
                  textColor: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text(
                'Mulai',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MuamalahColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForYouCard extends StatelessWidget {
  final String title;
  final String reason;
  final VoidCallback onTap;

  const _ForYouCard({
    required this.title,
    required this.reason,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: MuamalahColors.glassBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: MuamalahColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    reason,
                    style: const TextStyle(
                      fontSize: 12,
                      color: MuamalahColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: MuamalahColors.neutralBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Lihat',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MuamalahColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color background;
  final Color textColor;

  const _Badge({
    required this.label,
    required this.background,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;

  const _FilterChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: MuamalahColors.neutralBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MuamalahColors.glassBorder),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: MuamalahColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SheetButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: MuamalahColors.primaryEmerald,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
