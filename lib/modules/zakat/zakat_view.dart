import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../services/zakat_service.dart';
import '../../services/gold_price_service.dart';
import '../../services/coingecko_service.dart';
import '../../services/app_session_controller.dart';
import '../auth/login_view.dart';
import '../porto/portfolio_controller.dart';
import '../../core/domain/entities/portfolio_holding_entity.dart';

/// =============================================================================
/// ZAKAT CONTROLLER (GetX)
/// =============================================================================
/// Controller untuk mengelola state perhitungan zakat
/// 
/// DISCLAIMER: Perhitungan ini bersifat ESTIMASI untuk edukasi.
/// =============================================================================

class ZakatController extends GetxController {
  late final ZakatService _zakatService;
  late final GoldPriceService _goldPriceService;

  // Observable state
  final Rxn<ZakatCalculation> calculation = Rxn<ZakatCalculation>();
  final Rxn<GoldPriceData> goldPrice = Rxn<GoldPriceData>();
  final RxBool isLoading = false.obs;
  final RxBool isGoldLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isDataStale = false.obs;

  // Getters
  bool get hasCalculation => calculation.value != null;
  bool get isWajib => calculation.value?.isWajib ?? false;
  bool get hasPortfolio => _hasPortfolio();

  @override
  void onInit() {
    super.onInit();
    _zakatService = ZakatService();
    _goldPriceService = GoldPriceService();
  }

  @override
  void onReady() {
    super.onReady();
    // Auto calculate when ready if portfolio exists
    if (hasPortfolio) {
      calculateZakat();
    }
  }

  bool _hasPortfolio() {
    try {
      final portfolioController = Get.find<PortfolioController>();
      return portfolioController.holdings.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // ===========================================================================
  // MAIN CALCULATION
  // ===========================================================================

  /// Hitung zakat berdasarkan portfolio saat ini
  Future<void> calculateZakat() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      isDataStale.value = false;

      // 1. Get portfolio data
      final portfolioController = Get.find<PortfolioController>();
      final holdings = portfolioController.holdings.toList();
      final prices = portfolioController.prices;

      if (holdings.isEmpty) {
        errorMessage.value = 'Portfolio kosong';
        calculation.value = null;
        return;
      }

      // 2. Refresh prices if needed
      if (prices.isEmpty) {
        await portfolioController.refreshPrices();
      }

      // 3. Get gold price
      isGoldLoading.value = true;
      final goldData = await _goldPriceService.getGoldPriceIdr();
      isGoldLoading.value = false;

      goldPrice.value = goldData;
      isDataStale.value = goldData.isEstimated;

      // 4. Convert CoinPrice map to correct format
      final pricesMap = <String, CoinPrice>{};
      for (final entry in portfolioController.prices.entries) {
        pricesMap[entry.key] = entry.value;
      }

      // 5. Calculate zakat
      final result = _zakatService.calculate(
        holdings: holdings.map<PortfolioHoldingEntity>((e) => e.toEntity()).toList(),
        prices: pricesMap,
        goldPricePerGramIdr: goldData.pricePerGramIdr,
      );

      calculation.value = result;
      print('✅ [Zakat] Calculated: ${result.statusText}');
    } catch (e) {
      errorMessage.value = 'Gagal menghitung zakat: $e';
      print('❌ [Zakat] Error: $e');
    } finally {
      isLoading.value = false;
      isGoldLoading.value = false;
    }
  }

  /// Refresh calculation
  Future<void> refresh() async {
    // First refresh portfolio prices
    try {
      final portfolioController = Get.find<PortfolioController>();
      await portfolioController.refreshPrices();
    } catch (e) {
      print('⚠️ [Zakat] Could not refresh portfolio: $e');
    }

    // Then recalculate zakat
    await calculateZakat();
  }

  /// Clear calculation
  void clearCalculation() {
    calculation.value = null;
    goldPrice.value = null;
    errorMessage.value = '';
  }
}

/// =============================================================================
/// ZAKAT VIEW
/// =============================================================================
/// Halaman perhitungan estimasi zakat aset digital
/// 
/// DISCLAIMER: Fitur ini HANYA untuk ESTIMASI dan EDUKASI.
/// Tidak untuk transaksi atau pembayaran zakat.
/// =============================================================================

