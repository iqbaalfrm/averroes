import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// =============================================================================
/// COINGECKO SERVICE
/// =============================================================================
/// Service untuk fetch harga kripto real-time dari CoinGecko API

class CoinGeckoService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';
  static const Duration _timeout = Duration(seconds: 15);
  static const Duration _cacheExpiry = Duration(minutes: 2);

  // Singleton
  static final CoinGeckoService _instance = CoinGeckoService._internal();
  factory CoinGeckoService() => _instance;
  CoinGeckoService._internal();

  // In-memory cache
  final Map<String, CoinPrice> _priceCache = {};
  DateTime? _lastFetchTime;

  // ===========================================================================
  // SYMBOL TO COINGECKO ID MAPPING
  // ===========================================================================
  
  /// Map symbol ke CoinGecko ID
  /// Tambahkan mapping baru sesuai kebutuhan
  static const Map<String, String> coinIdMap = {
    // Major Coins
    'BTC': 'bitcoin',
    'ETH': 'ethereum',
    'BNB': 'binancecoin',
    'SOL': 'solana',
    'XRP': 'ripple',
    'ADA': 'cardano',
    'DOGE': 'dogecoin',
    'DOT': 'polkadot',
    'MATIC': 'matic-network',
    'AVAX': 'avalanche-2',
    'LINK': 'chainlink',
    'LTC': 'litecoin',
    'ATOM': 'cosmos',
    'UNI': 'uniswap',
    'XLM': 'stellar',
    'ALGO': 'algorand',
    'VET': 'vechain',
    'FIL': 'filecoin',
    'TRX': 'tron',
    'ETC': 'ethereum-classic',
    
    // Stablecoins
    'USDT': 'tether',
    'USDC': 'usd-coin',
    'BUSD': 'binance-usd',
    'DAI': 'dai',
    
    // DeFi & Others
    'AAVE': 'aave',
    'CAKE': 'pancakeswap-token',
    'NEAR': 'near',
    'FTM': 'fantom',
    'SAND': 'the-sandbox',
    'MANA': 'decentraland',
    'AXS': 'axie-infinity',
    'APE': 'apecoin',
    'CRO': 'crypto-com-chain',
    'SHIB': 'shiba-inu',
    'PEPE': 'pepe',
    'ARB': 'arbitrum',
    'OP': 'optimism',
    'INJ': 'injective-protocol',
    'SUI': 'sui',
    'APT': 'aptos',
    'SEI': 'sei-network',
    'TIA': 'celestia',
    'JUP': 'jupiter-exchange-solana',
    'WIF': 'dogwifcoin',
    'BONK': 'bonk',
    'FLOKI': 'floki',
    'IMX': 'immutable-x',
    'RUNE': 'thorchain',
    'GRT': 'the-graph',
    'MKR': 'maker',
    'SNX': 'havven',
    'COMP': 'compound-governance-token',
    'YFI': 'yearn-finance',
    'CRV': 'curve-dao-token',
    'SUSHI': 'sushi',
    '1INCH': '1inch',
    'ENS': 'ethereum-name-service',
    'LDO': 'lido-dao',
    'RPL': 'rocket-pool',
    'GMX': 'gmx',
    'DYDX': 'dydx',
    'BLUR': 'blur',
    'STX': 'blockstack',
    'ICP': 'internet-computer',
    'EGLD': 'elrond-erd-2',
    'HBAR': 'hedera-hashgraph',
    'QNT': 'quant-network',
    'XMR': 'monero',
    'NEO': 'neo',
    'EOS': 'eos',
    'XTZ': 'tezos',
    'THETA': 'theta-token',
    'KLAY': 'klay-token',
    'ZEC': 'zcash',
    'FLOW': 'flow',
    'MINA': 'mina-protocol',
    'KSM': 'kusama',
    'CHZ': 'chiliz',
    'ENJ': 'enjincoin',
    'BAT': 'basic-attention-token',
    'ZIL': 'zilliqa',
    'IOTA': 'iota',
    'KAVA': 'kava',
    'ROSE': 'oasis-network',
    'ONE': 'harmony',
    'CELO': 'celo',
    'ANKR': 'ankr',
    'LRC': 'loopring',
    'OCEAN': 'ocean-protocol',
    'FET': 'fetch-ai',
    'AGIX': 'singularitynet',
    'RNDR': 'render-token',
    'WLD': 'worldcoin-wld',
    'PYTH': 'pyth-network',
  };

  /// Get CoinGecko ID dari symbol
  String? getCoinId(String symbol) {
    return coinIdMap[symbol.toUpperCase()];
  }

  /// Check if symbol is supported
  bool isSupported(String symbol) {
    return coinIdMap.containsKey(symbol.toUpperCase());
  }

  // ===========================================================================
  // PRICE FETCHING
  // ===========================================================================

  /// Fetch harga untuk multiple coins sekaligus
  Future<Map<String, CoinPrice>> fetchPrices(List<String> symbols) async {
    if (symbols.isEmpty) return {};

    // Filter symbols yang supported
    final Map<String, String> symbolToId = {};
    for (final symbol in symbols) {
      final id = getCoinId(symbol);
      if (id != null) {
        symbolToId[symbol.toUpperCase()] = id;
      }
    }

    if (symbolToId.isEmpty) return {};

    // Check cache validity
    if (_isCacheValid(symbolToId.keys.toList())) {
      return _getCachedPrices(symbolToId.keys.toList());
    }

    try {
      final ids = symbolToId.values.join(',');
      final url = Uri.parse(
        '$_baseUrl/simple/price?ids=$ids&vs_currencies=idr,usd&include_24hr_change=true',
      );

      print('🌐 [CoinGecko] Fetching prices for: $ids');

      final response = await http.get(url).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final result = <String, CoinPrice>{};

        for (final entry in symbolToId.entries) {
          final symbol = entry.key;
          final coinId = entry.value;
          final priceData = data[coinId];

          if (priceData != null) {
            final price = CoinPrice(
              symbol: symbol,
              priceIdr: (priceData['idr'] ?? 0).toDouble(),
              priceUsd: (priceData['usd'] ?? 0).toDouble(),
              change24h: priceData['idr_24h_change']?.toDouble(),
              lastUpdated: DateTime.now(),
            );
            result[symbol] = price;
            _priceCache[symbol] = price;
          }
        }

        _lastFetchTime = DateTime.now();
        print('✅ [CoinGecko] Fetched ${result.length} prices');
        return result;
      } else if (response.statusCode == 429) {
        print('⚠️ [CoinGecko] Rate limited, using cache');
        return _getCachedPrices(symbolToId.keys.toList());
      } else {
        throw Exception('Kesalahan API: ${response.statusCode}');
      }
    } on TimeoutException {
      print('⚠️ [CoinGecko] Timeout, using cache');
      return _getCachedPrices(symbolToId.keys.toList());
    } catch (e) {
      print('❌ [CoinGecko] Error: $e');
      return _getCachedPrices(symbolToId.keys.toList());
    }
  }

  /// Fetch harga untuk single coin
  Future<CoinPrice?> fetchPrice(String symbol) async {
    final result = await fetchPrices([symbol]);
    return result[symbol.toUpperCase()];
  }

  // ===========================================================================
  // CACHE MANAGEMENT
  // ===========================================================================

  bool _isCacheValid(List<String> symbols) {
    if (_lastFetchTime == null) return false;
    
    final isExpired = DateTime.now().difference(_lastFetchTime!) > _cacheExpiry;
    if (isExpired) return false;

    // Check if all symbols are in cache
    for (final symbol in symbols) {
      if (!_priceCache.containsKey(symbol.toUpperCase())) {
        return false;
      }
    }
    return true;
  }

  Map<String, CoinPrice> _getCachedPrices(List<String> symbols) {
    final result = <String, CoinPrice>{};
    for (final symbol in symbols) {
      final cached = _priceCache[symbol.toUpperCase()];
      if (cached != null) {
        result[symbol.toUpperCase()] = cached;
      }
    }
    return result;
  }

  /// Get cached price for a symbol
  CoinPrice? getCachedPrice(String symbol) {
    return _priceCache[symbol.toUpperCase()];
  }

  /// Clear all cached prices
  void clearCache() {
    _priceCache.clear();
    _lastFetchTime = null;
    print('🗑️ [CoinGecko] Cache cleared');
  }

  /// Check if cache has data
  bool get hasCache => _priceCache.isNotEmpty;

  /// Get all supported symbols
  List<String> get supportedSymbols => coinIdMap.keys.toList();

  /// Search coins for autocomplete
  Future<List<Map<String, dynamic>>> searchCoins(String query) async {
    final url = Uri.parse('$_baseUrl/search?query=$query');
    try {
      final response = await http.get(url).timeout(_timeout);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['coins']);
      }
    } catch (e) {
      print('Search Error: $e');
    }
    return [];
  }
}

