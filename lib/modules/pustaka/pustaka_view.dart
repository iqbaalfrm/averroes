import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import 'book_detail_view.dart';

// ============================================================================
// PUSTAKA CONTROLLER
// ============================================================================

class PustakaController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxString selectedCategory = 'Semua'.obs;

  final List<String> categories = [
    'Semua',
    'Fiqh Muamalah',
    'Crypto Syariah',
    'Ekonomi Islam',
    'Referensi Ulama',
  ];

  final List<Map<String, dynamic>> books = [
    // ========================================================================
    // BUKU PDF ASLI (Premium - Memerlukan Login)
    // ========================================================================
    {
      'title': 'Hukum Fiqih terhadap Uang Kertas (Fiat)',
      'titleOriginal': 'حكم الفقه على النقود الورقية',
      'titleId': null,
      'author': '-',
      'language': 'ARAB',
      'category': 'Fiqh Muamalah',
      'pages': '-',
      'description': 'Kajian fiqhiyah mendalam tentang status hukum uang kertas (fiat) menurut perspektif syariah. Membahas dalil-dalil tentang legalitas mata uang modern dan implikasinya terhadap akad muamalah.',
      'color': const Color(0xFF8B5CF6),
      'isPremium': true,
      'pdfUrl': 'https://drive.google.com/uc?export=download&id=1r0pw69ZF1kIyesBPeQRjoWy7o4kM9eI-',
    },
    {
      'title': 'Al-Ahkām Al-Fiqhiyyah Al-Muta\'alliqa bil-\'Umulāt Al-Iliktrūniyyah',
      'titleOriginal': 'الأحكام الفقهية المتعلقة بالعملات الإلكترونية',
      'titleId': 'Hukum-Hukum Fiqih Terkait Mata Uang Elektronik',
      'author': '-',
      'language': 'ARAB',
      'category': 'Fiqh Muamalah',
      'pages': '-',
      'description': 'Pembahasan komprehensif tentang hukum fiqh terkait mata uang elektronik dan cryptocurrency. Mengkaji status syariah dari berbagai jenis aset digital berdasarkan kaidah fiqh muamalah.',
      'color': MuamalahColors.primaryEmerald,
      'isPremium': true,
      'pdfUrl': 'https://drive.google.com/uc?export=download&id=1UUdluf4gXY3R04tXLwUXX8qU0nYTZRsx',
    },
    // ========================================================================
    // BUKU REFERENSI (Dummy - Tidak ada PDF)
    // ========================================================================
    {
      'title': 'فقه المعاملات المالية',
      'titleOriginal': null,
      'titleId': 'Fiqh Muamalah Maliyah',
      'author': 'Dr. Wahbah Az-Zuhaili',
      'language': 'ARAB',
      'category': 'Fiqh Muamalah',
      'pages': 450,
      'description': 'Kitab komprehensif tentang hukum transaksi keuangan dalam Islam, mencakup jual beli, sewa, dan berbagai akad modern.',
      'color': const Color(0xFF6366F1),
      'isPremium': false,
      'pdfUrl': null,
    },
    {
      'title': 'Cryptocurrency dalam Perspektif Syariah',
      'titleOriginal': null,
      'titleId': null,
      'author': 'Dr. Ahmad Ifham Sholihin',
      'language': 'INDONESIA',
      'category': 'Crypto Syariah',
      'pages': 280,
      'description': 'Analisis komprehensif tentang status hukum cryptocurrency menurut kaidah fiqh muamalah dan fatwa ulama kontemporer.',
      'color': MuamalahColors.bitcoin,
      'isPremium': false,
      'pdfUrl': null,
    },
    {
      'title': 'أحكام النقود والعملات الرقمية',
      'titleOriginal': null,
      'titleId': 'Hukum Uang & Mata Uang Digital',
      'author': 'Dr. Ali Muhyiddin Al-Qaradaghi',
      'language': 'ARAB',
      'category': 'Crypto Syariah',
      'pages': 180,
      'description': 'Kajian fiqhiyah tentang mata uang digital dan implikasinya terhadap akad-akad muamalah.',
      'color': MuamalahColors.ethereum,
      'isPremium': false,
      'pdfUrl': null,
    },
    {
      'title': 'Ekonomi Islam: Teori & Praktik',
      'titleOriginal': null,
      'titleId': null,
      'author': 'Prof. M. Umer Chapra',
      'language': 'TERJEMAHAN',
      'category': 'Ekonomi Islam',
      'pages': 420,
      'description': 'Buku klasik tentang prinsip-prinsip ekonomi Islam dan penerapannya di era modern, termasuk sistem keuangan.',
      'color': const Color(0xFF6366F1),
      'isPremium': false,
      'pdfUrl': null,
    },
    {
      'title': 'Zakat Aset Digital & Crypto',
      'titleOriginal': null,
      'titleId': null,
      'author': 'Lembaga Amil Zakat Nasional',
      'language': 'INDONESIA',
      'category': 'Crypto Syariah',
      'pages': 120,
      'description': 'Panduan praktis menghitung dan menunaikan zakat atas kepemilikan aset digital dan cryptocurrency.',
      'color': MuamalahColors.halal,
      'isPremium': false,
      'pdfUrl': null,
    },
    {
      'title': 'الربا والمعاملات المصرفية',
      'titleOriginal': null,
      'titleId': 'Riba & Transaksi Perbankan',
      'author': 'Syekh Yusuf Al-Qaradawi',
      'language': 'ARAB',
      'category': 'Fiqh Muamalah',
      'pages': 350,
      'description': 'Pembahasan detail tentang riba dan alternatif transaksi perbankan yang sesuai syariah.',
      'color': MuamalahColors.haram,
      'isPremium': false,
      'pdfUrl': null,
    },
    {
      'title': 'Blockchain & Syariah Compliance',
      'titleOriginal': null,
      'titleId': null,
      'author': 'Dr. Farrukh Habib',
      'language': 'TERJEMAHAN',
      'category': 'Crypto Syariah',
      'pages': 200,
      'description': 'Eksplorasi teknologi blockchain dari sudut pandang kepatuhan syariah dan potensinya untuk industri halal.',
      'color': const Color(0xFF14B8A6),
      'isPremium': false,
      'pdfUrl': null,
    },
    {
      'title': 'Fiqh Trading Modern',
      'titleOriginal': null,
      'titleId': null,
      'author': 'Ustadz Dr. Oni Sahroni, MA',
      'language': 'INDONESIA',
      'category': 'Fiqh Muamalah',
      'pages': 250,
      'description': 'Panduan lengkap hukum trading saham, forex, dan cryptocurrency menurut perspektif fiqh kontemporer.',
      'color': const Color(0xFFEC4899),
      'isPremium': false,
      'pdfUrl': null,
    },
    {
      'title': 'قواعد الفقه المالي',
      'titleOriginal': null,
      'titleId': 'Kaidah Fiqh Keuangan',
      'author': 'Dr. Nazih Hammad',
      'language': 'ARAB',
      'category': 'Referensi Ulama',
      'pages': 280,
      'description': 'Kumpulan kaidah-kaidah fiqhiyah yang berkaitan dengan transaksi keuangan dan muamalah.',
      'color': MuamalahColors.proses,
      'isPremium': false,
      'pdfUrl': null,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 400), () {
      isLoading.value = false;
    });
  }

  List<Map<String, dynamic>> get filteredBooks {
    if (selectedCategory.value == 'Semua') return books;
    return books.where((b) => b['category'] == selectedCategory.value).toList();
  }
}

