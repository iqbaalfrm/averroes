import 'dart:async';
import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../config/env_config.dart';

/// =============================================================================
/// GOLD PRICE SERVICE - Harga Emas Indonesia
/// =============================================================================
/// 
/// Strategi:
/// 1. Primary: Harga emas Antam Indonesia (via scraping/API alternatif)
/// 2. Fallback: GoldAPI (XAU → IDR)
/// 3. Cache: minimal 6 jam
/// 
/// Output: goldPricePerGramIdr
/// =============================================================================

class GoldPriceService {
  static const String _storageKey = 'gold_price_cache';
  static const Duration _cacheDuration = Duration(hours: 6);
  
  // Fallback: GoldAPI (from environment config)
  String get _goldApiKey => EnvConfig.goldApiKey;
  
  final http.Client _client;
  final GetStorage _storage;

  GoldPriceService({http.Client? client, GetStorage? storage}) 
      : _client = client ?? http.Client(),
        _storage = storage ?? GetStorage();

  /// Ambil harga emas per gram dalam IDR
  /// Menggunakan cache jika masih valid
  Future<GoldPriceData> getGoldPriceIdr() async {
    // Cek cache dulu
    final cached = _getCachedPrice();
    if (cached != null && !cached.isExpired) {
      print('💰 [Gold] Using cached price: Rp ${cached.pricePerGramIdr}');
      return cached;
    }

    // Coba ambil harga baru
    try {
      final freshPrice = await _fetchGoldPrice();
      await _cachePrice(freshPrice);
      return freshPrice;
    } catch (e) {
      print('⚠️ [Gold] Fetch failed: $e');
      
      // Gunakan cache lama jika ada (meski expired)
      if (cached != null) {
        print('💰 [Gold] Using expired cache as fallback');
        return cached;
      }
      
      // Fallback ke harga default (estimasi)
      return GoldPriceData.fallback();
    }
  }

  /// Fetch harga emas dari berbagai sumber
  Future<GoldPriceData> _fetchGoldPrice() async {
    // Strategi 1: Coba API harga emas Indonesia
    try {
      final indonesiaPrice = await _fetchFromIndonesiaSource();
      if (indonesiaPrice != null) {
        return indonesiaPrice;
      }
    } catch (e) {
      print('⚠️ [Gold] Indonesia source failed: $e');
    }

    // Strategi 2: Fallback ke GoldAPI (XAU/USD → IDR)
    try {
      final goldApiPrice = await _fetchFromGoldApi();
      if (goldApiPrice != null) {
        return goldApiPrice;
      }
    } catch (e) {
      print('⚠️ [Gold] GoldAPI failed: $e');
    }

    // Strategi 3: Fallback ke exchange rate calculation
    return await _calculateFromExchangeRate();
  }

