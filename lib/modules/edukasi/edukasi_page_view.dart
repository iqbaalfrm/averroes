import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import 'class_detail_view.dart';

// ============================================================================
// EDUKASI CONTROLLER
// ============================================================================

class EdukasiController extends GetxController {
  final RxBool isLoading = true.obs;

  // Active Course (Lanjutkan Belajar)
  final RxMap<String, dynamic> activeCourse = {
    'title': 'Fiqh Muamalah untuk Aset Digital',
    'level': 'Menengah',
    'duration': '3 Jam',
    'progress': 0.45,
    'image_icon': Icons.whatshot_rounded, // Placeholder for burning coin
    'image_color': Color(0xFF1E1E1E), // Dark background for image
  }.obs;

  // All Courses List
  final RxList<Map<String, dynamic>> allCourses = [
    {
      'title': 'Dasar Crypto Syariah',
      'level': 'Pemula',
      'duration': '2 Jam',
      'status': 'Baru',
      'icon': Icons.language_rounded,
      'color': Color(0xFF0F392B), // Dark Green
      'accent': MuamalahColors.primaryEmerald,
    },
    {
      'title': 'Pengantar Zakat Saham',
      'level': 'Pemula',
      'duration': '1.5 Jam',
      'status': 'Baru',
      'icon': Icons.bar_chart_rounded,
      'color': Color(0xFFFFE0C8), // Peach
      'accent': Color(0xFFD97706),
    },
    {
      'title': 'Audit Smart Contract',
      'level': 'Mahir',
      'duration': '4 Jam',
      'status': 'Lanjutan',
      'icon': Icons.security_rounded,
      'color': Color(0xFF0F172A), // Dark Blue/Black
      'accent': Color(0xFF3B82F6),
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 400), () {
      isLoading.value = false;
    });
  }
}

// ============================================================================
// EDUKASI PAGE VIEW
// ============================================================================

class EdukasiPageView extends StatelessWidget {
  final bool showBackButton;
  const EdukasiPageView({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EdukasiController());

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: MuamalahColors.backgroundPrimary,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: showBackButton
            ? IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_rounded, color: MuamalahColors.textPrimary),
              )
            : null,
        title: const Text(
          'Kelas Edukasi Islami',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MuamalahColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded, color: MuamalahColors.textPrimary),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: MuamalahColors.primaryEmerald,
            ),
          );
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              const Text(
                'Lanjutkan Belajar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MuamalahColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Active Course Card
              _buildActiveCourseCard(controller.activeCourse),

              const SizedBox(height: 32),

              // Section Header: Semua Kelas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Semua Kelas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MuamalahColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: MuamalahColors.primaryEmerald,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Courses List
              ...controller.allCourses.map((course) => _buildCourseItem(course)),
              
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildActiveCourseCard(Map<String, dynamic> course) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge Row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEDD5), // Orange-ish light
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            course['level'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC2410C), // Orange dark
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• ${course['duration']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: MuamalahColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      course['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MuamalahColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Progress Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progress',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: MuamalahColors.primaryEmerald,
                          ),
                        ),
                        Text(
                          '${(course['progress'] * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: MuamalahColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: course['progress'],
                        minHeight: 6,
                        backgroundColor: MuamalahColors.neutralBg,
                        valueColor: const AlwaysStoppedAnimation<Color>(MuamalahColors.primaryEmerald),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Course Image Placeholder
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: course['image_color'],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  course['image_icon'],
                  color: Colors.amber,
                  size: 48,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Continue Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: MuamalahColors.primaryEmerald,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lanjut Belajar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.play_arrow_rounded, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseItem(Map<String, dynamic> course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Box
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: course['color'],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              course['icon'],
              color: course['color'] == Colors.white ? course['accent'] : Colors.white.withOpacity(0.8),
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      course['level'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getLevelColor(course['level']),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '•',
                      style: TextStyle(color: MuamalahColors.textMuted),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      course['duration'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: MuamalahColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  course['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MuamalahColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                // Footer Row: Status & Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      course['status'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: MuamalahColors.textMuted,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5), // Light Green
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Mulai',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: MuamalahColors.primaryEmerald,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'Pemula':
        return MuamalahColors.primaryEmerald;
      case 'Mahir':
        return Color(0xFFC2410C); // Orange dark
      default:
        return MuamalahColors.textPrimary;
    }
  }
}
