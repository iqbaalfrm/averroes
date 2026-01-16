import 'news_models.dart';

final List<NewsItem> newsDummyItems = [
  NewsItem(
    id: 'local-1',
    title: 'Kripto syariah makin dilirik investor muda, ini alasannya',
    source: 'Kriptowave',
    url: 'https://cryptowave.co.id',
    publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
    imageUrl: null,
    isLocal: true,
  ),
  NewsItem(
    id: 'local-2',
    title: 'Peta regulasi aset digital Indonesia makin jelas di 2026',
    source: 'Coinvestasi',
    url: 'https://coinvestasi.com',
    publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
    imageUrl: null,
    isLocal: true,
  ),
  NewsItem(
    id: 'local-3',
    title: 'Tips memilih aset kripto halal untuk pemula',
    source: 'Kriptowave',
    url: 'https://cryptowave.co.id',
    publishedAt: DateTime.now().subtract(const Duration(days: 1)),
    imageUrl: null,
    isLocal: true,
  ),
  NewsItem(
    id: 'local-4',
    title: 'Perkembangan zakat aset digital di Asia Tenggara',
    source: 'Coinvestasi',
    url: 'https://coinvestasi.com',
    publishedAt: DateTime.now().subtract(const Duration(days: 2)),
    imageUrl: null,
    isLocal: true,
  ),
  NewsItem(
    id: 'local-5',
    title: 'Kenapa analisis fikih penting di era rantai blok',
    source: 'Kriptowave',
    url: 'https://cryptowave.co.id',
    publishedAt: DateTime.now().subtract(const Duration(days: 3)),
    imageUrl: null,
    isLocal: true,
  ),
];
