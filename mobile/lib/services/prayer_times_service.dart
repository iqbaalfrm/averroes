import 'dart:async';
import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

/// =============================================================================
/// PRAYER TIMES SERVICE - Aladhan API
/// =============================================================================
/// 
/// API: https://api.aladhan.com/v1/timings/{date}
/// Method 11 = Kemenag RI (Indonesia)
/// School 0 = Shafi'i
/// 
/// Waktu sholat yang di-parse:
/// - Fajr (Subuh)
/// - Dhuhr (Dzuhur)
/// - Asr (Ashar)
/// - Maghrib (Maghrib)
/// - Isha (Isya)
/// =============================================================================

class PrayerTimesService {
  static const String _baseUrl = 'https://api.aladhan.com/v1/timings';
  static const String _cacheKey = 'prayer_times_cache';
  
  final http.Client _client;
  final GetStorage _storage;

  PrayerTimesService({http.Client? client, GetStorage? storage})
      : _client = client ?? http.Client(),
        _storage = storage ?? GetStorage();

  /// Fetch jadwal sholat berdasarkan koordinat
  /// Menggunakan cache harian (reset saat tanggal berubah)
  Future<PrayerTimesData> getPrayerTimes({
    required double latitude,
    required double longitude,
  }) async {
    final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
    
    // Check cache
    final cached = _getCachedData();
    if (cached != null && cached.dateString == today) {
      print('🕌 [Prayer] Using cached data for $today');
      return cached;
    }

    // Fetch from API
    try {
      final data = await _fetchFromApi(latitude, longitude, today);
      await _cacheData(data);
      return data;
    } catch (e) {
      print('❌ [Prayer] API Error: $e');
      
      // Return cached data even if expired
      if (cached != null) {
        print('🕌 [Prayer] Using expired cache as fallback');
        return cached;
      }
      
      throw Exception('Gagal mengambil jadwal sholat: $e');
    }
  }

  /// Fetch from Aladhan API
  Future<PrayerTimesData> _fetchFromApi(
    double latitude,
    double longitude,
    String dateString,
  ) async {
    final uri = Uri.parse(
      '$_baseUrl/$dateString?latitude=$latitude&longitude=$longitude&method=11&school=0',
    );

    print('🕌 [Prayer] Fetching: $uri');

    final response = await _client.get(uri).timeout(
      const Duration(seconds: 15),
      onTimeout: () {
        throw TimeoutException('Request timeout');
      },
    );

    if (response.statusCode != 200) {
      throw Exception('API returned ${response.statusCode}');
    }

    final json = jsonDecode(response.body);
    
    if (json['code'] != 200) {
      throw Exception('Aladhan API error: ${json['status']}');
    }

    final timings = json['data']['timings'] as Map<String, dynamic>;
    final meta = json['data']['meta'] as Map<String, dynamic>;
    
    return PrayerTimesData(
      fajr: _parseTime(timings['Fajr']),
      sunrise: _parseTime(timings['Sunrise']),
      dhuhr: _parseTime(timings['Dhuhr']),
      asr: _parseTime(timings['Asr']),
      maghrib: _parseTime(timings['Maghrib']),
      isha: _parseTime(timings['Isha']),
      dateString: dateString,
      timezone: meta['timezone'] ?? 'Asia/Jakarta',
      latitude: latitude,
      longitude: longitude,
      lastUpdated: DateTime.now(),
    );
  }

  /// Parse time string (HH:mm) to DateTime today
  DateTime _parseTime(String timeStr) {
    // Remove timezone suffix if present (e.g., "04:32 (WIB)")
    final cleanTime = timeStr.split(' ').first;
    final parts = cleanTime.split(':');
    
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  /// Get cached data
  PrayerTimesData? _getCachedData() {
    try {
      final cached = _storage.read<Map<String, dynamic>>(_cacheKey);
      if (cached != null) {
        return PrayerTimesData.fromJson(cached);
      }
    } catch (e) {
      print('⚠️ [Prayer] Cache read error: $e');
    }
    return null;
  }

  /// Cache data
  Future<void> _cacheData(PrayerTimesData data) async {
    try {
      await _storage.write(_cacheKey, data.toJson());
      print('🕌 [Prayer] Cached for ${data.dateString}');
    } catch (e) {
      print('⚠️ [Prayer] Cache write error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

// =============================================================================
// DATA MODEL
// =============================================================================

class PrayerTimesData {
  final DateTime fajr;      // Subuh
  final DateTime sunrise;   // Syuruq
  final DateTime dhuhr;     // Dzuhur
  final DateTime asr;       // Ashar
  final DateTime maghrib;   // Maghrib
  final DateTime isha;      // Isya
  final String dateString;
  final String timezone;
  final double latitude;
  final double longitude;
  final DateTime lastUpdated;

  PrayerTimesData({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.dateString,
    required this.timezone,
    required this.latitude,
    required this.longitude,
    required this.lastUpdated,
  });

  /// Get all prayers as map
  Map<String, DateTime> get allPrayers => {
    'Subuh': fajr,
    'Dzuhur': dhuhr,
    'Ashar': asr,
    'Maghrib': maghrib,
    'Isya': isha,
  };

  /// Get next prayer from current time
  MapEntry<String, DateTime>? getNextPrayer() {
    final now = DateTime.now();
    
    for (final entry in allPrayers.entries) {
      if (entry.value.isAfter(now)) {
        return entry;
      }
    }
    
    // All prayers passed, return Fajr tomorrow
    return MapEntry('Subuh', fajr.add(const Duration(days: 1)));
  }

  /// Get current prayer (the one that just passed)
  MapEntry<String, DateTime>? getCurrentPrayer() {
    final now = DateTime.now();
    MapEntry<String, DateTime>? current;
    
    for (final entry in allPrayers.entries) {
      if (entry.value.isBefore(now) || entry.value.isAtSameMomentAs(now)) {
        current = entry;
      }
    }
    
    return current;
  }

  factory PrayerTimesData.fromJson(Map<String, dynamic> json) {
    return PrayerTimesData(
      fajr: DateTime.parse(json['fajr']),
      sunrise: DateTime.parse(json['sunrise']),
      dhuhr: DateTime.parse(json['dhuhr']),
      asr: DateTime.parse(json['asr']),
      maghrib: DateTime.parse(json['maghrib']),
      isha: DateTime.parse(json['isha']),
      dateString: json['dateString'],
      timezone: json['timezone'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fajr': fajr.toIso8601String(),
      'sunrise': sunrise.toIso8601String(),
      'dhuhr': dhuhr.toIso8601String(),
      'asr': asr.toIso8601String(),
      'maghrib': maghrib.toIso8601String(),
      'isha': isha.toIso8601String(),
      'dateString': dateString,
      'timezone': timezone,
      'latitude': latitude,
      'longitude': longitude,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  /// Format time as HH:mm
  String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
}
