import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../config/env_config.dart';

/// =============================================================================
/// PRIVACY POLICY PAGE - Play Store Compliance
/// =============================================================================

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          'Kebijakan Privasi',
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
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    MuamalahColors.primaryEmerald.withAlpha(25),
                    MuamalahColors.primaryEmerald.withAlpha(10),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: MuamalahColors.primaryEmerald.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.privacy_tip_rounded,
                      color: MuamalahColors.primaryEmerald,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AVERROES',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MuamalahColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Terakhir diperbarui: Januari 2026',
                          style: TextStyle(
                            fontSize: 12,
                            color: MuamalahColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSection(
              'Pendahuluan',
              'Averroes ("kami", "kita", atau "Aplikasi") berkomitmen untuk melindungi privasi pengguna. '
              'Kebijakan Privasi ini menjelaskan bagaimana kami mengumpulkan, menggunakan, dan melindungi informasi Anda.',
            ),

            _buildSection(
              'Data yang Kami Kumpulkan',
              '• **Alamat Wallet (Public Address)**: Alamat wallet blockchain Anda yang bersifat publik (0x...). '
              'Ini digunakan untuk menampilkan saldo dan portofolio Anda.\n\n'
              '• **Data Agregat**: Statistik penggunaan anonim untuk meningkatkan aplikasi.\n\n'
              '• **Preferensi Lokal**: Pengaturan aplikasi yang disimpan di perangkat Anda.',
            ),

            _buildSection(
              'Data yang TIDAK Kami Kumpulkan',
              '• ❌ Private Key / Seed Phrase\n'
              '• ❌ Password atau PIN\n'
              '• ❌ Data biometrik\n'
              '• ❌ Informasi pribadi (nama, email, telepon)\n'
              '• ❌ Lokasi GPS',
            ),

            _buildSection(
              'Penggunaan Data',
              'Data alamat wallet Anda digunakan untuk:\n\n'
              '• Menampilkan saldo token dari berbagai blockchain\n'
              '• Menghitung estimasi zakat berdasarkan aset crypto\n'
              '• Menyediakan informasi harga pasar',
            ),

            _buildSection(
              'Layanan Pihak Ketiga',
              'Kami menggunakan layanan pihak ketiga berikut:\n\n'
              '• **Covalent API**: Untuk mengambil data portofolio blockchain\n'
              '• **CoinGecko API**: Untuk data harga cryptocurrency\n'
              '• **Exchange Rate API**: Untuk konversi mata uang\n'
              '• **WalletConnect**: Untuk koneksi wallet (opsional)\n\n'
              'Setiap layanan memiliki kebijakan privasi tersendiri.',
            ),

            _buildSection(
              'Keamanan Data',
              '• Data disimpan secara lokal di perangkat Anda\n'
              '• Tidak ada data sensitif yang dikirim ke server kami\n'
              '• Komunikasi API menggunakan HTTPS terenkripsi\n'
              '• Kami tidak memiliki akses ke wallet Anda',
            ),

            _buildSection(
              'Hak Anda',
              '• Anda dapat menghapus data lokal kapan saja\n'
              '• Anda dapat logout dan menghapus alamat wallet tersimpan\n'
              '• Anda dapat menggunakan aplikasi dalam mode Tamu',
            ),

            _buildSection(
              'Perubahan Kebijakan',
              'Kami dapat memperbarui Kebijakan Privasi ini. '
              'Perubahan signifikan akan diberitahukan melalui aplikasi.',
            ),

            _buildSection(
              'Hubungi Kami',
              'Jika ada pertanyaan tentang Kebijakan Privasi ini:\n\n'
              '📧 ${EnvConfig.supportEmail}',
            ),

            const SizedBox(height: 32),

            // Disclaimer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MuamalahColors.prosesBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MuamalahColors.proses.withAlpha(51)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.gavel_rounded, size: 20, color: MuamalahColors.proses),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Dengan menggunakan Averroes, Anda menyetujui Kebijakan Privasi ini.',
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

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MuamalahColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: MuamalahColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