class ZakatView extends StatelessWidget {
  const ZakatView({super.key});

  @override
  Widget build(BuildContext context) {
    // Check auth
    final sessionController = Get.find<AppSessionController>();
    if (sessionController.isGuest.value) {
      return _buildAuthGate();
    }

    // Initialize controllers
    Get.put(PortfolioController());
    final controller = Get.put(ZakatController());

    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: MuamalahColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Kalkulator Zakat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MuamalahColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: MuamalahColors.textMuted),
            onPressed: () => controller.refresh(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoading();
        }

        if (!controller.hasPortfolio) {
          return _buildEmptyPortfolio();
        }

        if (controller.errorMessage.isNotEmpty && !controller.hasCalculation) {
          return _buildError(controller);
        }

        return _buildContent(controller);
      }),
    );
  }

  Widget _buildAuthGate() {
    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: MuamalahColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: MuamalahColors.prosesBg,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 48,
                  color: MuamalahColors.proses,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Login Diperlukan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MuamalahColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Silakan login untuk menghitung estimasi zakat aset kripto Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: MuamalahColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => Get.offAll(() => const LoginView()),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [MuamalahColors.primaryEmerald, MuamalahColors.emeraldLight],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Masuk Sekarang',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: MuamalahColors.primaryEmerald),
          SizedBox(height: 20),
          Text(
            'Menghitung estimasi zakat...',
            style: TextStyle(
              fontSize: 14,
              color: MuamalahColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPortfolio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: MuamalahColors.mint,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                size: 48,
                color: MuamalahColors.primaryEmerald,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Portfolio Kosong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: MuamalahColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tambahkan aset kripto ke portfolio Anda terlebih dahulu untuk menghitung estimasi zakat.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: MuamalahColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [MuamalahColors.primaryEmerald, MuamalahColors.emeraldLight],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Ke Portfolio',
                  style: TextStyle(
                    fontSize: 15,
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

  Widget _buildError(ZakatController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: MuamalahColors.haramBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: MuamalahColors.haram,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: MuamalahColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: controller.refresh,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: MuamalahColors.primaryEmerald,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(
                    fontSize: 14,
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

  Widget _buildContent(ZakatController controller) {
    final calc = controller.calculation.value;
    if (calc == null) {
      return _buildLoading();
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      color: MuamalahColors.primaryEmerald,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stale data warning
            if (controller.isDataStale.value) _buildStaleWarning(),

            // Missing prices warning
            if (calc.hasMissingPrices) _buildMissingPricesWarning(calc),

            // Summary Card
            _buildSummaryCard(calc),

            const SizedBox(height: 20),

            // Zakat Result Card
            _buildZakatResultCard(calc),

            const SizedBox(height: 20),

            // Breakdown Card
            _buildBreakdownCard(calc),

            const SizedBox(height: 20),

            // Fiqh Disclaimer
            _buildFiqhDisclaimer(),

            const SizedBox(height: 20),

            // Education CTA
            _buildEducationCta(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStaleWarning() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MuamalahColors.prosesBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MuamalahColors.proses.withAlpha(50)),
      ),
      child: const Row(
        children: [
          Icon(Icons.access_time_rounded, size: 18, color: MuamalahColors.proses),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Data terakhir • perhitungan estimasi',
              style: TextStyle(fontSize: 12, color: MuamalahColors.proses),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissingPricesWarning(ZakatCalculation calc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MuamalahColors.prosesBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, size: 18, color: MuamalahColors.proses),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${calc.assetsWithoutPrice} aset tidak memiliki harga dan tidak dihitung',
              style: const TextStyle(fontSize: 12, color: MuamalahColors.proses),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(ZakatCalculation calc) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: calc.isWajib
              ? [MuamalahColors.primaryEmerald, MuamalahColors.emeraldLight]
              : [MuamalahColors.textMuted, MuamalahColors.textSecondary],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (calc.isWajib ? MuamalahColors.primaryEmerald : MuamalahColors.textMuted)
                .withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 8),
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
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  calc.isWajib ? Icons.verified_rounded : Icons.schedule_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const Spacer(),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  calc.statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: calc.isWajib ? MuamalahColors.primaryEmerald : MuamalahColors.textMuted,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            'Total Aset Anda',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            calc.totalAssetFormatted,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),

          // Nishab comparison
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nishab (85 gr emas)',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      calc.nishabFormatted,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Selisih',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      calc.selisihFormatted,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: calc.isWajib ? Colors.greenAccent : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildZakatResultCard(ZakatCalculation calc) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: calc.isWajib ? MuamalahColors.halalBg : MuamalahColors.neutralBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.calculate_rounded,
              size: 32,
              color: calc.isWajib ? MuamalahColors.halal : MuamalahColors.textMuted,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Estimasi Zakat Anda',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: MuamalahColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            calc.isWajib ? calc.zakatAmountFormatted : 'Rp 0',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: calc.isWajib ? MuamalahColors.primaryEmerald : MuamalahColors.textMuted,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            calc.isWajib
                ? '${calc.zakatRateFormatted} dari total aset'
                : 'Aset belum mencapai nishab',
            style: const TextStyle(
              fontSize: 13,
              color: MuamalahColors.textSecondary,
            ),
          ),

          if (!calc.isWajib) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MuamalahColors.mint,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Aset Anda saat ini ${calc.percentageOfNishab.toStringAsFixed(1)}% dari nishab',
                style: const TextStyle(
                  fontSize: 12,
                  color: MuamalahColors.primaryEmerald,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBreakdownCard(ZakatCalculation calc) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(top: 16),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: MuamalahColors.mint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: MuamalahColors.primaryEmerald,
              size: 20,
            ),
          ),
          title: const Text(
            'Rincian Perhitungan',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: MuamalahColors.textPrimary,
            ),
          ),
          subtitle: const Text(
            'Lihat detail perhitungan zakat',
            style: TextStyle(
              fontSize: 12,
              color: MuamalahColors.textMuted,
            ),
          ),
          children: [
            _buildBreakdownRow('Total Aset', calc.totalAssetFormatted),
            _buildBreakdownRow('Harga Emas/gram', calc.goldPriceFormatted),
            _buildBreakdownRow('Nishab (85 gram)', calc.nishabFormatted),
            _buildBreakdownRow('Status', calc.statusText, highlight: true),
            if (calc.isWajib) ...[
              const Divider(height: 24),
              _buildBreakdownRow('Tarif Zakat', calc.zakatRateFormatted),
              _buildBreakdownRow('Estimasi Zakat', calc.zakatAmountFormatted, highlight: true),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MuamalahColors.neutralBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Formula: Zakat = Total Aset × 2.5%\n(jika Total Aset ≥ Nishab)',
                style: TextStyle(
                  fontSize: 11,
                  color: MuamalahColors.textMuted,
                  fontFamily: 'monospace',
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: MuamalahColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
              color: highlight ? MuamalahColors.primaryEmerald : MuamalahColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiqhDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: MuamalahColors.prosesBg.withAlpha(128),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MuamalahColors.proses.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MuamalahColors.proses.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: MuamalahColors.proses,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Catatan Penting',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: MuamalahColors.proses,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Perhitungan ini bersifat ESTIMASI untuk tujuan edukasi dan kesadaran. '
            'Untuk penunaian zakat yang sah, dianjurkan berkonsultasi dengan amil atau lembaga zakat resmi seperti BAZNAS, LAZ, atau ulama yang kompeten.',
            style: TextStyle(
              fontSize: 13,
              color: MuamalahColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Aplikasi ini TIDAK menghitung haul (kepemilikan 1 tahun). Pastikan aset telah dimiliki selama 1 tahun hijriyah sebelum menunaikan zakat.',
            style: TextStyle(
              fontSize: 12,
              color: MuamalahColors.textMuted,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCta() {
    return GestureDetector(
      onTap: () {
        Get.snackbar(
          'Segera Hadir',
          'Konten edukasi zakat aset digital akan segera tersedia',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: MuamalahColors.primaryEmerald,
          colorText: Colors.white,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pelajari Zakat Aset Digital',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Dalil, syarat, dan panduan lengkap',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