// ============================================================================
// PUSTAKA VIEW - E-LIBRARY CRYPTO SYARIAH
// ============================================================================

class PustakaView extends StatelessWidget {
  const PustakaView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PustakaController());

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF8B5CF6).withAlpha(25),
                      MuamalahColors.backgroundPrimary,
                    ],
                  ),
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(10),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.arrow_back_rounded, size: 20),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pustaka Crypto',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: MuamalahColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Referensi & Kitab Muamalah Digital',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: MuamalahColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Library Stats
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withAlpha(77),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Koleksi Pustaka',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${controller.books.length} kitab & buku referensi',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withAlpha(204),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.search_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Category Filter
              SizedBox(
                height: 44,
                child: Obx(() => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    final isSelected = controller.selectedCategory.value == category;
                    return GestureDetector(
                      onTap: () => controller.selectedCategory.value = category,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF8B5CF6) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: isSelected ? null : Border.all(color: MuamalahColors.glassBorder),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withAlpha(77),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ] : null,
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : MuamalahColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  },
                )),
              ),

              const SizedBox(height: 24),

              // Book Cards
              Obx(() => Column(
                children: controller.filteredBooks.map((book) => _buildBookCard(book)).toList(),
              )),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    final isArabic = book['language'] == 'ARAB';
    final isTranslation = book['language'] == 'TERJEMAHAN';

    Color badgeColor;
    String badgeText = book['language'];
    
    if (isArabic) {
      badgeColor = const Color(0xFF8B5CF6);
    } else if (isTranslation) {
      badgeColor = const Color(0xFF6366F1);
    } else {
      badgeColor = MuamalahColors.primaryEmerald;
    }

    return GestureDetector(
      onTap: () => Get.to(() => BookDetailView(book: book)),
      child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 20,
            spreadRadius: 5,
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
              // Book Cover Placeholder
              Container(
                width: 70,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (book['color'] as Color),
                      (book['color'] as Color).withAlpha(179),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: (book['color'] as Color).withAlpha(77),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${book['pages']}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'halaman',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white.withAlpha(204),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Language Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: badgeColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Arabic Title (if exists)
                    if (isArabic)
                      Text(
                        book['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: MuamalahColors.textPrimary,
                          fontFamily: 'Amiri', // Arabic font fallback
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    // Indonesian Title
                    if (book['titleId'] != null)
                      Padding(
                        padding: EdgeInsets.only(top: isArabic ? 6 : 0),
                        child: Text(
                          book['titleId'],
                          style: TextStyle(
                            fontSize: isArabic ? 13 : 16,
                            fontWeight: isArabic ? FontWeight.w500 : FontWeight.w600,
                            color: isArabic ? MuamalahColors.textSecondary : MuamalahColors.textPrimary,
                          ),
                        ),
                      ),
                    if (!isArabic && book['titleId'] == null)
                      Text(
                        book['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: MuamalahColors.textPrimary,
                        ),
                      ),
                    const SizedBox(height: 8),
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
                            book['author'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: MuamalahColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Description
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: MuamalahColors.neutralBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              book['description'],
              style: const TextStyle(
                fontSize: 12,
                color: MuamalahColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Category Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: MuamalahColors.mint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.bookmark_outline_rounded,
                      size: 14,
                      color: MuamalahColors.primaryEmerald,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      book['category'],
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: MuamalahColors.primaryEmerald,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: (book['color'] as Color).withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_stories_rounded,
                      size: 16,
                      color: book['color'] as Color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Baca',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: book['color'] as Color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}
