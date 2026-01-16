import 'dart:async';
import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

/// =============================================================================
/// CURRENCY SERVICE - USD to IDR Conversion
/// =============================================================================
/// 
/// Fitur:
/// - Fetch real-time USD/IDR rate
/// - Cache 60 detik
/// - Fallback ke rate estimasi
/// =============================================================================

class CurrencyService {
  static const String _cacheKey = 'usd_idr_rate';
  static const Duration _cacheDuration = Duration(seconds: 60);
  
  final http.Client _client;
  final GetStorage _storage;
  
  // Cache in-memory untuk performa
  double? _cachedRate;
  DateTime? _cacheTime;

  CurrencyService({http.Client? client, GetStorage? storage})
      : _client = client ?? http.Client(),
        _storage = storage ?? GetStorage();

  /// Get USD to IDR rate
  Future<double> getUsdToIdrRate() async {
    // Check in-memory cache
    if (_cachedRate != null && _cacheTime != null) {
      if (DateTime.now().difference(_cacheTime!) < _cacheDuration) {
        return _cachedRate!;
      }
    }

    // Fetch fresh rate
    try {
      final rate = await _fetchRate();
      _cachedRate = rate;
      _cacheTime = DateTime.now();
      await _storage.write(_cacheKey, rate);
      return rate;
    } catch (e) {
      print('⚠️ [Currency] Fetch failed: $e');
      
      // Try storage cache
      final stored = _storage.read<double>(_cacheKey);
      if (stored != null) {
        _cachedRate = stored;
        return stored;
      }
      
      // Ultimate fallback
      return 15800.0; // Estimasi USD/IDR
    }
  }

  Future<double> _fetchRate() async {
    final uri = Uri.parse('https://api.exchangerate-api.com/v4/latest/USD');
    
    final response = await _client.get(uri).timeout(
      const Duration(seconds: 10),
    );
    
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final rates = json['rates'] as Map<String, dynamic>?;
      
      if (rates != null && rates.containsKey('IDR')) {
        final rate = (rates['IDR'] as num).toDouble();
        print('💱 [Currency] USD/IDR: $rate');
        return rate;
      }
    }
    
    throw Exception('Gagal mengambil kurs');
  }

  /// Convert USD to IDR
  Future<double> convertUsdToIdr(double usd) async {
    final rate = await getUsdToIdrRate();
    return usd * rate;
  }

  void dispose() {
    _client.close();
  }
}
