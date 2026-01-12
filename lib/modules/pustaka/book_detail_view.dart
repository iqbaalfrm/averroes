import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '../../theme/app_theme.dart';
import '../../services/app_session_controller.dart'; // Import correctly
import '../../widgets/custom_dialog.dart';
import '../auth/login_view.dart';
import 'pdf_viewer_view.dart';

// ============================================================================
// BOOK DETAIL VIEW - PUSTAKA CRYPTO AVERROES
// Tampilan detail buku dengan support PDF Reader & Auth Gating
// ============================================================================

class BookDetailView extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetailView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final bool hasPdf = book['pdfUrl'] != null;
    final bool isPremium = book['isPremium'] == true;
    final bool isArabic = book['language'] == 'ARAB';

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with book cover
            Container(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
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
                  // Back button & actions
                  Row(
                    children: [
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
                      const Spacer(),
                      // Premium badge
                      if (isPremium)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'PREMIUM',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(width: 8),
                      // Bookmark button
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: MuamalahColors.neutralBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.bookmark_outline_rounded,
                          size: 20,
                          color: MuamalahColors.neutral,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Book info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Book cover
                      Container(
                        width: 100,
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              book['color'] as Color,
                              (book['color'] as Color).withAlpha(179),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: (book['color'] as Color).withAlpha(77),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.menu_book_rounded,
                              size: 32,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8),
                            if (hasPdf)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(51),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'PDF',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            else
                              Text(
                                '${book['pages']}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Book details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Language badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: MuamalahColors.halalBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                book['language'] ?? 'Indonesia',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: MuamalahColors.halal,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // JUDUL UTAMA (Readable)
                            Text(
                              book['title'] ?? 'Judul Buku',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MuamalahColors.textPrimary,
                                height: 1.3,
                              ),
                            ),

                            // JUDUL ORIGINAL (Arab - RTL)
                            if (book['titleOriginal'] != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B5CF6).withAlpha(15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFF8B5CF6).withAlpha(30),
                                  ),
                                ),
                                child: Text(
                                  book['titleOriginal'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF8B5CF6),
                                    fontFamily: 'Amiri',
                                    height: 1.5,
                                  ),
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],

                            // JUDUL INDONESIA (Jika ada)
                            if (book['titleId'] != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                book['titleId'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: MuamalahColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],

                            const SizedBox(height: 12),

                            // Author
                            Row(
                              children: [
                                const Icon(
                                  Icons.person_outline_rounded,
                                  size: 14,
                                  color: MuamalahColors.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    book['author'] ?? 'Penulis',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: MuamalahColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Category
                            Row(
                              children: [
                                _buildInfoChip(
                                  Icons.category_outlined,
                                  book['category'] ?? 'Muamalah',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ================================================================
            // TOMBOL BACA PDF (Jika ada pdfUrl)
            // ================================================================
            if (hasPdf)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => _handleReadPdf(context, isPremium),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withAlpha(77),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chrome_reader_mode_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Baca PDF',
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

            if (hasPdf) const SizedBox(height: 24),

            // Ringkasan Isi Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ringkasan Isi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MuamalahColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Summary paragraphs
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(8),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book['description'] ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: MuamalahColors.textSecondary,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Buku ini memberikan panduan praktis bagi umat Islam yang ingin memahami dan berpartisipasi dalam ekonomi digital dengan tetap menjaga prinsip-prinsip syariah. Pembahasan mencakup aspek fiqh muamalah kontemporer yang relevan dengan perkembangan teknologi blockchain dan aset kripto.',
                          style: TextStyle(
                            fontSize: 14,
                            color: MuamalahColors.textSecondary,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Key Takeaways
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Poin-Poin Utama',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MuamalahColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: MuamalahColors.halalBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: MuamalahColors.halal.withAlpha(51),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildKeyPoint(
                          'Pemahaman dasar tentang teknologi blockchain dan cryptocurrency dalam perspektif Islam',
                        ),
                        _buildKeyPoint(
                          'Kriteria penilaian halal-haram dalam transaksi aset digital berdasarkan dalil syar\'i',
                        ),
                        _buildKeyPoint(
                          'Panduan praktis menghitung dan menunaikan zakat dari aset cryptocurrency',
                        ),
                        _buildKeyPoint(
                          'Prinsip kehati-hatian (ihtiyat) dalam berinvestasi di pasar yang volatile',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Scholarly Note
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MuamalahColors.prosesBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: MuamalahColors.proses.withAlpha(51),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 20,
                      color: MuamalahColors.proses,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Catatan: Pembahasan dalam buku ini bersifat kajian ilmiah. Untuk keputusan fiqh individual, disarankan berkonsultasi dengan ulama yang kompeten.',
                        style: TextStyle(
                          fontSize: 12,
                          color: MuamalahColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        AppDialogs.showSuccess(
                          title: 'Berhasil',
                          message: 'Buku ditandai sebagai dibaca',
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: MuamalahColors.primaryEmerald,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Tandai Dibaca',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      AppDialogs.showSuccess(
                        title: 'Disimpan',
                        message: 'Buku ditambahkan ke favorit',
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: MuamalahColors.glassBorder),
                      ),
                      child: const Icon(
                        Icons.favorite_outline_rounded,
                        color: MuamalahColors.neutral,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // =====================================================================
  // HANDLE BACA PDF (dengan Auth Gating)
  // =====================================================================
  void _handleReadPdf(BuildContext context, bool isPremium) {
    // Cek Session
    final sessionController = Get.find<AppSessionController>();
    final bool isGuest = sessionController.isGuest.value;

    print('📖 [BookDetail] Baca PDF - isPremium: $isPremium, isGuest: $isGuest');

    // Guest tidak boleh akses konten premium
    if (isPremium && isGuest) {
      _showLoginRequiredDialog(context);
      return;
    }

    // User sudah login atau konten non-premium -> Buka PDF
    Get.to(() => PdfViewerView(
      title: book['title'] ?? 'Buku',
      pdfUrl: book['pdfUrl'],
    ));
  }

  // =====================================================================
  // DIALOG LOGIN DIPERLUKAN
  // =====================================================================
  void _showLoginRequiredDialog(BuildContext context) {
    Get.dialog(
      Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(245),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withAlpha(180),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            MuamalahColors.proses.withAlpha(51),
                            MuamalahColors.proses.withAlpha(25),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.lock_outline_rounded,
                          size: 36,
                          color: MuamalahColors.proses,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Title
                    const Text(
                      'Login Diperlukan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: MuamalahColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Message
                    const Text(
                      'Fitur ini khusus untuk pengguna yang sudah login.\nSilakan login atau daftar untuk melanjutkan.',
                      style: TextStyle(
                        fontSize: 14,
                        color: MuamalahColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 28),
                    
                    // Primary Button: Login
                    GestureDetector(
                      onTap: () {
                        Get.back(); // Tutup dialog
                        Get.offAll(() => const LoginView());
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              MuamalahColors.primaryEmerald,
                              MuamalahColors.emeraldLight,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: MuamalahColors.primaryEmerald.withAlpha(77),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.login_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Login / Daftar',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 14),
                    
                    // Secondary Button: Batal
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: MuamalahColors.neutralBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: MuamalahColors.glassBorder),
                        ),
                        child: const Center(
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: MuamalahColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.black.withAlpha(128),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: MuamalahColors.neutralBg,
        borderRadius: BorderRadius.circular(8),
        ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: MuamalahColors.neutral),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: MuamalahColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: MuamalahColors.halal,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
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
