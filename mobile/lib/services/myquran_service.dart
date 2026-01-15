
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modules/reels/reel_item_model.dart';

class MyQuranService {
  static const String _baseUrl = 'https://api.myquran.com/v2/quran';

  // Cache to prevent re-fetching/abuse if we already have some (optional memory cache)
  final List<ReelItem> _cache = [];

  /// Fetches [count] random verses from MyQuran API
  /// Returns a list of ReelItem
  Future<List<ReelItem>> fetchRandomVerses(int count) async {
    final List<ReelItem> results = [];
    
    // Safety limit to prevent abuse loop
    int attempts = 0;
    int maxAttempts = count * 2;

    while (results.length < count && attempts < maxAttempts) {
      attempts++;
      try {
        final reelItem = await _fetchSingleRandomVerse();
        if (reelItem != null) {
          results.add(reelItem);
          _cache.add(reelItem);
        }
      } catch (e) {
        print('MyQuran API Error (attempt $attempts): $e');
        // Continue to try next attempt, don't crash whole batch
      }
      
      // Delay slighty between requests to be polite to the API
      await Future.delayed(const Duration(milliseconds: 300));
    }

    return results;
  }

  Future<ReelItem?> _fetchSingleRandomVerse() async {
    final url = Uri.parse('$_baseUrl/ayat/acak');
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
           return _mapToReelItem(data['data']);
        }
      }
    } catch (e) {
      // Fallback or retry
      print('Random verse fetch failed: $e');
      rethrow;
    }
    return null;
  }

  Future<ReelItem?> fetchSpecificVerse(int surah, int ayah) async {
    final url = Uri.parse('$_baseUrl/ayat/$surah/$ayah');
    
    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
           return _mapToReelItem(data['data']);
        }
      }
    } catch (e) {
      print('MyQuran Specific fetch failed ($surah:$ayah): $e');
    }
    return null;
  }

  ReelItem _mapToReelItem(dynamic dataInput) {
    // Structure normalization
    // API might return { "data": {...} } or { "data": [ {...} ] } or just {...}
    
    Map<String, dynamic> content = {};
    Map<String, dynamic>? surahInfo;
    
    // If input is the 'data' wrapper itself
    dynamic actualData = dataInput;
    
    if (actualData is List) {
       if (actualData.isEmpty) throw Exception('Empty data list');
       // If list, take first item (usually contains ayah object)
       actualData = actualData.first;
    }

    // Now actualData should be a Map
    if (actualData is! Map) throw Exception('Invalid data format: $actualData');
    
    // Check if it has 'ayat' or 'ayah' key (random endpoint vs specific)
    if (actualData.containsKey('ayah')) {
      content = actualData['ayah'];
      surahInfo = actualData['surah'] ?? actualData['soorah'];
    } else if (actualData.containsKey('ayat')) {
       content = actualData['ayat'];
        surahInfo = actualData['info'] ?? actualData['surah'];
    } else {
      // Maybe it IS the ayah object itself (common in specific endpoint /ayat/x/y -> data returns the ayah object directly sometimes)
      content = actualData as Map<String, dynamic>;
      // Try to find surah info inside
      if (content.containsKey('surah')) {
        surahInfo = content['surah'];
      }
    }

    // Extraction with fallbacks
    final surahId = surahInfo?['number'] ?? surahInfo?['id'] ?? content['surah_id'] ?? 0;
    final surahName = surahInfo?['nameIndo'] ?? surahInfo?['name']?['id'] ?? surahInfo?['name_id'] ?? 'Surah';
    
    final ayatNo = content['no'] ?? content['number']?['inSurah'] ?? content['ayah'] ?? 0;
    
    // Text extraction
    String arabic = '';
    String indo = '';
    
    if (content.containsKey('text')) {
       // specific endpoint structure often: text: { arab: "", id: "" }
       final textObj = content['text'];
       if (textObj is Map) {
         arabic = textObj['arab'] ?? textObj['ar'] ?? '';
         indo = textObj['id'] ?? '';
       } else {
         indo = textObj.toString();
       }
    } else {
       // Random endpoint often: arab: "...", translation: "..."
       arabic = content['arab'] ?? content['ar'] ?? '';
       indo = content['translation'] ?? content['id'] ?? content['indo'] ?? '';
    }

    // Audio extraction
    String audioUrl = '';
    if (content.containsKey('audio')) {
      final audioObj = content['audio'];
      if (audioObj is Map) {
        audioUrl = audioObj['primary'] ?? audioObj['url'] ?? '';
      } else if (audioObj is String) {
        audioUrl = audioObj;
      }
    }

    // Convert to int properly
    final sId = int.tryParse(surahId.toString()) ?? 0;
    final aNo = int.tryParse(ayatNo.toString()) ?? 0;

    // AUDIO: Generate from Everyayah (more reliable host than Islamic Network)
    if (sId > 0 && aNo > 0) {
      final ps = sId.toString().padLeft(3, '0');
      final pa = aNo.toString().padLeft(3, '0');
      audioUrl = 'https://www.everyayah.com/data/Alafasy_128kbps/$ps$pa.mp3';
    }

    return ReelItem(
      id: 'quran_${sId}_$aNo',
      category: 'Al-Qur\'an',
      type: 'ayat',
      arabic: arabic,
      indonesia: indo,
      source: 'Q.S. $surahName : $aNo',
      audioUrl: audioUrl,
      surah: sId,
      ayah: aNo,
      verseKey: '$sId:$aNo',
    );
  }
}