// =============================================================================
// COIN PRICE MODEL
// =============================================================================

class CoinPrice {
  final String symbol;
  final double priceIdr;
  final double priceUsd;
  final double? change24h;
  final DateTime lastUpdated;

  const CoinPrice({
    required this.symbol,
    required this.priceIdr,
    required this.priceUsd,
    this.change24h,
    required this.lastUpdated,
  });

  /// Format harga ke Rupiah
  String get priceFormatted {
    if (priceIdr >= 1000000000) {
      return 'Rp ${(priceIdr / 1000000000).toStringAsFixed(2)} M';
    } else if (priceIdr >= 1000000) {
      return 'Rp ${(priceIdr / 1000000).toStringAsFixed(2)} jt';
    } else if (priceIdr >= 1000) {
      return 'Rp ${_formatWithDots(priceIdr.round())}';
    } else if (priceIdr >= 1) {
      return 'Rp ${priceIdr.toStringAsFixed(2)}';
    } else {
      return 'Rp ${priceIdr.toStringAsFixed(6)}';
    }
  }

  String _formatWithDots(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  /// Check if price is positive change
  bool get isPositiveChange => (change24h ?? 0) >= 0;

  /// Format change percentage
  String get changeFormatted {
    if (change24h == null) return '';
    final sign = change24h! >= 0 ? '+' : '';
    return '$sign${change24h!.toStringAsFixed(2)}%';
  }

  /// Check if cache is stale (> 5 minutes)
  bool get isStale => DateTime.now().difference(lastUpdated).inMinutes > 5;

  @override
  String toString() => 'CoinPrice($symbol: $priceFormatted)';
}
