import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';

// ============================================================================
// FATWA CONTROLLER
// ============================================================================

class FatwaController extends GetxController {
  final RxBool isLoading = true.obs;

  final List<Map<String, dynamic>> fatwaList = [
    {
      'title': 'Hukum Jual Beli Cryptocurrency',
      'source': 'DSN MUI (Simulasi)',
      'date': '12 Januari 2024',
      'status': 'Mubah dengan Syarat',
      'summary': 'Cryptocurrency diperbolehkan untuk diperjualbelikan dengan syarat memenuhi kriteria sebagai komoditas digital yang memiliki nilai ekonomis dan manfaat yang jelas.',
      'points': [
        'Bukan untuk spekulasi semata',
        'Ada underlying value atau utility',
        'Tidak mengandung unsur riba',
        'Tidak digunakan untuk aktivitas haram',
      ],
      'category': 'Proses',
    },
    {
      'title': 'Zakat Aset Cryptocurrency',
      'source': 'DSN MUI (Simulasi)',
      'date': '5 Februari 2024',
      'status': 'Wajib',
      'summary': 'Cryptocurrency yang telah mencapai nisab dan haul wajib dikeluarkan zakatnya sebesar 2.5% dari total nilai aset pada saat jatuh tempo.',
      'points': [
        'Nisab setara 85 gram emas',
        'Haul 1 tahun hijriyah',
        'Kadar zakat 2.5%',
        'Dihitung berdasarkan nilai pasar saat haul',
      ],
      'category': 'Halal',
    },
    {
      'title': 'Staking dan Yield Farming',
      'source': 'Lajnah Bahtsul Masail (Simulasi)',
      'date': '20 Maret 2024',
      'status': 'Perlu Kajian Lebih Lanjut',
      'summary': 'Mekanisme staking dan yield farming memerlukan kajian mendalam karena berpotensi mengandung unsur gharar dan riba tergantung pada skema yang digunakan.',
      'points': [
        'Proof of Stake murni cenderung dibolehkan',
        'Yield farming dengan bunga tidak dibolehkan',
        'Perlu kejelasan akad dan mekanisme',
        'Hindari platform dengan praktik riba',
      ],
      'category': 'Proses',
    },
    {
      'title': 'NFT dan Seni Digital',
      'source': 'Komisi Fatwa MUI (Simulasi)',
      'date': '8 April 2024',
      'status': 'Mubah dengan Syarat',
      'summary': 'NFT diperbolehkan selama konten yang diperjualbelikan tidak mengandung unsur yang diharamkan dalam syariat Islam.',
      'points': [
        'Konten tidak bertentangan dengan syariat',
        'Bukan untuk spekulasi berlebihan',
        'Ada kejelasan kepemilikan digital',
        'Tidak mengandung unsur perjudian',
      ],
      'category': 'Halal',
    },
    {
      'title': 'Mining Bitcoin dan Cryptocurrency',
      'source': 'Majelis Ulama (Simulasi)',
      'date': '15 Mei 2024',
      'status': 'Mubah',
      'summary': 'Aktivitas mining cryptocurrency diperbolehkan karena merupakan bentuk jasa pemrosesan transaksi dengan imbalan yang jelas.',
      'points': [
        'Termasuk kategori ijarah (jasa)',
        'Imbalan dari jaringan blockchain',
        'Tidak mengandung unsur riba',
        'Perhatikan aspek lingkungan',
      ],
      'category': 'Halal',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 400), () {
      isLoading.value = false;
    });
  }
}

// ============================================================================
// FATWA VIEW
// ============================================================================

class FatwaView extends StatelessWidget {
  const FatwaView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FatwaController());

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
                      MuamalahColors.primaryEmerald.withAlpha(31),
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
                          child: Text(
                            'Fatwa Crypto Syariah',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: MuamalahColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Kumpulan fatwa dan panduan syariah tentang cryptocurrency',
                      style: TextStyle(
                        fontSize: 14,
                        color: MuamalahColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Disclaimer
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MuamalahColors.prosesBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: MuamalahColors.proses.withAlpha(77)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: MuamalahColors.proses.withAlpha(51),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: MuamalahColors.proses,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Konten ini adalah simulasi untuk tujuan edukasi. Silakan konsultasi dengan ulama untuk keputusan syariah.',
                        style: TextStyle(
                          fontSize: 11,
                          color: MuamalahColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Fatwa Cards
              ...controller.fatwaList.map((fatwa) => _buildFatwaCard(fatwa)),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFatwaCard(Map<String, dynamic> fatwa) {
    Color categoryColor;
    Color categoryBgColor;

    switch (fatwa['category']) {
      case 'Halal':
        categoryColor = MuamalahColors.halal;
        categoryBgColor = MuamalahColors.halalBg;
        break;
      default:
        categoryColor = MuamalahColors.proses;
        categoryBgColor = MuamalahColors.prosesBg;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fatwa['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: MuamalahColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          size: 14,
                          color: MuamalahColors.primaryEmerald,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          fatwa['source'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: MuamalahColors.primaryEmerald,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: categoryBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  fatwa['category'],
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: categoryColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: MuamalahColors.mint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.gavel_rounded,
                  size: 16,
                  color: MuamalahColors.primaryEmerald,
                ),
                const SizedBox(width: 8),
                Text(
                  'Status: ${fatwa['status']}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: MuamalahColors.primaryEmerald,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Summary
          Text(
            fatwa['summary'],
            style: const TextStyle(
              fontSize: 13,
              color: MuamalahColors.textSecondary,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 16),

          // Key Points
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: MuamalahColors.neutralBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Poin Penting:',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: MuamalahColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                ...List.generate(
                  (fatwa['points'] as List).length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: categoryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            fatwa['points'][i],
                            style: const TextStyle(
                              fontSize: 12,
                              color: MuamalahColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Date
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                size: 14,
                color: MuamalahColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                fatwa['date'],
                style: const TextStyle(
                  fontSize: 11,
                  color: MuamalahColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
