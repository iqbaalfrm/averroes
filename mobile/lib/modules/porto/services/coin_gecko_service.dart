import 'dart:convert';
import 'package:http/http.dart' as http;

class CoinGeckoService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';
  
  // Simple in-memory cache: {coinIdsString: {timestamp: time, data: json}}
  final Map<String, _CacheEntry> _priceCache = {};
  static const Duration _cacheDuration = Duration(seconds: 45);

  /// Fetch simple prices for multiple IDs
  /// ids: comma-separated list of coin ids (e.g. "bitcoin,ethereum")
  Future<Map<String, dynamic>> getSimplePrices(List<String> coinIds) async {
    if (coinIds.isEmpty) return {};

    final idsString = coinIds.join(',');
    
    // Check Cache
    if (_priceCache.containsKey(idsString)) {
      final entry = _priceCache[idsString]!;
      if (DateTime.now().difference(entry.timestamp) < _cacheDuration) {
        print('CoinGecko: Using cached prices for $idsString');
        return entry.data;
      }
    }

    // Fetch API
    final url = Uri.parse('$_baseUrl/simple/price?ids=$idsString&vs_currencies=idr,usd');
    try {
      print('CoinGecko: Fetching prices for $idsString');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        
        // Save Cache
        _priceCache[idsString] = _CacheEntry(DateTime.now(), data);
        return data;
      } else {
        print('CoinGecko API Error: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('CoinGecko Exception: $e');
      return {};
    }
  }
  
  /// Search coins for autocomplete (Optional helper)
  Future<List<Map<String, dynamic>>> searchCoins(String query) async {
    final url = Uri.parse('$_baseUrl/search?query=$query');
    try {
      final response = await http.get(url);
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

class _CacheEntry {
  final DateTime timestamp;
  final Map<String, dynamic> data;
  _CacheEntry(this.timestamp, this.data);
}
