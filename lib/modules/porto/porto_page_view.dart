import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';

// ============================================================================
// PORTO PAGE CONTROLLER
// ============================================================================

class PortoPageController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool hasAssets = true.obs;

  final List<Map<String, dynamic>> cryptoAssets = [
    {
      'code': 'BTC',
      'name': 'Bitcoin',
      'amount': '0.0125',
      'valueIDR': 8500000.0,
      'price': '\$43,250',
      'change': '+3.24%',
      'status': 'Proses',
      'color': MuamalahColors.bitcoin,
    },
    {
      'code': 'ETH',
      'name': 'Ethereum',
      'amount': '0.85',
      'valueIDR': 5025000.0,
      'price': '\$2,380',
      'change': '+5.18%',
      'status': 'Halal',
      'color': MuamalahColors.ethereum,
    },
    {
      'code': 'BNB',
      'name': 'Binance Coin',
      'amount': '2.5',
      'valueIDR': 2375000.0,
      'price': '\$315',
      'change': '-1.23%',
      'status': 'Halal',
      'color': MuamalahColors.binance,
    },
    {
      'code': 'SOL',
      'name': 'Solana',
      'amount': '5.0',
      'valueIDR': 1950000.0,
      'price': '\$98.50',
      'change': '+8.72%',
      'status': 'Risiko Tinggi',
      'color': const Color(0xFF9945FF),
    },
    {
      'code': 'MATIC',
      'name': 'Polygon',
      'amount': '150',
      'valueIDR': 1275000.0,
      'price': '\$0.85',
      'change': '+2.45%',
      'status': 'Halal',
      'color': const Color(0xFF8247E5),
    },
  ];

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 400), () {
      isLoading.value = false;
    });
  }

  double get totalValue => cryptoAssets.fold(0.0, (sum, a) => sum + (a['valueIDR'] as double));
  
  int get halalCount => cryptoAssets.where((a) => a['status'] == 'Halal').length;
  // Was Syubhat
  int get prosesCount => cryptoAssets.where((a) => a['status'] == 'Proses').length;
  int get risikoCount => cryptoAssets.where((a) => a['status'] == 'Risiko Tinggi').length;

  String formatCurrency(double value) {
    return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
}

// ============================================================================
// PORTO PAGE VIEW (STANDALONE)
// ============================================================================

class PortoPageView extends StatelessWidget {
  const PortoPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PortoPageController());

    return Container( // Changed from Scaffold to Container
      color: MuamalahColors.backgroundPrimary,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: MuamalahColors.primaryEmerald,
            ),
          );
        }

        if (!controller.hasAssets.value) {
          return _buildEmptyState();
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
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
                            'Portofolio Crypto',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: MuamalahColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
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
                          child: const Icon(Icons.add_rounded, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Total Value Card
              _buildTotalValueCard(controller),

              const SizedBox(height: 24),

              // Status Distribution
              _buildStatusDistribution(controller),

              const SizedBox(height: 24),

              // Assets Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Aset Crypto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: MuamalahColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: MuamalahColors.glassBorder),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Nilai',
                            style: TextStyle(
                              fontSize: 12,
                              color: MuamalahColors.textSecondary,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: MuamalahColors.textSecondary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Asset Cards
              ...controller.cryptoAssets.map((asset) => _buildAssetCard(asset, controller)),

              const SizedBox(height: 24),

              // Zakat Summary
              _buildZakatSummary(controller),

              const SizedBox(height: 24),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [MuamalahColors.primaryEmerald, MuamalahColors.emeraldLight],
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
                            Icon(Icons.add_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Beli Crypto',
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
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: MuamalahColors.glassBorder),
                      ),
                      child: const Icon(Icons.sync_alt_rounded, color: MuamalahColors.textSecondary),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: MuamalahColors.glassBorder),
                      ),
                      child: const Icon(Icons.history_rounded, color: MuamalahColors.textSecondary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: MuamalahColors.mint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                size: 64,
                color: MuamalahColors.primaryEmerald,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Belum Ada Aset Crypto',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: MuamalahColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Mulai perjalanan investasi crypto halalmu sekarang! Setiap langkah kecil adalah awal dari keberkahan besar. 🌱',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: MuamalahColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [MuamalahColors.primaryEmerald, MuamalahColors.emeraldLight],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Center(
                child: Text(
                  'Mulai Investasi Crypto',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalValueCard(PortoPageController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [MuamalahColors.primaryEmerald, MuamalahColors.emeraldLight],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: MuamalahColors.primaryEmerald.withAlpha(77),
            blurRadius: 24,
            spreadRadius: 8,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Nilai Portofolio',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(204),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '+4.82%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            controller.formatCurrency(controller.totalValue),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '≈ 0.223 BTC',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withAlpha(179),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(31),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPortfolioStat('${controller.cryptoAssets.length}', 'Aset'),
                Container(width: 1, height: 30, color: Colors.white.withAlpha(51)),
                _buildPortfolioStat('+Rp 892K', 'Hari Ini'),
                Container(width: 1, height: 30, color: Colors.white.withAlpha(51)),
                _buildPortfolioStat('+12.5%', 'Bulan Ini'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withAlpha(179),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDistribution(PortoPageController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatusCard(
              label: 'Halal',
              count: controller.halalCount,
              icon: Icons.verified_rounded,
              color: MuamalahColors.halal,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatusCard(
              label: 'Proses',
              count: controller.prosesCount,
              icon: Icons.help_outline_rounded,
              color: MuamalahColors.proses,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildStatusCard(
              label: 'Risiko',
              count: controller.risikoCount,
              icon: Icons.warning_amber_rounded,
              color: MuamalahColors.risikoTinggi,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required String label,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 16,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withAlpha(31),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: MuamalahColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetCard(Map<String, dynamic> asset, PortoPageController controller) {
    Color statusColor;
    Color statusBgColor;

    switch (asset['status']) {
      case 'Halal':
        statusColor = MuamalahColors.halal;
        statusBgColor = MuamalahColors.halalBg;
        break;
      case 'Risiko Tinggi':
        statusColor = MuamalahColors.risikoTinggi;
        statusBgColor = MuamalahColors.risikoTinggiBg;
        break;
      default:
        statusColor = MuamalahColors.proses;
        statusBgColor = MuamalahColors.prosesBg;
    }

    final isPositive = (asset['change'] as String).startsWith('+');
    final percentage = (asset['valueIDR'] as double) / controller.totalValue * 100;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 16,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: (asset['color'] as Color).withAlpha(31),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    asset['code'],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: asset['color'] as Color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          asset['code'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: MuamalahColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            asset['status'],
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${asset['name']} • ${asset['amount']} ${asset['code']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: MuamalahColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    controller.formatCurrency(asset['valueIDR'] as double),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: MuamalahColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                        size: 14,
                        color: isPositive ? MuamalahColors.halal : MuamalahColors.haram,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        asset['change'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isPositive ? MuamalahColors.halal : MuamalahColors.haram,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    minHeight: 4,
                    backgroundColor: MuamalahColors.neutralBg,
                    valueColor: AlwaysStoppedAnimation<Color>(asset['color'] as Color),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: MuamalahColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZakatSummary(PortoPageController controller) {
    final zakatAmount = controller.totalValue * 0.025;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withAlpha(15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6366F1).withAlpha(51)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withAlpha(31),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.volunteer_activism_rounded,
              color: Color(0xFF6366F1),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Estimasi Zakat Crypto',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: MuamalahColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.formatCurrency(zakatAmount),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '2.5% dari total aset',
                  style: TextStyle(
                    fontSize: 11,
                    color: MuamalahColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Bayar',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
