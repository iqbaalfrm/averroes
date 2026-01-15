import '../services/coingecko_service.dart';
import '../core/domain/entities/portfolio_holding_entity.dart';

/// =============================================================================
/// ZAKAT SERVICE
/// =============================================================================
/// Service untuk menghitung estimasi zakat aset digital
/// 
/// DISCLAIMER: Perhitungan ini bersifat ESTIMASI untuk edukasi.
/// Tidak untuk transaksi atau pembayaran zakat.
/// =============================================================================

class ZakatService {
  // Singleton
  static final ZakatService _instance = ZakatService._internal();
  factory ZakatService() => _instance;
  ZakatService._internal();

  // ===========================================================================
  // CONSTANTS - Sesuai Fiqh Zakat Mal
  // ===========================================================================

  /// Nishab zakat = 85 gram emas murni
  static const double nishabGramEmas = 85.0;

  /// Tarif zakat mal = 2.5%
  static const double zakatRate = 0.025;

  /// Haul = 1 tahun hijriyah (tidak diimplementasikan di MVP)
  static const int haulDays = 354;

  // ===========================================================================
  // CALCULATION
  // ===========================================================================

  /// Hitung estimasi zakat berdasarkan portfolio dan harga
  /// 
  /// [holdings] - List kepemilikan aset dari Supabase
  /// [prices] - Map harga live dari CoinGecko
  /// [goldPricePerGramIdr] - Harga emas per gram dalam IDR
  ZakatCalculation calculate({
    required List<PortfolioHoldingEntity> holdings,
    required Map<String, CoinPrice> prices,
    required double goldPricePerGramIdr,
  }) {
    // 1. Hitung total nilai aset
    double totalAssetIdr = 0;
    int assetsWithPrice = 0;
    int assetsWithoutPrice = 0;
    final assetBreakdown = <AssetZakatBreakdown>[];

    for (final holding in holdings) {
      final price = prices[holding.symbol.toUpperCase()];
      
      if (price != null) {
        final value = holding.amount * price.priceIdr;
        totalAssetIdr += value;
        assetsWithPrice++;
        
        assetBreakdown.add(AssetZakatBreakdown(
          symbol: holding.symbol,
          amount: holding.amount,
          priceIdr: price.priceIdr,
          valueIdr: value,
          hasPrice: true,
        ));
      } else {
        assetsWithoutPrice++;
        
        assetBreakdown.add(AssetZakatBreakdown(
          symbol: holding.symbol,
          amount: holding.amount,
          priceIdr: 0,
          valueIdr: 0,
          hasPrice: false,
        ));
      }
    }

    // 2. Hitung nishab
    final nishabIdr = goldPricePerGramIdr * nishabGramEmas;

    // 3. Tentukan status zakat
    final isWajib = totalAssetIdr >= nishabIdr;

    // 4. Hitung zakat (jika wajib)
    final zakatAmountIdr = isWajib ? totalAssetIdr * zakatRate : 0.0;

    // 5. Hitung selisih dari nishab
    final selisihDariNishab = totalAssetIdr - nishabIdr;

    return ZakatCalculation(
      totalAssetIdr: totalAssetIdr,
      nishabIdr: nishabIdr,
      goldPricePerGramIdr: goldPricePerGramIdr,
      zakatAmountIdr: zakatAmountIdr,
      zakatRate: zakatRate,
      isWajib: isWajib,
      selisihDariNishab: selisihDariNishab,
      assetsWithPrice: assetsWithPrice,
      assetsWithoutPrice: assetsWithoutPrice,
      assetBreakdown: assetBreakdown,
      calculatedAt: DateTime.now(),
    );
  }

  /// Quick check apakah wajib zakat tanpa full calculation
  bool isWajibZakat({
    required double totalAssetIdr,
    required double goldPricePerGramIdr,
  }) {
    final nishabIdr = goldPricePerGramIdr * nishabGramEmas;
    return totalAssetIdr >= nishabIdr;
  }
}

// =============================================================================
// ZAKAT CALCULATION RESULT MODEL
// =============================================================================

