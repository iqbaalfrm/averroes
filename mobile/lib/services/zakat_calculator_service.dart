import 'gold_price_service.dart';
import 'currency_service.dart';

/// =============================================================================
/// ZAKAT CALCULATOR SERVICE
/// =============================================================================
/// 
/// Perhitungan Zakat Maal:
/// - Nisab = 85 gram emas
/// - Rate = 2.5% (1/40)
/// - Wajib jika: totalAset >= nisab DAN sudah haul (1 tahun)
/// 
/// Catatan: Haul tidak dicek otomatis, perlu konfirmasi user
/// =============================================================================

class ZakatCalculatorService {
  static const double nisabGram = 85.0;
  static const double zakatRate = 0.025; // 2.5%

  final GoldPriceService _goldPriceService;
  final CurrencyService _currencyService;

  ZakatCalculatorService({
    GoldPriceService? goldPriceService,
    CurrencyService? currencyService,
  })  : _goldPriceService = goldPriceService ?? GoldPriceService(),
        _currencyService = currencyService ?? CurrencyService();

  /// Hitung zakat dari total aset dalam USD
  Future<ZakatCalculation> calculate({
    required double totalAssetUsd,
  }) async {
    // 1. Ambil harga emas
    final goldPrice = await _goldPriceService.getGoldPriceIdr();
    
    // 2. Hitung nisab dalam IDR
    final nisabIdr = goldPrice.pricePerGramIdr * nisabGram;
    
    // 3. Konversi total aset ke IDR
    final usdToIdr = await _currencyService.getUsdToIdrRate();
    final totalAssetIdr = totalAssetUsd * usdToIdr;
    
    // 4. Cek eligibility
    final isEligible = totalAssetIdr >= nisabIdr;
    
    // 5. Hitung zakat
    final zakatDueIdr = isEligible ? totalAssetIdr * zakatRate : 0.0;
    
    print('📊 [Zakat] Total: Rp ${totalAssetIdr.toStringAsFixed(0)}');
    print('📊 [Zakat] Nisab: Rp ${nisabIdr.toStringAsFixed(0)}');
    print('📊 [Zakat] Eligible: $isEligible');
    print('📊 [Zakat] Due: Rp ${zakatDueIdr.toStringAsFixed(0)}');

    return ZakatCalculation(
      totalAssetIdr: totalAssetIdr,
      totalAssetUsd: totalAssetUsd,
      nisabIdr: nisabIdr,
      nisabGram: nisabGram,
      goldPricePerGram: goldPrice.pricePerGramIdr,
      goldPriceSource: goldPrice.source,
      isEligible: isEligible,
      zakatDueIdr: zakatDueIdr,
      zakatRate: zakatRate,
      usdToIdrRate: usdToIdr,
      calculatedAt: DateTime.now(),
    );
  }

  void dispose() {
    // Services disposal handled by caller
  }
}

// =============================================================================
// DATA MODEL
// =============================================================================

class ZakatCalculation {
  final double totalAssetIdr;
  final double totalAssetUsd;
  final double nisabIdr;
  final double nisabGram;
  final double goldPricePerGram;
  final String goldPriceSource;
  final bool isEligible;
  final double zakatDueIdr;
  final double zakatRate;
  final double usdToIdrRate;
  final DateTime calculatedAt;

  const ZakatCalculation({
    required this.totalAssetIdr,
    required this.totalAssetUsd,
    required this.nisabIdr,
    required this.nisabGram,
    required this.goldPricePerGram,
    required this.goldPriceSource,
    required this.isEligible,
    required this.zakatDueIdr,
    required this.zakatRate,
    required this.usdToIdrRate,
    required this.calculatedAt,
  });

  factory ZakatCalculation.empty() {
    return ZakatCalculation(
      totalAssetIdr: 0,
      totalAssetUsd: 0,
      nisabIdr: 0,
      nisabGram: 85,
      goldPricePerGram: 0,
      goldPriceSource: '-',
      isEligible: false,
      zakatDueIdr: 0,
      zakatRate: 0.025,
      usdToIdrRate: 0,
      calculatedAt: DateTime.now(),
    );
  }

  String get totalAssetIdrFormatted => _formatRupiah(totalAssetIdr);
  String get nisabIdrFormatted => _formatRupiah(nisabIdr);
  String get zakatDueIdrFormatted => _formatRupiah(zakatDueIdr);
  String get goldPriceFormatted => _formatRupiah(goldPricePerGram);

  String get statusText => isEligible ? 'Wajib Zakat' : 'Belum Wajib';
  String get statusDescription {
    if (isEligible) {
      return 'Aset Anda telah mencapai nisab. Pastikan sudah genap 1 tahun (haul).';
    } else {
      final remaining = nisabIdr - totalAssetIdr;
      return 'Kurang ${_formatRupiah(remaining)} untuk mencapai nisab.';
    }
  }

  String _formatRupiah(double value) {
    if (value >= 1000000000) {
      return 'Rp ${(value / 1000000000).toStringAsFixed(2)} M';
    } else if (value >= 1000000) {
      return 'Rp ${(value / 1000000).toStringAsFixed(2)} jt';
    } else if (value >= 1000) {
      final formatted = value.toStringAsFixed(0);
      return 'Rp ${formatted.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';
    }
    return 'Rp ${value.toStringAsFixed(0)}';
  }
}
