import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../widgets/custom_dialog.dart';
import 'pdf_viewer_view.dart';
import 'pustaka_controller.dart';
import 'pustaka_models.dart';

class BookDetailView extends StatelessWidget {
  final BookModel book;

  const BookDetailView({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final bool hasPdf = book.pdfUrl != null && book.pdfUrl!.isNotEmpty;
    final controller = Get.find<PustakaController>();

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      if (book.isPremium)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                size: 14,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'ISTIMEWA',
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
                      Obx(() {
                        final isBookmarked = controller.isBookmarked(book.id);
                        return GestureDetector(
                          onTap: () => controller.toggleBookmark(book),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: MuamalahColors.neutralBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isBookmarked
                                  ? Icons.bookmark_rounded
                                  : Icons.bookmark_outline_rounded,
                              size: 20,
                              color: MuamalahColors.neutral,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 140,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              book.color ?? MuamalahColors.primaryEmerald,
                              (book.color ?? MuamalahColors.primaryEmerald)
                                  .withAlpha(179),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: (book.color ?? MuamalahColors.primaryEmerald)
                                  .withAlpha(77),
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
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
                                '${book.pages ?? '-'}',
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

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                book.language,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: MuamalahColors.halal,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              book.titleReadable ?? book.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MuamalahColors.textPrimary,
                                height: 1.3,
                              ),
                            ),

                            if (book.titleOriginal != null) ...[
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
                                  book.titleOriginal!,
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

                            if (book.titleReadable != null &&
                                book.titleReadable != book.title) ...[
                              const SizedBox(height: 8),
                              Text(
                                book.titleReadable!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: MuamalahColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],

                            const SizedBox(height: 12),

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
                                    book.author,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: MuamalahColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                _buildInfoChip(
                                  Icons.category_outlined,
                                  book.category,
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

            if (hasPdf)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => _handleReadPdf(controller),
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

            if (hasPdf) const SizedBox(height: 16),

            Obx(() {
              final progress = controller.getProgress(book.id);
              if (progress == null || progress.pageCount == 0) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: MuamalahColors.neutralBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: MuamalahColors.glassBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bookmark_added_rounded,
                        size: 18,
                        color: MuamalahColors.primaryEmerald,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Terakhir dibaca: halaman ${progress.lastPage} dari ${progress.pageCount}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: MuamalahColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

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
                          book.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: MuamalahColors.textSecondary,
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Buku ini memberikan panduan praktis bagi umat Islam yang ingin memahami dan berpartisipasi dalam ekonomi digital dengan tetap menjaga prinsip-prinsip syariah.',
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
                          'Pemahaman dasar tentang teknologi rantai blok dan aset kripto dalam perspektif Islam',
                        ),
                        _buildKeyPoint(
                          'Kriteria penilaian halal-haram dalam transaksi aset digital berdasarkan dalil syari',
                        ),
                        _buildKeyPoint(
                          'Panduan praktis menghitung dan menunaikan zakat dari aset kripto',
                        ),
                        _buildKeyPoint(
                          'Prinsip kehati-hatian dalam berinvestasi di pasar yang volatil',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.markAsRead(book),
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
                  Obx(() {
                    final isBookmarked = controller.isBookmarked(book.id);
                    return GestureDetector(
                      onTap: () => controller.toggleBookmark(book),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: MuamalahColors.glassBorder),
                        ),
                        child: Icon(
                          isBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_outline_rounded,
                          color: MuamalahColors.neutral,
                          size: 20,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> _handleReadPdf(PustakaController controller) async {
    final pdfUrl = await controller.resolvePdfUrl(book);
    if (pdfUrl == null) {
      AppDialogs.showInfo(
        title: 'PDF belum tersedia',
        message: 'File PDF untuk buku ini belum disediakan.',
      );
      return;
    }

    final progress = controller.getProgress(book.id);

    Get.to(
      () => PdfViewerView(
        title: book.titleReadable ?? book.title,
        pdfUrl: pdfUrl,
        initialPage: progress?.lastPage,
        onPageChanged: (pageNumber, pageCount) {
          controller.handlePageChanged(
            bookId: book.id,
            pageNumber: pageNumber,
            pageCount: pageCount,
          );
        },
      ),
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