class ZakatCalculation {
  /// Total nilai aset dalam IDR
  final double totalAssetIdr;

  /// Nilai nishab dalam IDR (85 gram emas)
  final double nishabIdr;

  /// Harga emas per gram
  final double goldPricePerGramIdr;

  /// Jumlah zakat yang harus dibayar (jika wajib)
  final double zakatAmountIdr;

  /// Tarif zakat (2.5%)
  final double zakatRate;

  /// Apakah wajib zakat (total >= nishab)
  final bool isWajib;

  /// Selisih dari nishab (positif = di atas, negatif = di bawah)
  final double selisihDariNishab;

  /// Jumlah aset yang memiliki harga
  final int assetsWithPrice;

  /// Jumlah aset yang tidak memiliki harga
  final int assetsWithoutPrice;

  /// Breakdown per aset
  final List<AssetZakatBreakdown> assetBreakdown;

  /// Waktu perhitungan
  final DateTime calculatedAt;

  const ZakatCalculation({
    required this.totalAssetIdr,
    required this.nishabIdr,
    required this.goldPricePerGramIdr,
    required this.zakatAmountIdr,
    required this.zakatRate,
    required this.isWajib,
    required this.selisihDariNishab,
    required this.assetsWithPrice,
    required this.assetsWithoutPrice,
    required this.assetBreakdown,
    required this.calculatedAt,
  });

  /// Persentase dari nishab
  double get percentageOfNishab {
    if (nishabIdr == 0) return 0;
    return (totalAssetIdr / nishabIdr) * 100;
  }

  /// Status text
  String get statusText => isWajib ? 'WAJIB ZAKAT' : 'BELUM WAJIB';

  /// Apakah ada aset tanpa harga
  bool get hasMissingPrices => assetsWithoutPrice > 0;

  /// Total aset
  int get totalAssets => assetsWithPrice + assetsWithoutPrice;

  // ===========================================================================
  // FORMATTERS
  // ===========================================================================

  String formatRupiah(double value) {
    if (value >= 1000000000) {
      return 'Rp ${(value / 1000000000).toStringAsFixed(2)} M';
    } else if (value >= 1000000) {
      return 'Rp ${(value / 1000000).toStringAsFixed(2)} jt';
    } else if (value >= 1000) {
      return 'Rp ${value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';
    }
    return 'Rp ${value.toStringAsFixed(0)}';
  }

  String get totalAssetFormatted => formatRupiah(totalAssetIdr);
  String get nishabFormatted => formatRupiah(nishabIdr);
  String get zakatAmountFormatted => formatRupiah(zakatAmountIdr);
  String get goldPriceFormatted => formatRupiah(goldPricePerGramIdr);
  
  String get selisihFormatted {
    final abs = selisihDariNishab.abs();
    final prefix = selisihDariNishab >= 0 ? '+' : '-';
    return '$prefix ${formatRupiah(abs)}';
  }

  String get zakatRateFormatted => '${(zakatRate * 100).toStringAsFixed(1)}%';

  @override
  String toString() {
    return 'ZakatCalculation(total: $totalAssetFormatted, nishab: $nishabFormatted, '
           'status: $statusText, zakat: $zakatAmountFormatted)';
  }
}

// =============================================================================
// ASSET BREAKDOWN MODEL
// =============================================================================

class AssetZakatBreakdown {
  final String symbol;
  final double amount;
  final double priceIdr;
  final double valueIdr;
  final bool hasPrice;

  const AssetZakatBreakdown({
    required this.symbol,
    required this.amount,
    required this.priceIdr,
    required this.valueIdr,
    required this.hasPrice,
  });

  String get valueFormatted {
    if (!hasPrice) return 'Harga tidak tersedia';
    
    if (valueIdr >= 1000000000) {
      return 'Rp ${(valueIdr / 1000000000).toStringAsFixed(2)} M';
    } else if (valueIdr >= 1000000) {
      return 'Rp ${(valueIdr / 1000000).toStringAsFixed(2)} jt';
    }
    return 'Rp ${valueIdr.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
}