  /// Fetch dari sumber Indonesia (via proxy/scraping alternatif)
  /// Menggunakan estimasi berdasarkan harga internasional + premium lokal
  Future<GoldPriceData?> _fetchFromIndonesiaSource() async {
    // Karena API Antam tidak tersedia public, kita gunakan estimasi
    // Harga emas Indonesia biasanya 5-10% di atas harga internasional
    
    // Fetch harga XAU dari API gratis
    final uri = Uri.parse('https://api.exchangerate-api.com/v4/latest/XAU');
    
    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 10),
      );
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final rates = json['rates'] as Map<String, dynamic>?;
        
        if (rates != null && rates.containsKey('IDR')) {
          // XAU ke IDR (per troy ounce)
          final xauToIdr = (rates['IDR'] as num).toDouble();
          
          // 1 troy ounce = 31.1035 gram
          final pricePerGram = xauToIdr / 31.1035;
          
          // Tambah premium Indonesia (~7%)
          final indonesiaPrice = pricePerGram * 1.07;
          
          return GoldPriceData(
            pricePerGramIdr: indonesiaPrice,
            source: 'Kurs + Istimewa',
            lastUpdated: DateTime.now(),
          );
        }
      }
    } catch (e) {
      print('⚠️ [Gold] Exchange rate API failed: $e');
    }
    
    return null;
  }

  /// Fetch dari GoldAPI
  Future<GoldPriceData?> _fetchFromGoldApi() async {
    // GoldAPI endpoint (demo/limited)
    final uri = Uri.parse('https://www.goldapi.io/api/XAU/IDR');
    
    try {
      final response = await _client.get(
        uri,
        headers: {
          'x-access-token': _goldApiKey,
        },
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final pricePerOunce = (json['price'] as num?)?.toDouble();
        
        if (pricePerOunce != null) {
          final pricePerGram = pricePerOunce / 31.1035;
          
          return GoldPriceData(
            pricePerGramIdr: pricePerGram,
            source: 'GoldAPI',
            lastUpdated: DateTime.now(),
          );
        }
      }
    } catch (e) {
      print('⚠️ [Gold] GoldAPI error: $e');
    }
    
    return null;
  }

  /// Kalkulasi dari exchange rate USD/IDR
  Future<GoldPriceData> _calculateFromExchangeRate() async {
    // Harga emas internasional rata-rata (estimasi)
    // Per Januari 2024: ~$65/gram
    const goldUsdPerGram = 65.0;
    
    // Fetch USD/IDR rate
    try {
      final uri = Uri.parse('https://api.exchangerate-api.com/v4/latest/USD');
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 10),
      );
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final rates = json['rates'] as Map<String, dynamic>?;
        
        if (rates != null && rates.containsKey('IDR')) {
          final usdToIdr = (rates['IDR'] as num).toDouble();
          final priceIdr = goldUsdPerGram * usdToIdr * 1.07; // +7% premium Indonesia
          
          return GoldPriceData(
            pricePerGramIdr: priceIdr,
            source: 'USD/IDR Exchange',
            lastUpdated: DateTime.now(),
          );
        }
      }
    } catch (e) {
      print('⚠️ [Gold] USD/IDR fetch failed: $e');
    }
    
    // Ultimate fallback
    return GoldPriceData.fallback();
  }

  /// Get cached price
  GoldPriceData? _getCachedPrice() {
    try {
      final cached = _storage.read<Map<String, dynamic>>(_storageKey);
      if (cached != null) {
        return GoldPriceData.fromJson(cached);
      }
    } catch (e) {
      print('⚠️ [Gold] Cache read error: $e');
    }
    return null;
  }

  /// Cache price
  Future<void> _cachePrice(GoldPriceData data) async {
    try {
      await _storage.write(_storageKey, data.toJson());
      print('💰 [Gold] Cached: Rp ${data.pricePerGramIdr.toStringAsFixed(0)}/gram');
    } catch (e) {
      print('⚠️ [Gold] Cache write error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

// =============================================================================
// DATA MODEL
// =============================================================================

class GoldPriceData {
  final double pricePerGramIdr;
  final String source;
  final DateTime lastUpdated;
  final bool isEstimated;

  const GoldPriceData({
    required this.pricePerGramIdr,
    required this.source,
    required this.lastUpdated,
    this.isEstimated = false,
  });

  /// Fallback harga jika semua API gagal
  /// Estimasi berdasarkan harga emas Indonesia Januari 2024
  factory GoldPriceData.fallback() {
    return GoldPriceData(
      pricePerGramIdr: 1100000, // ~Rp 1.100.000/gram
      source: 'Estimasi',
      lastUpdated: DateTime.now(),
      isEstimated: true,
    );
  }

  factory GoldPriceData.fromJson(Map<String, dynamic> json) {
    return GoldPriceData(
      pricePerGramIdr: (json['pricePerGramIdr'] as num).toDouble(),
      source: json['source'] as String? ?? 'Cache',
      lastUpdated: DateTime.tryParse(json['lastUpdated'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pricePerGramIdr': pricePerGramIdr,
      'source': source,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  bool get isExpired {
    return DateTime.now().difference(lastUpdated) > const Duration(hours: 6);
  }

  String get priceFormatted {
    return 'Rp ${_formatNumber(pricePerGramIdr)}/gram';
  }

  String _formatNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(2)} jt';
    } else if (value >= 1000) {
      final formatted = value.toStringAsFixed(0);
      // Add thousand separator
      return formatted.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
    }
    return value.toStringAsFixed(0);
  }
}
