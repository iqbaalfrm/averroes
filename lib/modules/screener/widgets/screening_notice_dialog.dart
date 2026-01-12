import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../theme/app_theme.dart';

/// =============================================================================
/// SCREENING NOTICE DIALOG
/// =============================================================================
/// Popup metodologi screening yang muncul pertama kali di Screener
/// =============================================================================

class ScreeningNoticeDialog extends StatelessWidget {
  final VoidCallback onUnderstood;

  const ScreeningNoticeDialog({
    super.key,
    required this.onUnderstood,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    MuamalahColors.primaryEmerald,
                    MuamalahColors.emeraldLight,
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Metodologi Screening\nCrypto Syariah',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            // Content (Scrollable)
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Intro
                    const Text(
                      'Metode screening ini disusun dan ditelaah oleh:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: MuamalahColors.textPrimary,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Ustadz List
                    _buildBulletPoint('Ustadz Devin Halim Wijaya'),
                    _buildBulletPoint('Ustadz Fida Munadzir'),
                    _buildBulletPoint('Ustadz Ade Setiawan'),

                    const SizedBox(height: 20),

                    // Pendekatan
                    const Text(
                      'Dengan menggunakan pendekatan berikut:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: MuamalahColors.textPrimary,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Point 1
                    _buildNumberedSection(
                      '1',
                      'Mengacu pada kriteria Fatwa MUI:',
                      [
                        'Memiliki manfaat yang mubah',
                        'Dapat diserahterimakan',
                        'Memiliki proyek yang jelas',
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Point 2
                    _buildNumberedSection(
                      '2',
                      'Mengacu pada beberapa lembaga penilaian crypto internasional untuk memastikan status setiap koin/token.',
                      [],
                    ),

                    const SizedBox(height: 16),

                    // Point 3
                    _buildNumberedSection(
                      '3',
                      'Jika terdapat perbedaan pandangan:',
                      [
                        'Dilakukan tarjih berdasarkan data terkuat',
                        'Jika data belum rinci atau belum ada keputusan lembaga penilaian, maka status dikategorikan sebagai Proses (Kaji Ulang).',
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Disclaimer
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: MuamalahColors.prosesBg.withAlpha(100),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: MuamalahColors.proses.withAlpha(50),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 20,
                            color: MuamalahColors.proses,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Catatan:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: MuamalahColors.proses,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Status yang ditampilkan bersifat informatif dan bukan merupakan fatwa resmi.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: MuamalahColors.textSecondary,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // CTA Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    onUnderstood();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MuamalahColors.primaryEmerald,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Saya Mengerti',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: MuamalahColors.primaryEmerald,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: MuamalahColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedSection(
    String number,
    String title,
    List<String> subPoints,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: MuamalahColors.primaryEmerald.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: MuamalahColors.primaryEmerald,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: MuamalahColors.textPrimary,
                  height: 1.5,
                ),
              ),
              if (subPoints.isNotEmpty) ...[
                const SizedBox(height: 8),
                ...subPoints.map((point) => Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '- ',
                            style: TextStyle(
                              fontSize: 13,
                              color: MuamalahColors.textSecondary,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              point,
                              style: const TextStyle(
                                fontSize: 13,
                                color: MuamalahColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
