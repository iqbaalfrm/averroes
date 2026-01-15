import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';

/// =============================================================================
/// DISCLAIMER PAGE - Keuangan & Syariah
/// =============================================================================

class DisclaimerPage extends StatelessWidget {
  const DisclaimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: MuamalahColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Disclaimer',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: MuamalahColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Important Notice Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    MuamalahColors.proses.withAlpha(25),
                    MuamalahColors.proses.withAlpha(10),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: MuamalahColors.proses.withAlpha(51)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: MuamalahColors.proses,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'PENTING: BACA DENGAN SEKSAMA',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: MuamalahColors.proses,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Aplikasi ini bersifat edukatif dan informatif. '
                    'Bukan merupakan nasihat keuangan, investasi, atau fatwa syariah.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: MuamalahColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Disclaimer Keuangan
            _buildDisclaimerCard(
              icon: Icons.account_balance_wallet_rounded,
              iconColor: MuamalahColors.bitcoin,
              title: 'Disclaimer Keuangan',
              points: [
                'Informasi dalam aplikasi ini BUKAN merupakan nasihat keuangan atau investasi.',
                'Cryptocurrency adalah aset yang sangat volatile dan berisiko tinggi.',
                'Anda dapat kehilangan sebagian atau seluruh investasi Anda.',
                'Selalu lakukan riset independen (DYOR) sebelum berinvestasi.',
                'Kami tidak bertanggung jawab atas kerugian finansial yang timbul.',
                'Konsultasikan dengan penasihat keuangan profesional sebelum mengambil keputusan.',
              ],
            ),

            const SizedBox(height: 16),

            // Disclaimer Syariah
            _buildDisclaimerCard(
              icon: Icons.mosque_rounded,
              iconColor: MuamalahColors.halal,
              title: 'Disclaimer Syariah',
              points: [
                'Status halal/haram aset crypto dalam aplikasi ini berdasarkan kajian ilmiah yang bersifat ijtihadi.',
                'Terdapat perbedaan pendapat di kalangan ulama mengenai hukum cryptocurrency.',
                'Perhitungan zakat bersifat ESTIMASI dan bukan fatwa resmi.',
                'Pastikan haul (kepemilikan 1 tahun) terpenuhi sebelum mengeluarkan zakat.',
                'Konsultasikan dengan ulama atau lembaga fatwa terpercaya untuk keputusan syariah.',
                'Kami tidak bertanggung jawab atas keputusan fiqh yang diambil berdasarkan aplikasi ini.',
              ],
            ),

            const SizedBox(height: 16),

            // Disclaimer Teknis
            _buildDisclaimerCard(
              icon: Icons.code_rounded,
              iconColor: const Color(0xFF6366F1),
              title: 'Disclaimer Teknis',
              points: [
                'Data harga dan portofolio diambil dari pihak ketiga dan mungkin tidak akurat 100%.',
                'Aplikasi tidak menyimpan private key atau memiliki akses ke dana Anda.',
                'Koneksi wallet bersifat read-only untuk melihat saldo saja.',
                'Aplikasi ini TIDAK DAPAT melakukan transaksi atau transfer aset.',
                'Kami tidak bertanggung jawab atas ketidakakuratan data dari API pihak ketiga.',
              ],
            ),

            const SizedBox(height: 24),

            // Acknowledgment
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
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: MuamalahColors.halal,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Persetujuan Pengguna',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: MuamalahColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Dengan menggunakan aplikasi Averroes, Anda menyatakan telah membaca, '
                    'memahami, dan menyetujui semua disclaimer di atas.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: MuamalahColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [MuamalahColors.primaryEmerald, MuamalahColors.emeraldLight],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Saya Mengerti',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
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

  Widget _buildDisclaimerCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<String> points,
  }) {
    return Container(
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: MuamalahColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...points.map((point) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
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
      ),
    );
  }
}
