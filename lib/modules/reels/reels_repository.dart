
import '../../services/myquran_service.dart';
import '../../services/thematic_verse_picker.dart';
import 'reel_item_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReelsRepository {
  final MyQuranService _myQuranService = MyQuranService();
  final ThematicVersePicker _versePicker = ThematicVersePicker();
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ReelItem>> getReels({String category = 'Acak'}) async {
    List<ReelItem> results = [];

    // 1. Try Fetching from APIs (Supabase + MyQuran)
    try {
      // Determine strategy
      String? pickerTheme;
      if (['Sabar', 'Muamalah', 'Takdir', 'Fiqh Muamalah'].contains(category)) {
        if (category == 'Fiqh Muamalah') pickerTheme = 'muamalah';
        else pickerTheme = category.toLowerCase();
      } else if (category == 'Acak') {
        pickerTheme = 'acak';
      }

      // Parallel fetch if possible, or sequential
      List<ReelItem> remoteVerses = [];
      List<ReelItem> supabaseItems = [];

      // A. Fetch MyQuran (via Verse Picker)
      if (pickerTheme != null) {
        try {
          remoteVerses = await _versePicker.pickVerses(pickerTheme, 5);
        } catch (e) {
          print('Repo: MyQuran fetch error: $e');
        }
      }

      // B. Fetch Supabase
      try {
        var query = _supabase.from('reels_items').select().eq('is_active', true);
        if (category != 'Acak') {
          query = query.eq('category', category);
        }
        final response = await query.order('created_at', ascending: false).limit(20);
        final data = List<Map<String, dynamic>>.from(response);
        supabaseItems = data.map((e) => ReelItem.fromJson(e)).toList();
      } catch (e) {
        print('Repo: Supabase fetch error: $e');
      }

      // Combine
      results = [...remoteVerses, ...supabaseItems];
      results.shuffle();

    } catch (e) {
      print('Repo: General fetch error: $e');
    }

    // 2. CHECK: If results insufficient (< 3), use Fallback
    if (results.length < 3) {
      print('Repo: Insufficient data (${results.length}), utilizing FALLBACK.');
      final fallback = _getFallbackContent(category);
      // Append fallback to ensure we have enough data
      // Uniqueness check based on ID
      final existingIds = results.map((e) => e.id).toSet();
      for (var item in fallback) {
        if (!existingIds.contains(item.id)) {
          results.add(item);
        }
      }
    }

    return results;
  }

  List<ReelItem> _getFallbackContent(String category) {
    // Return mixed static content ensuring robust offline experience
    final List<ReelItem> allFallback = [
      ReelItem(
        id: 'fb_1',
        category: 'Sabar',
        type: 'ayat',
        arabic: 'يَا أَيُّهَا الَّذِينَ آمَنُوا اسْتَعِينُوا بِالصَّبْرِ وَالصَّلَاةِ ۚ إِنَّ اللَّهَ مَعَ الصَّابِرِينَ',
        indonesia: 'Wahai orang-orang yang beriman! Mohonlah pertolongan (kepada Allah) dengan sabar dan salat. Sungguh, Allah beserta orang-orang yang sabar.',
        source: 'Q.S. Al-Baqarah: 153',
        audioUrl: 'https://www.everyayah.com/data/Alafasy_128kbps/002153.mp3'
      ),
      ReelItem(
        id: 'fb_2',
        category: 'Takdir',
        type: 'ayat',
        arabic: 'وَعَسَىٰ أَنْ تَكْرَهُوا شَيْئًا وَهُوَ خَيْرٌ لَكُمْ ۖ وَعَسَىٰ أَنْ تُحِبُّوا شَيْئًا وَهُوَ شَرٌّ لَكُمْ ۗ وَاللَّهُ يَعْلَمُ وَأَنْتُمْ لَا تَعْلَمُونَ',
        indonesia: 'Boleh jadi kamu membenci sesuatu, padahal ia amat baik bagimu, dan boleh jadi (pula) kamu menyukai sesuatu, padahal ia amat buruk bagimu; Allah mengetahui, sedang kamu tidak mengetahui.',
        source: 'Q.S. Al-Baqarah: 216',
        audioUrl: 'https://www.everyayah.com/data/Alafasy_128kbps/002216.mp3'
      ),
      ReelItem(
        id: 'fb_3',
        category: 'Fiqh Muamalah',
        type: 'quote',
        // arabic: null,
        indonesia: 'Jual beli itu dihalalkan, sedangkan riba itu diharamkan. Setiap transaksi harus didasari keridhaan kedua belah pihak.',
        source: 'Kaidah Fiqh',
      ),
      ReelItem(
        id: 'fb_4',
        category: 'Sabar',
        type: 'ayat',
        arabic: 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا * إِنَّ مَعَ الْعُسْرِ يُسْرًا',
        indonesia: 'Maka sesungguhnya beserta kesulitan ada kemudahan, sesungguhnya beserta kesulitan itu ada kemudahan.',
        source: 'Q.S. Al-Insyirah: 5-6',
        audioUrl: 'https://www.everyayah.com/data/Alafasy_128kbps/094005.mp3'
      ),
      ReelItem(
        id: 'fb_5',
        category: 'Fiqh Muamalah',
        type: 'hadith',
        indonesia: 'Pedagang yang jujur dan terpercaya akan dikumpulkan bersama para nabi, orang-orang shiddiq, dan orang-orang yang mati syahid.',
        source: 'H.R. Tirmidzi',
      ),
      ReelItem(
        id: 'fb_6',
        category: 'Takdir',
        type: 'ayat',
        arabic: 'قُلْ لَنْ يُصِيبَنَا إِلَّا مَا كَتَبَ اللَّهُ لَنَا هُوَ مَوْلَانَا ۚ وَعَلَى اللَّهِ فَلْيَتَوَكَّلِ الْمُؤْمِنُونَ',
        indonesia: 'Katakanlah: "Sekali-kali tidak akan menimpa kami melainkan apa yang telah ditetapkan Allah untuk kami. Dialah Pelindung kami, dan hanya kepada Allah orang-orang yang beriman harus bertawakal."',
        source: 'Q.S. At-Taubah: 51',
        audioUrl: 'https://www.everyayah.com/data/Alafasy_128kbps/009051.mp3'
      ),
      ReelItem(
        id: 'fb_7',
        category: 'Sabar',
        type: 'quote',
        indonesia: 'Kemenangan itu menyertai kesabaran, jalan keluar menyertai kesulitan, dan kemudahan menyertai kesukaran.',
        source: 'Nasihat Ulama',
      ),
      ReelItem(
        id: 'fb_8',
        category: 'Fiqh Muamalah',
        type: 'ayat',
        arabic: 'يَا أَيُّهَا الَّذِينَ آمَنُوا لَا تَأْكُلُوا أَمْوَالَكُمْ بَيْنَكُمْ بِالْبَاطِلِ',
        indonesia: 'Wahai orang-orang yang beriman! Janganlah kamu saling memakan harta sesamamu dengan jalan yang batil.',
        source: 'Q.S. An-Nisa: 29',
        audioUrl: 'https://www.everyayah.com/data/Alafasy_128kbps/004029.mp3'
      ),
      ReelItem(
        id: 'fb_9',
        category: 'Takdir',
        type: 'quote',
        indonesia: 'Apa yang melewatkanmu tidak akan pernah mengenaimu, dan apa yang mengenaimu tidak akan pernah melewatkanmu.',
        source: 'Hikmah Takdir',
      ),
      ReelItem(
        id: 'fb_10',
        category: 'Sabar',
        type: 'hadith',
        indonesia: 'Sabar adalah cahaya.',
        source: 'H.R. Muslim',
      ),
    ];

    if (category == 'Acak') return allFallback;
    return allFallback.where((e) => e.category == category || _categoryMatch(e.category, category)).toList();
  }

  bool _categoryMatch(String itemCat, String filterCat) {
    if (filterCat == 'Fiqh Muamalah' && itemCat == 'Muamalah') return true;
    if (filterCat == 'Muamalah' && itemCat == 'Fiqh Muamalah') return true;
    return false;
  }
}
