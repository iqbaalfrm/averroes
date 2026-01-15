/// Model untuk item pasar crypto dari CoinGecko API
/// 
/// Field raw disimpan untuk kalkulasi/sorting jika diperlukan.
/// Field formatted sudah siap ditampilkan di UI.
class CryptoMarketItem {
  // === Raw data (untuk kalkulasi) ===
  final String id;
  final String symbol;
  final String name;
  final double priceUsd;
  final double priceIdr;
  final double change24h;
  final double change7d;
  final double volume24h;
  final double marketCap;
  final String? imageUrl;
  final int? marketCapRank;

  // === Formatted data (untuk UI) ===
  final String code;
  final String priceUsdFormatted;
  final String priceIdrFormatted;
  final String change24hFormatted;
  final String change7dFormatted;
  final String volumeFormatted;
  final String marketCapFormatted;
  final bool isUp;

  const CryptoMarketItem({
    required this.id,
    required this.symbol,
    required this.name,
    required this.priceUsd,
    required this.priceIdr,
    required this.change24h,
    required this.change7d,
    required this.volume24h,
    required this.marketCap,
    this.imageUrl,
    this.marketCapRank,
    required this.code,
    required this.priceUsdFormatted,
    required this.priceIdrFormatted,
    required this.change24hFormatted,
    required this.change7dFormatted,
    required this.volumeFormatted,
    required this.marketCapFormatted,
    required this.isUp,
  });

  /// Factory constructor dari response JSON CoinGecko
  /// 
  /// [jsonUsd] - Response dari /coins/markets?vs_currency=usd
  /// [priceIdr] - Harga dalam IDR dari request terpisah
  factory CryptoMarketItem.fromJson(
    Map<String, dynamic> jsonUsd, {
    double? priceIdr,
  }) {
    final double priceUsdRaw = (jsonUsd['current_price'] ?? 0).toDouble();
    final double priceIdrRaw = priceIdr ?? 0;
    final double change24hRaw = (jsonUsd['price_change_percentage_24h'] ?? 0).toDouble();
    final double change7dRaw = (jsonUsd['price_change_percentage_7d_in_currency'] ?? 0).toDouble();
    final double volume24hRaw = (jsonUsd['total_volume'] ?? 0).toDouble();
    final double marketCapRaw = (jsonUsd['market_cap'] ?? 0).toDouble();

    return CryptoMarketItem(
      id: jsonUsd['id'] ?? '',
      symbol: jsonUsd['symbol'] ?? '',
      name: jsonUsd['name'] ?? '',
      priceUsd: priceUsdRaw,
      priceIdr: priceIdrRaw,
      change24h: change24hRaw,
      change7d: change7dRaw,
      volume24h: volume24hRaw,
      marketCap: marketCapRaw,
      imageUrl: jsonUsd['image'],
      marketCapRank: jsonUsd['market_cap_rank'],
      code: (jsonUsd['symbol'] ?? '').toString().toUpperCase(),
      priceUsdFormatted: _formatUsd(priceUsdRaw),
      priceIdrFormatted: _formatIdr(priceIdrRaw),
      change24hFormatted: _formatPercent(change24hRaw),
      change7dFormatted: _formatPercent(change7dRaw),
      volumeFormatted: _formatBigNumber(volume24hRaw, prefix: '\$'),
      marketCapFormatted: _formatBigNumber(marketCapRaw, prefix: '\$'),
      isUp: change24hRaw >= 0,
    );
  }

  factory CryptoMarketItem.fromSupabaseRow(Map<String, dynamic> row) {
    final priceUsdRaw = (row['price_usd'] ?? 0).toDouble();
    final change24hRaw = (row['change_24h'] ?? 0).toDouble();
    final change7dRaw = (row['change_7d'] ?? 0).toDouble();
    final volume24hRaw = (row['volume_usd'] ?? 0).toDouble();
    final marketCapRaw = (row['market_cap_usd'] ?? 0).toDouble();
    final code = (row['code'] ?? '').toString();

    return CryptoMarketItem(
      id: row['id']?.toString() ?? code.toLowerCase(),
      symbol: code.toLowerCase(),
      name: row['name'] ?? '',
      priceUsd: priceUsdRaw,
      priceIdr: 0,
      change24h: change24hRaw,
      change7d: change7dRaw,
      volume24h: volume24hRaw,
      marketCap: marketCapRaw,
      imageUrl: null,
      marketCapRank: null,
      code: code.toUpperCase(),
      priceUsdFormatted: _formatUsd(priceUsdRaw),
      priceIdrFormatted: _formatIdr(0),
      change24hFormatted: _formatPercent(change24hRaw),
      change7dFormatted: _formatPercent(change7dRaw),
      volumeFormatted: _formatBigNumber(volume24hRaw, prefix: '\$'),
      marketCapFormatted: _formatBigNumber(marketCapRaw, prefix: '\$'),
      isUp: change24hRaw >= 0,
    );
  }

  // ===========================================================================
  // STATIC FORMATTERS
  // ===========================================================================

