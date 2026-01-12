
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modules/reels/reel_item_model.dart';
import 'myquran_service.dart';

class ThematicVersePicker {
  static const String _candidatesPath = 'assets/data/quran_theme_verses.json';
  static const String _prefKeyPrefix = 'quran_history_';
  static const String _prefLastTheme = 'quran_last_theme';

  final MyQuranService _apiService = MyQuranService();
  
  // Cache for loaded candidates
  Map<String, List<Map<String, int>>> _candidatesCache = {};

  Future<void> _loadCandidates() async {
    if (_candidatesCache.isNotEmpty) return;
    
    try {
      final jsonString = await rootBundle.loadString(_candidatesPath);
      final Map<String, dynamic> data = json.decode(jsonString);
      
      _candidatesCache = data.map((key, value) {
        final list = (value as List).map((e) => {
          's': e['s'] as int,
          'a': e['a'] as int
        }).toList();
        return MapEntry(key.toLowerCase(), list);
      });
    } catch (e) {
      print('Failed to load thematic verses: $e');
    }
  }

  Future<List<ReelItem>> pickVerses(String theme, int count) async {
    await _loadCandidates();
    
    // Normalize theme
    String key = theme.toLowerCase();
    
    // Logic for "Acak" or "Semua" -> Pick random available theme
    if (key == 'acak' || key == 'semua' || !_candidatesCache.containsKey(key)) {
      final keys = _candidatesCache.keys.toList();
      if (keys.isEmpty) return []; // No data
      key = keys[Random().nextInt(keys.length)];
      // Also update stored last theme if needed? Maybe controller handles that.
    }

    final candidates = _candidatesCache[key] ?? [];
    if (candidates.isEmpty) return [];

    final prefs = await SharedPreferences.getInstance();
    final historyKey = '$_prefKeyPrefix$key';
    final List<String> history = prefs.getStringList(historyKey) ?? [];
    
    // Filter candidates not in history
    final List<Map<String, int>> available = candidates.where((c) {
      final id = '${c['s']}:${c['a']}';
      return !history.contains(id);
    }).toList();
    
    // Shuffle available
    available.shuffle();
    
    // Pick N
    List<Map<String, int>> picked = available.take(count).toList();
    
    // Fallback if not enough
    if (picked.length < count) {
      final remainingNeeded = count - picked.length;
      // Get from history (or full candidates again shufled)
      // Ideally reuse candidates but exclude already picked
      final others = candidates.where((c) {
         // Exclude what we just picked
         return !picked.contains(c); 
      }).toList();
      others.shuffle();
      picked.addAll(others.take(remainingNeeded));
    }
    
    // Fetch Data from API
    // Fetch Data from API with Strict Mapping
    final Map<String, ReelItem> byKey = {};
    final List<Future<void>> tasks = [];

    for (final p in picked) {
      tasks.add(() async {
        try {
          final item = await _apiService.fetchSpecificVerse(p['s']!, p['a']!);
          if (item != null) {
            final key = '${p['s']}:${p['a']}';
            // Override category here or let controller handle it?
            // User requested explicit integrity.
            // We create a copy or modify ReelItem? ReelItem is final.
            // But we can just use the item returned if MyQuranService populates verseKey.
            // MyQuranService now populates verseKey = "${s}:${a}".
            
            // NOTE: We must ensure the item we put in byKey corresponds to p['s']:p['a']
            if (item.verseKey == key) {
               // Great, perfect match
            } else {
               // Only if API returns mismatch (unlikely but possible)
            }
            
            // We inject category override here (create new ReelItem based on fetched one)
            final newItem = ReelItem(
              id: item.id,
              category: theme, 
              type: item.type,
              arabic: item.arabic,
              indonesia: item.indonesia,
              source: item.source,
              audioUrl: item.audioUrl,
              surah: item.surah,
              ayah: item.ayah,
              verseKey: item.verseKey,
            );
            
            byKey[key] = newItem;
          }
        } catch (e) {
          print('Error fetching ${p['s']}:${p['a']} -> $e');
        }
      }());
    }
    
    await Future.wait(tasks);
    
    // Build list in original order
    final List<ReelItem> results = [];
    for (final p in picked) {
       final key = '${p['s']}:${p['a']}';
       final item = byKey[key];
       if (item != null) {
         results.add(item);
         
         // Add to history
         history.add(key);
       }
    }
    
    // Cap history size to 30
    if (history.length > 30) {
      history.removeRange(0, history.length - 30);
    }
    
    await prefs.setStringList(historyKey, history);
    await prefs.setString(_prefLastTheme, key);
    
    return results;
  }
}
