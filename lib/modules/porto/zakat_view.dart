import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_theme.dart';
import '../../services/zakat_calculator_service.dart';

// ============================================================================
// ZAKAT VIEW - Kalkulator Zakat Crypto
// ============================================================================

class ZakatView extends StatefulWidget {
  final double totalAssetUsd;

  const ZakatView({super.key, required this.totalAssetUsd});

  @override
  State<ZakatView> createState() => _ZakatViewState();
}

class _ZakatViewState extends State<ZakatView> {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  ZakatCalculation _calculation = ZakatCalculation.empty();

  final ZakatCalculatorService _calculator = ZakatCalculatorService();

  @override
  void initState() {
    super.initState();
    _calculateZakat();
  }

  Future<void> _calculateZakat() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final result = await _calculator.calculate(
        totalAssetUsd: widget.totalAssetUsd,
      );
      setState(() {
        _calculation = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MuamalahColors.backgroundPrimary,
      body: _isLoading
          ? _buildLoading()
          : _hasError
              ? _buildError()
              : _buildContent(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: MuamalahColors.halal),
          SizedBox(height: 20),
          Text(
            'Menghitung Zakat...',
            style: TextStyle(
              fontSize: 14,
              color: MuamalahColors.textSecondary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Mengambil harga emas terkini',
            style: TextStyle(
              fontSize: 12,
              color: MuamalahColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
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
            const Text(
              'Gagal Menghitung',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MuamalahColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: MuamalahColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: _calculateZakat,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: MuamalahColors.halal,
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

  Widget _buildContent() {
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
                  MuamalahColors.halal.withAlpha(25),
                  MuamalahColors.backgroundPrimary,
                ],
              ),
            ),
            child: Row(
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
                        'Kalkulator Zakat',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: MuamalahColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Zakat Maal Aset Crypto',
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
          ),

          // Status Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _calculation.isEligible
                    ? [MuamalahColors.halal, const Color(0xFF059669)]
                    : [MuamalahColors.proses, const Color(0xFFD97706)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: (_calculation.isEligible
                          ? MuamalahColors.halal
                          : MuamalahColors.proses)
                      .withAlpha(77),
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
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(51),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        _calculation.isEligible
                            ? Icons.check_circle_rounded
                            : Icons.pending_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _calculation.statusText,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _calculation.statusDescription,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withAlpha(204),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (_calculation.isEligible) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Zakat yang Harus Dibayar',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withAlpha(204),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _calculation.zakatDueIdrFormatted,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '2.5% dari total aset',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withAlpha(179),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Details Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detail Perhitungan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MuamalahColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                // Total Assets
                _buildDetailCard(
                  icon: Icons.account_balance_wallet_rounded,
                  iconColor: MuamalahColors.primaryEmerald,
                  title: 'Total Aset Crypto',
                  value: _calculation.totalAssetIdrFormatted,
                  subtitle: '\$${_calculation.totalAssetUsd.toStringAsFixed(2)}',
                ),

                const SizedBox(height: 12),

                // Nisab
                _buildDetailCard(
                  icon: Icons.balance_rounded,
                  iconColor: MuamalahColors.bitcoin,
                  title: 'Nisab (85 gram emas)',
                  value: _calculation.nisabIdrFormatted,
                  subtitle: 'Harga emas: ${_calculation.goldPriceFormatted}',
                ),

                const SizedBox(height: 12),

                // Zakat Rate
                _buildDetailCard(
                  icon: Icons.percent_rounded,
                  iconColor: MuamalahColors.halal,
                  title: 'Tarif Zakat',
                  value: '2.5%',
                  subtitle: '1/40 dari total aset',
                ),

                const SizedBox(height: 12),

                // Exchange Rate
                _buildDetailCard(
                  icon: Icons.currency_exchange_rounded,
                  iconColor: const Color(0xFF6366F1),
                  title: 'Kurs USD/IDR',
                  value: 'Rp ${_calculation.usdToIdrRate.toStringAsFixed(0)}',
                  subtitle: 'Real-time exchange rate',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Disclaimer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MuamalahColors.prosesBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: MuamalahColors.proses.withAlpha(51),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: MuamalahColors.proses,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Catatan Penting',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: MuamalahColors.proses,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    '• Perhitungan ini bersifat estimasi untuk membantu Anda menghitung zakat.\n'
                    '• Pastikan aset sudah mencapai haul (kepemilikan 1 tahun).\n'
                    '• Untuk keputusan final, konsultasikan dengan ulama atau lembaga zakat terpercaya.\n'
                    '• Harga emas dan kurs dapat berubah sewaktu-waktu.',
                    style: TextStyle(
                      fontSize: 12,
                      color: MuamalahColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _calculateZakat,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: MuamalahColors.glassBorder),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.refresh_rounded,
                            color: MuamalahColors.textPrimary,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Hitung Ulang',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: MuamalahColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_calculation.isEligible) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.snackbar(
                          'Info',
                          'Fitur pembayaran zakat akan segera hadir',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: MuamalahColors.halal.withAlpha(230),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [MuamalahColors.halal, Color(0xFF059669)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: MuamalahColors.halal.withAlpha(77),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.volunteer_activism_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Bayar Zakat',
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
                ],
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: MuamalahColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: MuamalahColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10,
              color: MuamalahColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
