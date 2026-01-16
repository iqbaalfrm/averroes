import '../../services/api_client.dart';
import '../../services/myquran_service.dart';
import '../../services/thematic_verse_picker.dart';
import 'reel_item_model.dart';

class ReelsRepository {
  final MyQuranService _myQuranService = MyQuranService();
  final ThematicVersePicker _versePicker = ThematicVersePicker();

  Future<List<ReelItem>> getReels({String category = 'Acak'}) async {
    List<ReelItem> results = [];

    try {
      String? pickerTheme;
      if (['Sabar', 'Muamalah', 'Takdir', 'Fikih Muamalah'].contains(category)) {
        if (category == 'Fikih Muamalah') pickerTheme = 'muamalah';
        else pickerTheme = category.toLowerCase();
      } else if (category == 'Acak') {
        pickerTheme = 'acak';
      }

      List<ReelItem> remoteVerses = [];
      List<ReelItem> apiItems = [];

      if (pickerTheme != null) {
        try {
          remoteVerses = await _versePicker.pickVerses(pickerTheme, 5);
        } catch (e) {
          print('Repo: MyQuran fetch error: $e');
        }
      }

      try {
        final response = await ApiClient.get('/reels');
        final data = response.data as Map<String, dynamic>;
        final rows = List<Map<String, dynamic>>.from(data['data'] ?? []);
        apiItems = rows.map((e) => ReelItem.fromJson(e)).toList();
      } catch (e) {
        print('Repo: API fetch error: $e');
      }

      results = [...remoteVerses, ...apiItems];
      results.shuffle();

    } catch (e) {
      print('Repo: General fetch error: $e');
    }

    if (results.length < 3) {
      print('Repo: Insufficient data (${results.length}), utilizing FALLBACK.');
      final fallback = _getFallbackContent(category);
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
    final List<ReelItem> allFallback = [
      ReelItem(
        id: 'fb_1',
        category: 'Sabar',
        type: 'ayat',
        arabic: '??? ???????? ????????? ??????? ???????????? ??????????? ???????????? ? ????? ??????? ???? ?????????????',
        indonesia: 'Wahai orang-orang yang beriman! Mohonlah pertolongan (kepada Allah) dengan sabar dan salat. Sungguh, Allah beserta orang-orang yang sabar.',
        source: 'Q.S. Al-Baqarah: 153',
        audioUrl: 'https://www.everyayah.com/data/Alafasy_128kbps/002153.mp3'
      ),
      ReelItem(
        id: 'fb_2',
        category: 'Takdir',
        type: 'ayat',
        arabic: '???????? ??? ?????????? ??????? ?????? ?????? ??????? ? ???????? ??? ????????? ??????? ?????? ????? ??????? ? ????????? ???????? ????????? ??? ???????????',
        indonesia: 'Boleh jadi kamu membenci sesuatu, padahal ia amat baik bagimu, dan boleh jadi (pula) kamu menyukai sesuatu, padahal ia amat buruk bagimu; Allah mengetahui, sedang kamu tidak mengetahui.',
        source: 'Q.S. Al-Baqarah: 216',
        audioUrl: 'https://www.everyayah.com/data/Alafasy_128kbps/002216.mp3'
      ),
      ReelItem(
        id: 'fb_3',
        category: 'Fikih Muamalah',
        type: 'quote',
        indonesia: 'Jual beli itu dihalalkan, sedangkan riba itu diharamkan. Setiap transaksi harus didasari keridhaan kedua belah pihak.',
        source: 'Kaidah Fikih',
      ),
      ReelItem(
        id: 'fb_4',
        category: 'Sabar',
        type: 'ayat',
        arabic: '??????? ???? ????????? ??????? * ????? ???? ????????? ???????',
        indonesia: 'Maka sesungguhnya beserta kesulitan ada kemudahan, sesungguhnya beserta kesulitan itu ada kemudahan.',
        source: 'Q.S. Al-Insyirah: 5-6',
        audioUrl: 'https://www.everyayah.com/data/Alafasy_128kbps/094005.mp3'
      ),
      ReelItem(
        id: 'fb_5',
        category: 'Fikih Muamalah',
        type: 'hadith',
        indonesia: 'Pedagang yang jujur dan terpercaya akan dikumpulkan bersama para nabi, orang-orang shiddiq, dan orang-orang yang mati syahid.',
        source: 'H.R. Tirmidzi',
      ),
      ReelItem(
        id: 'fb_6',
        category: 'Takdir',
        type: 'ayat',
        arabic: '??? ???? ?????????? ?????? ??? ?????? ??????? ????? ???? ?????????? ? ??????? ??????? ??????????????? ??????????????',
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
        category: 'Fikih Muamalah',
        type: 'ayat',
        arabic: '??? ???????? ????????? ??????? ??? ?????????? ???????????? ????????? ????????????',
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
    if (filterCat == 'Fikih Muamalah' && itemCat == 'Muamalah') return true;
    if (filterCat == 'Muamalah' && itemCat == 'Fikih Muamalah') return true;
    return false;
  }
}
