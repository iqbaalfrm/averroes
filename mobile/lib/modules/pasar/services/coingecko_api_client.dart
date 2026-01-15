import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/crypto_market_item.dart';

/// Client untuk mengakses CoinGecko API (Device Ready Version)
/// 
/// Fitur:
/// - Handling SocketException (No Internet)
/// - Handling TimeoutException (Slow Connection)
/// - Detailed Logging
/// - Error Body Capture
class CoinGeckoApiClient {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';
  
  // API Key config
  static const String _apiKey = 'CG-bdFnemYCrQmta4aQL9fmSp4K';
  static const String _apiKeyHeader = 'x-cg-demo-api-key';

  final http.Client _client;

  CoinGeckoApiClient({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> get _headers => {
    _apiKeyHeader: _apiKey,
    'Accept': 'application/json',
  };

  // ===========================================================================
  // HELPER: HTTP GET WITH ROBUST ERROR HANDLING
  // ===========================================================================
  
  Future<dynamic> _get(Uri uri, {int timeoutSeconds = 12}) async {
    try {
      print('🌐 [API REQ] $uri');
      
      final response = await _client.get(uri, headers: _headers).timeout(
        Duration(seconds: timeoutSeconds),
        onTimeout: () {
          throw TimeoutException('Koneksi timeout ($timeoutSeconds detik). Server lambat atau sinyal buruk.');
        },
      );

      print('📥 [API RES] ${response.statusCode} | Length: ${response.body.length} bytes');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Capture error body for debugging
        final bodySnippet = response.body.length > 300 
            ? '${response.body.substring(0, 300)}...' 
            : response.body;
        print('❌ [API ERR] Body: $bodySnippet');

        if (response.statusCode == 429) {
          throw const HttpException('Rate Limit (429). Terlalu banyak request. Tunggu sebentar.');
        } else if (response.statusCode == 403 || response.statusCode == 401) {
          throw HttpException('Akses Ditolak (${response.statusCode}). Cek API Key atau Firewall.');
        } else if (response.statusCode >= 500) {
          throw HttpException('Server Error (${response.statusCode}). CoinGecko sedang gangguan.');
        } else {
          throw HttpException('Gagal memuat data (${response.statusCode}).');
        }
      }
    } on SocketException catch (e) {
      print('❌ [NET ERR] SocketException: $e');
      throw const SocketException('Tidak ada koneksi internet / DNS tidak terjangkau.');
    } on TimeoutException catch (e) {
      print('❌ [TIMEOUT] $e');
      rethrow;
    } on HttpException catch (e) {
      print('❌ [HTTP ERR] ${e.message}');
      rethrow; // Rethrow custom HttpException
    } catch (e) {
      print('❌ [UNKNOWN] $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // ===========================================================================
  // PUBLIC METHODS
  // ===========================================================================

  /// Fetch daftar crypto market dengan harga USD dan IDR
  Future<List<CryptoMarketItem>> fetchMarketData({int perPage = 50, int page = 1}) async {
    // Fetch USD & IDR secara paralel
    final results = await Future.wait([
      _fetchMarketsByVsCurrency('usd', perPage: perPage, page: page),
      _fetchMarketsByVsCurrency('idr', perPage: perPage, page: page),
    ]);

    final usdList = results[0] as List<dynamic>;
    final idrList = results[1] as List<dynamic>;

    // Mapping IDR Price
    final idrPriceMap = <String, double>{};
    for (final item in idrList) {
      if (item['id'] != null) {
        idrPriceMap[item['id']] = (item['current_price'] ?? 0).toDouble();
      }
    }

    // Gabungkan Data
    return usdList.map((usdItem) {
      final id = usdItem['id'];
      final priceIdr = id != null ? idrPriceMap[id] : null;
      return CryptoMarketItem.fromJson(usdItem, priceIdr: priceIdr);
    }).toList();
  }

  /// Fetch data global market
  Future<GlobalMarketData> fetchGlobalData() async {
    final uri = Uri.parse('$_baseUrl/global');
    final json = await _get(uri);
    return GlobalMarketData.fromJson(json as Map<String, dynamic>);
  }

  /// Fetch data chart harga
  Future<List<ChartPoint>> fetchMarketChart({
    required String coinId,
    required int days,
    String vsCurrency = 'usd',
  }) async {
    final uri = Uri.parse('$_baseUrl/coins/$coinId/market_chart').replace(
      queryParameters: {
        'vs_currency': vsCurrency,
        'days': days.toString(),
      },
    );

    final json = await _get(uri);
    final prices = json['prices'] as List<dynamic>? ?? [];

    // Parse & Sample Data
    final points = <ChartPoint>[];
    final sampleRate = _calculateSampleRate(prices.length);

    for (int i = 0; i < prices.length; i += sampleRate) {
      final priceData = prices[i] as List<dynamic>;
      if (priceData.length >= 2) {
        points.add(ChartPoint(
          timestamp: (priceData[0] as num).toInt(),
          price: (priceData[1] as num).toDouble(),
        ));
      }
    }
    return points;
  }

  // ===========================================================================
  // PRIVATE METHODS
  // ===========================================================================

  Future<List<dynamic>> _fetchMarketsByVsCurrency(
    String vsCurrency, {
    required int perPage,
    required int page,
  }) async {
    final uri = Uri.parse('$_baseUrl/coins/markets').replace(
      queryParameters: {
        'vs_currency': vsCurrency,
        'order': 'market_cap_desc',
        'per_page': perPage.toString(),
        'page': page.toString(),
        'sparkline': 'false',
        'price_change_percentage': '24h,7d',
      },
    );
    
    final response = await _get(uri);
    return response as List<dynamic>;
  }

  int _calculateSampleRate(int totalPoints) {
    const maxPoints = 150;
    if (totalPoints <= maxPoints) return 1;
    return (totalPoints / maxPoints).ceil();
  }

  void dispose() {
    _client.close();
  }
}
