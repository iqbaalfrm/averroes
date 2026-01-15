import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

import '../../core/domain/entities/article.dart';
import '../../services/api_client.dart';
import '../../services/app_session_controller.dart';
import '../../config/env_config.dart';

/// =============================================================================
/// ARTIKEL CONTROLLER
/// =============================================================================
/// Controller untuk manage state artikel dari RSS
/// =============================================================================

class ArtikelController extends GetxController {
  final GetStorage _storage = GetStorage();
  final AppSessionController _session = Get.find<AppSessionController>();

  // Observable state
  final RxList<Article> articles = <Article>[].obs;
  final RxList<Article> filteredArticles = <Article>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedFilter = 'Semua'.obs;
  final Rx<DateTime?> lastFetchTime = Rx<DateTime?>(null);

  // Storage keys
  static const String _cacheKey = 'articles_cache';
  static const String _timestampKey = 'articles_timestamp';

  // Rate limiting
  static const Duration _minRefreshInterval = Duration(minutes: 10);

  @override
  void onInit() {
    super.onInit();
    _loadFromCache();
    fetchArticles();
  }

  /// Fetch articles dari API
  Future<void> fetchArticles({bool forceRefresh = false}) async {
    // Rate limiting check
    if (!forceRefresh && lastFetchTime.value != null) {
      final timeSinceLastFetch = DateTime.now().difference(lastFetchTime.value!);
      if (timeSinceLastFetch < _minRefreshInterval) {
        print('⏱️ [Artikel] Rate limited. Wait ${_minRefreshInterval.inMinutes - timeSinceLastFetch.inMinutes} more minutes');
        return;
      }
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await ApiClient.get('/articles', query: {
        'per_page': 20,
      });
      final data = response.data as Map<String, dynamic>;
      final rows = List<Map<String, dynamic>>.from(data['data'] ?? []);
      final fetchedArticles = rows.map(_mapApiArticle).toList();

      if (fetchedArticles.isNotEmpty) {
        articles.assignAll(fetchedArticles);
        _saveToCache(fetchedArticles);
      } else if (!_session.isDemoMode.value && !EnvConfig.isProduction) {
        articles.assignAll(_dummyArticles);
      } else {
        articles.clear();
      }
      
      lastFetchTime.value = DateTime.now();
      
      // Apply current filter
      _applyFilter();

      print('✅ [Artikel] Fetched ${fetchedArticles.length} articles');
    } catch (e) {
      errorMessage.value = ''; // Don't show error to user if we have dummy/cache
      print('⚠️ [Artikel] Error: $e');

      // Use dummy data as last resort (dev only)
      if (articles.isEmpty && !EnvConfig.isProduction) {
        articles.assignAll(_dummyArticles);
        _applyFilter();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Set filter
  void setFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilter();
  }

  /// Apply filter to articles
  void _applyFilter() {
    if (selectedFilter.value == 'Semua') {
      filteredArticles.assignAll(articles);
    } else {
      final filtered = articles.where((article) {
        final tag = article.queryTag.toLowerCase();
        final source = article.source.toLowerCase();
        final filterLower = selectedFilter.value.toLowerCase();

        return tag.contains(filterLower) || source.contains(filterLower);
      }).toList();

      filteredArticles.assignAll(filtered);
    }
  }

  /// Save to cache
  void _saveToCache(List<Article> articles) {
    try {
      final jsonList = articles.map((a) => a.toJson()).toList();
      _storage.write(_cacheKey, jsonEncode(jsonList));
      _storage.write(_timestampKey, DateTime.now().toIso8601String());
    } catch (e) {
      print('⚠️ [Artikel] Cache save error: $e');
    }
  }

  /// Load from cache
  void _loadFromCache() {
    try {
      final cached = _storage.read<String>(_cacheKey);
      final timestamp = _storage.read<String>(_timestampKey);

      if (cached != null && timestamp != null) {
        final jsonList = jsonDecode(cached) as List;
        final cachedArticles = jsonList
            .map((json) => Article.fromJson(json as Map<String, dynamic>))
            .toList();

        articles.assignAll(cachedArticles);
        lastFetchTime.value = DateTime.parse(timestamp);
        _applyFilter();

        print('✅ [Artikel] Loaded ${cachedArticles.length} articles from cache');
      }
    } catch (e) {
      print('⚠️ [Artikel] Cache load error: $e');
    }
  }

  /// Refresh (pull-to-refresh)
  Future<void> refresh() async {
    await fetchArticles(forceRefresh: true);
  }

  /// DUMMY DATA FOR UI DEMO (15 items)
  List<Article> get _dummyArticles => [
    Article(
      id: 'dummy_1',
      title: 'Hukum Investasi Crypto dalam Fiqh Muamalah Kontemporer',
      link: 'https://cryptosyaria.com/edukasi/hukum-crypto',
      source: 'Internal Syariah',
      publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
      snippet: 'Kajian mendalam mengenai aset kripto dari sudut pandang pakar ekonomi syariah dan dewan fatwa.',
      queryTag: 'Syariah',
      content: "Investasi aset kripto telah menjadi fenomena global yang menarik perhatian masyarakat luas. Namun, muncul pertanyaan mendasar: bagaimana hukumnya dalam Islam? Berdasarkan kajian Fiqh Muamalah Kontemporer, aset kripto dapat dikategorikan sebagai 'Maal' (harta) karena memiliki nilai (Mutaqawwim) dan dapat disimpan serta dimanfaatkan.\n\nPara ulama menekankan bahwa selama aset tersebut terbebas dari unsur Riba, Gharar (ketidakpastian yang berlebihan), dan Maysir (perjudian), maka hukum asalnya adalah mubah (boleh). Penting bagi investor untuk memahami underlying project dari setiap koin guna memastikan tidak adanya aktivitas yang bertentangan dengan syariat.",
    ),
    Article(
      id: 'dummy_2',
      title: 'Bitcoin Mencapai All-Time High Baru: Apa Kata Investor Muslim?',
      link: 'https://cryptosyaria.com/market/btc-ath-2026',
      source: 'Market Update',
      publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
      snippet: 'Analisis pergerakan harga pasar crypto global dan pentingnya manajemen risiko yang syar\'i.',
      queryTag: 'Market',
      content: "Bitcoin kembali mencetak rekor harga tertinggi sepanjang masa (ATH) di tahun 2026. Lonjakan ini memicu euphoria di pasar digital. Bagi investor muslim, momen ini harus disikapi dengan bijak (Tasharruf). Keserakahan (Tam'u) harus dihindari agar investasi tidak berubah menjadi spekulasi murni.\n\nStrategi 'Take Profit' sebagian secara berkala disarankan untuk mengamankan modal, sesuai dengan prinsip menjaga harta (Hifdzul Maal). Selain itu, pastikan setiap keuntungan yang diperoleh tetap dihitung kewajiban zakatnya jika telah memenuhi nishab dan haul.",
    ),
    Article(
      id: 'dummy_3',
      title: 'Panduan Praktis Menghitung Zakat Aset Kripto Akhir Tahun',
      link: 'https://cryptosyaria.com/zakat/panduan-lengkap',
      source: 'Edukasi Zakat',
      publishedAt: DateTime.now().subtract(const Duration(hours: 5)),
      snippet: 'Langkah demi langkah bagi muzakki untuk membersihkan harta dari keuntungan trading.',
      queryTag: 'Syariah',
      content: "Zakat adalah kewajiban yang harus ditunaikan untuk membersihkan harta. Untuk aset kripto, metode penghitungan merujuk pada zakat perdagangan (Urudh Tijarah). Besaran zakatnya adalah 2.5% dari nilai pasar saat mencapai haul.\n\nContoh: Jika total nilai portofolio Anda di akhir tahun mencapai nishab (setara 85 gram emas) dan telah dimiliki selama setahun (haul), maka wajib dikeluarkan zakatnya. Penggunaan fitur kalkulator zakat di aplikasi Averroes dapat membantu menghitung nilai akurat berdasarkan harga pasar terkini secara otomatis.",
    ),
    Article(
      id: 'dummy_4',
      title: 'Daftar 10 Aset Kripto Syariah Paling Stabil di Tahun 2026',
      link: 'https://cryptosyaria.com/screener/top-10-syariah',
      source: 'Screener Pro',
      publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      snippet: 'Hasil screening berkala menggunakan metodologi kepatuhan syariah yang ketat.',
      queryTag: 'Screener',
      content: "Pasar kripto dikenal dengan volatilitasnya. Namun, beberapa proyek menunjukkan stabilitas fundamental yang kuat dengan model bisnis yang transparan. Tim Screener Averroes telah merilis daftar 10 aset yang memiliki track record kepatuhan syariah terbaik.\n\nKriteria penilaian mencakup tidak hanya aspek keuangan, tetapi juga kebermanfaatan proyek tersebut di dunia nyata (Real World Asset). Pastikan Anda membaca whitepaper dan memahami roadmap proyek sebelum mengalokasikan dana.",
    ),
    Article(
      id: 'dummy_5',
      title: 'Bahaya Gharar dalam Transaksi Futures dan Margin Trading',
      link: 'https://cryptosyaria.com/edukasi/bahaya-futures',
      source: 'Akademi Syariah',
      publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      snippet: 'Mengapa derivatif crypto sering kali dianggap tidak sesuai dengan prinsip syariah.',
      queryTag: 'Syariah',
      content: "Trading futures dan margin sering kali melibatkan unsur spekulasi tinggi dan leverage yang tidak didukung oleh kepemilikan aset secara fisik atau digital secara penuh di awal (Qabd). Hal ini menciptakan celah 'Gharar' yang dilarang dalam Islam.\n\nPrinsip Syariah mengarahkan pada transaksi 'Spot' di mana pertukaran terjadi secara langsung dan pasti. Hindari penggunaan hutang berbunga (margin interest) yang jelas masuk dalam kategori Riba.",
    ),
    Article(
      id: 'dummy_6',
      title: 'Stablecoin vs Fiat: Memahami Konsep Uang dalam Islam',
      link: 'https://cryptosyaria.com/edukasi/stablecoin-islam',
      source: 'Internal Syariah',
      publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
      snippet: 'Apakah USDT dan USDC dapat dikategorikan sebagai alat tukar yang sah secara syar\'i?',
      queryTag: 'Syariah',
    ),
    Article(
      id: 'dummy_7',
      title: 'Ethereum 2.0 dan Dampaknya terhadap Konsumsi Energi',
      link: 'https://cryptosyaria.com/market/eth-energy',
      source: 'Tech News',
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      snippet: 'Perubahan mekanisme konsensus membawa dampak positif bagi lingkungan dan keberlanjutan.',
      queryTag: 'Market',
    ),
    Article(
      id: 'dummy_8',
      title: 'Mengapa Diversifikasi itu Penting dalam Investasi Kripto?',
      link: 'https://cryptosyaria.com/psikologi/diversifikasi',
      source: 'Psikologi Trading',
      publishedAt: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      snippet: 'Menjaga kesehatan mental dan finansial dengan tidak menaruh semua telur dalam satu keranjang.',
      queryTag: 'Market',
    ),
    Article(
      id: 'dummy_9',
      title: 'Etika Berkomunitas di Ekosistem Decentralized Finance (DeFi)',
      link: 'https://cryptosyaria.com/edukasi/etika-defi',
      source: 'Internal Syariah',
      publishedAt: DateTime.now().subtract(const Duration(days: 3)),
      snippet: 'Prinsip tolong menolong (Ta\'awun) yang bisa diterapkan dalam protokol keuangan terdesentralisasi.',
      queryTag: 'Syariah',
    ),
    Article(
      id: 'dummy_10',
      title: 'Review Aplikasi Crypto Syariah Terbaik di Indonesia',
      link: 'https://cryptosyaria.com/review/apps-2026',
      source: 'Komunitas Crypto',
      publishedAt: DateTime.now().subtract(const Duration(days: 3, hours: 8)),
      snippet: 'Perbandingan fitur keamanan dan kemudahan penggunaan antar platform bursa lokal.',
      queryTag: 'Market',
    ),
    Article(
      id: 'dummy_11',
      title: 'Mengenal Teknologi Blockchain: Jembatan Menuju Transparansi',
      link: 'https://cryptosyaria.com/edukasi/blockchain-intro',
      source: 'Akademi Syariah',
      publishedAt: DateTime.now().subtract(const Duration(days: 4)),
      snippet: 'Bagaimana teknologi ledger terdistribusi membantu mewujudkan amanah dalam bertransaksi.',
      queryTag: 'Syariah',
    ),
    Article(
      id: 'dummy_12',
      title: 'Analisis On-Chain: Melihat Pergerakan Whale Bitcoin',
      link: 'https://cryptosyaria.com/market/on-chain-whale',
      source: 'Market Update',
      publishedAt: DateTime.now().subtract(const Duration(days: 4, hours: 12)),
      snippet: 'Memahami data publik di blockchain untuk memprediksi arah pasar secara cerdas.',
      queryTag: 'Market',
    ),
    Article(
      id: 'dummy_13',
      title: 'Zakat Fitrah dengan Crypto: Apakah Diperbolehkan?',
      link: 'https://cryptosyaria.com/zakat/fitrah-crypto',
      source: 'Edukasi Zakat',
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      snippet: 'Kajian hukum menggunakan aset digital sebagai medium pembayaran kewajiban rutin.',
      queryTag: 'Syariah',
    ),
    Article(
      id: 'dummy_14',
      title: 'Pentingnya Literasi Digital bagi Investor Pemula',
      link: 'https://cryptosyaria.com/psikologi/literasi-digital',
      source: 'Psikologi Trading',
      publishedAt: DateTime.now().subtract(const Duration(days: 5, hours: 18)),
      snippet: 'Membangun fondasi pengetahuan sebelum terjun ke dunia investasi yang volatil.',
      queryTag: 'Market',
    ),
    Article(
      id: 'dummy_15',
      title: 'Masa Depan Web3 dan Potensinya bagi Ekonomi Umat',
      link: 'https://cryptosyaria.com/edukasi/web3-future',
      source: 'Internal Syariah',
      publishedAt: DateTime.now().subtract(const Duration(days: 6)),
      snippet: 'Bagaimana internet masa depan bisa memberikan kedaulatan data bagi pengguna muslim.',
      queryTag: 'Syariah',
    ),
  ];

  /// Get available filters
  List<String> get availableFilters {
    final filters = <String>{'Semua'};
    
    for (final article in articles) {
      filters.add(article.queryTag);
    }

    return filters.toList();
  }

  Article _mapApiArticle(Map<String, dynamic> row) {
    return Article(
      id: row['id']?.toString() ?? '',
      title: row['title'] as String? ?? '',
      link: row['url'] as String? ?? '',
      source: row['source'] as String? ?? 'Averroes',
      publishedAt: DateTime.tryParse(row['published_at']?.toString() ?? '') ??
          DateTime.now(),
      snippet: row['excerpt'] as String? ?? row['content'] as String?,
      imageUrl: row['cover_image_url'] as String? ?? row['image_url'] as String?,
      queryTag: row['source'] as String? ?? 'Averroes',
      content: row['content'] as String?,
    );
  }
}
