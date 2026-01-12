import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_dialog.dart';

// ============================================================================
// CLASS DETAIL VIEW - EDUKASI
// A real structured learning experience
// ============================================================================

class ClassDetailController extends GetxController {
  final RxInt currentLessonIndex = 0.obs;
  final RxList<bool> completedLessons = <bool>[].obs;

  void initLessons(int count) {
    completedLessons.value = List.generate(count, (i) => i < 2); // First 2 completed
  }

  void toggleLesson(int index) {
    if (index < completedLessons.length) {
      completedLessons[index] = !completedLessons[index];
    }
  }
}

class ClassDetailView extends StatelessWidget {
  final Map<String, dynamic> classData;

  const ClassDetailView({super.key, required this.classData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ClassDetailController());
    
    final lessons = _getLessonsForClass(classData['title'] ?? '');
    controller.initLessons(lessons.length);

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(8),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: MuamalahColors.neutralBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, size: 20),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Level badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getLevelColor(classData['level']).withAlpha(31),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      classData['level'] ?? 'Pemula',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getLevelColor(classData['level']),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Title
                  Text(
                    classData['title'] ?? 'Judul Kelas',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: MuamalahColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    classData['description'] ?? 'Deskripsi kelas',
                    style: TextStyle(
                      fontSize: 14,
                      color: MuamalahColors.textSecondary,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Progress & Stats
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: MuamalahColors.neutralBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Progress Belajar',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: MuamalahColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: (classData['progress'] ?? 0.3),
                                        backgroundColor: MuamalahColors.glassBorder,
                                        valueColor: AlwaysStoppedAnimation(
                                          MuamalahColors.primaryEmerald,
                                        ),
                                        minHeight: 6,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${((classData['progress'] ?? 0.3) * 100).toInt()}%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: MuamalahColors.primaryEmerald,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: MuamalahColors.glassBorder,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        Column(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              color: MuamalahColors.neutral,
                              size: 20,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              classData['duration'] ?? '45 menit',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: MuamalahColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Lessons Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Daftar Materi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: MuamalahColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${lessons.length} Materi',
                        style: TextStyle(
                          fontSize: 13,
                          color: MuamalahColors.textMuted,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Lessons list
                  ...lessons.asMap().entries.map((entry) {
                    final index = entry.key;
                    final lesson = entry.value;
                    return Obx(() => _buildLessonCard(
                      index: index,
                      lesson: lesson,
                      isCompleted: controller.completedLessons.length > index
                          ? controller.completedLessons[index]
                          : false,
                      onTap: () => _showLessonDetail(context, lesson),
                    ));
                  }),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Continue Learning Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  AppDialogs.showSuccess(
                    title: 'Melanjutkan',
                    message: 'Membuka materi berikutnya...',
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: MuamalahColors.primaryEmerald,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_outline_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Lanjutkan Belajar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonCard({
    required int index,
    required Map<String, String> lesson,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCompleted
                ? MuamalahColors.halal.withAlpha(51)
                : MuamalahColors.glassBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            // Lesson number / check
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted
                    ? MuamalahColors.halalBg
                    : MuamalahColors.neutralBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: isCompleted
                    ? Icon(
                        Icons.check_rounded,
                        color: MuamalahColors.halal,
                        size: 20,
                      )
                    : Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: MuamalahColors.textSecondary,
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 14),

            // Lesson info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson['title'] ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: MuamalahColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson['duration'] ?? '5 menit',
                    style: TextStyle(
                      fontSize: 12,
                      color: MuamalahColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right_rounded,
              color: MuamalahColors.neutral,
            ),
          ],
        ),
      ),
    );
  }

  void _showLessonDetail(BuildContext context, Map<String, String> lesson) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: MuamalahColors.glassBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              lesson['title'] ?? '',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MuamalahColors.textPrimary,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: MuamalahColors.neutral,
                ),
                const SizedBox(width: 6),
                Text(
                  lesson['duration'] ?? '5 menit',
                  style: TextStyle(
                    fontSize: 13,
                    color: MuamalahColors.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Description
            Text(
              lesson['description'] ?? 'Deskripsi materi pembelajaran.',
              style: TextStyle(
                fontSize: 14,
                color: MuamalahColors.textSecondary,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 24),

            // Start Lesson Button
            GestureDetector(
              onTap: () {
                Get.back();
                AppDialogs.showSuccess(
                  title: 'Memulai Materi',
                  message: '${lesson['title']} dimulai...',
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: MuamalahColors.primaryEmerald,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Mulai Materi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _getLevelColor(String? level) {
    switch (level) {
      case 'Pemula':
        return MuamalahColors.halal;
      case 'Menengah':
        return MuamalahColors.proses;
      case 'Lanjutan':
        return MuamalahColors.primaryEmerald;
      default:
        return MuamalahColors.neutral;
    }
  }

  List<Map<String, String>> _getLessonsForClass(String title) {
    if (title.contains('Blockchain')) {
      return [
        {'title': 'Pengantar Teknologi Blockchain', 'duration': '8 menit', 'description': 'Memahami konsep dasar blockchain sebagai sistem pencatatan terdesentralisasi yang menjadi fondasi cryptocurrency. Materi mencakup sejarah singkat dan prinsip kerja blockchain.'},
        {'title': 'Cara Kerja Transaksi Digital', 'duration': '10 menit', 'description': 'Mempelajari bagaimana transaksi digital diproses, diverifikasi, dan dicatat dalam blockchain. Termasuk konsep mining dan validasi.'},
        {'title': 'Konsensus dan Keamanan', 'duration': '7 menit', 'description': 'Memahami mekanisme konsensus seperti Proof of Work dan Proof of Stake yang menjaga keamanan jaringan blockchain.'},
        {'title': 'Jenis-Jenis Cryptocurrency', 'duration': '12 menit', 'description': 'Mengenal berbagai jenis cryptocurrency: Bitcoin, Ethereum, stablecoin, dan token utilitas. Perbedaan fungsi dan karakteristik masing-masing.'},
        {'title': 'Wallet dan Penyimpanan Aset', 'duration': '8 menit', 'description': 'Panduan praktis tentang cara menyimpan cryptocurrency dengan aman menggunakan wallet digital (hot wallet dan cold wallet).'},
      ];
    } else if (title.contains('Hukum') || title.contains('Islam')) {
      return [
        {'title': 'Prinsip Muamalah dalam Islam', 'duration': '10 menit', 'description': 'Memahami kaidah-kaidah dasar fiqh muamalah yang menjadi landasan hukum transaksi dalam Islam.'},
        {'title': 'Larangan Riba dan Gharar', 'duration': '12 menit', 'description': 'Mengkaji secara mendalam tentang riba (bunga) dan gharar (ketidakjelasan) serta aplikasinya dalam transaksi modern.'},
        {'title': 'Status Hukum Cryptocurrency', 'duration': '15 menit', 'description': 'Pembahasan fatwa-fatwa ulama kontemporer tentang hukum cryptocurrency. Terdapat perbedaan pendapat yang perlu dipahami.'},
        {'title': 'Kriteria Aset Digital Halal', 'duration': '10 menit', 'description': 'Mempelajari parameter dan kriteria untuk menilai kehalalan suatu aset digital berdasarkan prinsip syariah.'},
        {'title': 'Studi Kasus: Bitcoin & Ethereum', 'duration': '12 menit', 'description': 'Analisis mendalam status hukum Bitcoin dan Ethereum berdasarkan berbagai pendapat ulama.'},
        {'title': 'Investasi vs Spekulasi', 'duration': '8 menit', 'description': 'Membedakan antara investasi yang dibolehkan dengan spekulasi (maysir) yang dilarang dalam Islam.'},
      ];
    } else {
      return [
        {'title': 'Pengantar Materi', 'duration': '5 menit', 'description': 'Pengenalan umum tentang topik yang akan dipelajari dan tujuan pembelajaran.'},
        {'title': 'Konsep Dasar', 'duration': '10 menit', 'description': 'Memahami konsep-konsep fundamental yang menjadi dasar pembahasan materi.'},
        {'title': 'Pembahasan Utama', 'duration': '15 menit', 'description': 'Materi inti dengan pembahasan mendalam tentang topik utama.'},
        {'title': 'Studi Kasus', 'duration': '10 menit', 'description': 'Contoh-contoh praktis dan aplikasi nyata dari materi yang dipelajari.'},
        {'title': 'Kesimpulan & Tindak Lanjut', 'duration': '5 menit', 'description': 'Ringkasan materi dan panduan untuk pembelajaran lebih lanjut.'},
      ];
    }
  }
}