  /// Format angka ke USD dengan separator ribuan
  /// Contoh: 43250.5 -> "$43,250"
  static String _formatUsd(double value) {
    if (value >= 1) {
      // Untuk harga >= 1, tampilkan 2 decimal atau tanpa decimal
      final formatted = _numberWithCommas(value, decimals: value < 10 ? 2 : 0);
      return '\$$formatted';
    } else if (value >= 0.01) {
      // Untuk harga < 1 tapi >= 0.01, tampilkan 2 decimal
      return '\$${value.toStringAsFixed(2)}';
    } else {
      // Untuk harga sangat kecil, tampilkan lebih banyak decimal
      return '\$${value.toStringAsFixed(6)}';
    }
  }

  /// Format angka ke IDR dengan separator titik
  /// Contoh: 680125000 -> "Rp 680.125.000"
  static String _formatIdr(double value) {
    if (value == 0) return 'Rp -';
    
    final intValue = value.round();
    final formatted = _numberWithDotsIdr(intValue);
    return 'Rp $formatted';
  }

  /// Format persentase dengan 2 decimal dan tanda +/-
  /// Contoh: 3.24 -> "+3.24%", -1.23 -> "-1.23%"
  static String _formatPercent(double value) {
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }

  /// Format angka besar ke B/M/K
  /// Contoh: 28500000000 -> "$28.5B", 520000000 -> "$520M"
  static String _formatBigNumber(double value, {String prefix = ''}) {
    if (value >= 1e12) {
      return '$prefix${(value / 1e12).toStringAsFixed(2)}T';
    } else if (value >= 1e9) {
      return '$prefix${(value / 1e9).toStringAsFixed(1)}B';
    } else if (value >= 1e6) {
      return '$prefix${(value / 1e6).toStringAsFixed(0)}M';
    } else if (value >= 1e3) {
      return '$prefix${(value / 1e3).toStringAsFixed(0)}K';
    }
    return '$prefix${value.toStringAsFixed(0)}';
  }

  /// Helper: Format angka dengan comma separator (US style)
  static String _numberWithCommas(double value, {int decimals = 0}) {
    final parts = value.toStringAsFixed(decimals).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    if (decimals > 0 && parts.length > 1) {
      return '$intPart.${parts[1]}';
    }
    return intPart;
  }

  /// Helper: Format angka dengan dot separator (Indonesian style)
  static String _numberWithDotsIdr(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  String toString() {
    return 'CryptoMarketItem(id: $id, code: $code, name: $name, price: $priceUsdFormatted)';
  }
}


/// Model untuk data global market dari /global endpoint
class GlobalMarketData {
  final double totalMarketCapUsd;
  final double totalVolumeUsd;
  final double btcDominance;
  final double marketCapChangePercent24h;

  // Formatted strings
  final String totalMarketCapFormatted;
  final String totalVolumeFormatted;
  final String btcDominanceFormatted;
  final String marketCapChangeFormatted;
  final bool isMarketCapUp;

  const GlobalMarketData({
    required this.totalMarketCapUsd,
    required this.totalVolumeUsd,
    required this.btcDominance,
    required this.marketCapChangePercent24h,
    required this.totalMarketCapFormatted,
    required this.totalVolumeFormatted,
    required this.btcDominanceFormatted,
    required this.marketCapChangeFormatted,
    required this.isMarketCapUp,
  });

  factory GlobalMarketData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    
    final totalMarketCap = (data['total_market_cap']?['usd'] ?? 0).toDouble();
    final totalVolume = (data['total_volume']?['usd'] ?? 0).toDouble();
    final btcDom = (data['market_cap_percentage']?['btc'] ?? 0).toDouble();
    final marketCapChange = (data['market_cap_change_percentage_24h_usd'] ?? 0).toDouble();

    return GlobalMarketData(
      totalMarketCapUsd: totalMarketCap,
      totalVolumeUsd: totalVolume,
      btcDominance: btcDom,
      marketCapChangePercent24h: marketCapChange,
      totalMarketCapFormatted: CryptoMarketItem._formatBigNumber(totalMarketCap, prefix: '\$'),
      totalVolumeFormatted: CryptoMarketItem._formatBigNumber(totalVolume, prefix: '\$'),
      btcDominanceFormatted: '${btcDom.toStringAsFixed(1)}%',
      marketCapChangeFormatted: CryptoMarketItem._formatPercent(marketCapChange),
      isMarketCapUp: marketCapChange >= 0,
    );
  }

  /// Placeholder/fallback data jika API gagal
  factory GlobalMarketData.placeholder() {
    return const GlobalMarketData(
      totalMarketCapUsd: 0,
      totalVolumeUsd: 0,
      btcDominance: 0,
      marketCapChangePercent24h: 0,
      totalMarketCapFormatted: '\$--',
      totalVolumeFormatted: '\$--',
      btcDominanceFormatted: '--%',
      marketCapChangeFormatted: '--%',
      isMarketCapUp: true,
    );
  }
}


/// Model untuk data point pada chart harga
class ChartPoint {
  final int timestamp;
  final double price;

  const ChartPoint({
    required this.timestamp,
    required this.price,
  });

  /// Konversi timestamp ke DateTime
  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);

  /// Format harga untuk tooltip
  String get priceFormatted => CryptoMarketItem._formatUsd(price);

  @override
  String toString() => 'ChartPoint(time: $dateTime, price: $price)';
}
